import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../../get_survey_by_id/cubit/get_survey_by_id_usecase.dart';
import '../model/create_survey_request.dart';
import '../model/create_survey_response.dart';
import '../model/survey_answer_request.dart';
import '../model/survey_attachment_request.dart';
import 'create_survey_state.dart';
import 'create_survey_usecase.dart';

@injectable
class CreateSurveyCubit extends Cubit<CreateSurveyState> {
  final CreateSurveyUseCase createSurveyUseCase;
  final GetSurveyByIdUseCase getSurveyByIdUseCase;

  CreateSurveyCubit(
    this.createSurveyUseCase,
    this.getSurveyByIdUseCase,
  ) : super(CreateSurveyInitial());

  static const Duration fingerprintRefreshDelay = Duration(seconds: 5);

  bool _stopFingerprintPolling = false;

  /// Saves the survey only, without waiting for fingerprint confirmation.
  Future<void> createSurvey({
    required CreateSurveyRequest request,
  }) async {
    _stopFingerprintPolling = false;
    emit(CreateSurveyLoading(message: 'جاري حفظ الاستبيان...'));
    await _createSurveyOnly(request: request);
  }

  /// Correct flow:
  /// 1) CreateSurvay.
  /// 2) Take the id returned from CreateSurvay.
  /// 3) Call GetSurvayById?id={createdSurveyId}.
  /// 4) If isFingerPrint == false, refresh every 5 seconds.
  /// 5) If isFingerPrint == true, finish and return success to move to next client.
  Future<void> createSurveyAndWaitForFingerprint({
    required CreateSurveyRequest request,
  }) async {
    _stopFingerprintPolling = false;

    emit(CreateSurveyLoading(message: 'جاري حفظ الاستبيان...'));

    final createResult = await createSurveyUseCase(request: request);

    if (_stopFingerprintPolling || isClosed) return;

    await createResult.fold(
      (failure) async {
        emit(CreateSurveyError(failure));
      },
      (createResponse) async {
        final createdSurveyId = createResponse.id;

        if (createdSurveyId <= 0) {
          emit(
            CreateSurveyError(
              ServerError(
                errorMsg:
                    'تم إنشاء الاستبيان لكن لم يرجع رقم استبيان صحيح.',
              ),
            ),
          );
          return;
        }

        await _pollFingerprintUntilConfirmed(
          surveyId: createdSurveyId,
          createResponse: createResponse,
        );
      },
    );
  }

  /// Kept for backward compatibility with older screens.
  /// The passed surveyId is no longer used because the backend returns the
  /// correct id from CreateSurvay, and that id must be used in GetSurvayById.
  Future<void> createSurveyAfterFingerprint({
    required int surveyId,
    required CreateSurveyRequest request,
  }) async {
    await createSurveyAndWaitForFingerprint(request: request);
  }

  Future<void> createSurveyFromFlow({
    required int companyId,
    required int brandId,
    required int mobileId,
    required int representativeId,
    required int areaId,
    required int ticketId,
    required List<SurveyAnswerRequest> surveyAnswers,
    String userId = '',
    String note = '',
    String status = '',
    List<SurveyAttachmentRequest> surveyAttachments = const [],
  }) async {
    final request = CreateSurveyRequest.fromFlow(
      companyId: companyId,
      brandId: brandId,
      mobileId: mobileId,
      userId: userId,
      representativeId: representativeId,
      areaId: areaId,
      ticketId: ticketId,
      surveyAnswers: surveyAnswers,
      note: note,
      status: status,
      surveyAttachments: surveyAttachments,
    );

    await createSurvey(request: request);
  }

  Future<void> createSurveyFromFlowAndWaitForFingerprint({
    required int companyId,
    required int brandId,
    required int mobileId,
    required int representativeId,
    required int areaId,
    required int ticketId,
    required List<SurveyAnswerRequest> surveyAnswers,
    String userId = '',
    String note = '',
    String status = '',
    List<SurveyAttachmentRequest> surveyAttachments = const [],
  }) async {
    final request = CreateSurveyRequest.fromFlow(
      companyId: companyId,
      brandId: brandId,
      mobileId: mobileId,
      userId: userId,
      representativeId: representativeId,
      areaId: areaId,
      ticketId: ticketId,
      surveyAnswers: surveyAnswers,
      note: note,
      status: status,
      surveyAttachments: surveyAttachments,
    );

    await createSurveyAndWaitForFingerprint(request: request);
  }

  /// Kept for backward compatibility with older screens.
  Future<void> createSurveyFromFlowAfterFingerprint({
    required int surveyId,
    required int companyId,
    required int brandId,
    required int mobileId,
    required int representativeId,
    required int areaId,
    required int ticketId,
    required List<SurveyAnswerRequest> surveyAnswers,
    String userId = '',
    String note = '',
    String status = '',
    List<SurveyAttachmentRequest> surveyAttachments = const [],
  }) async {
    await createSurveyFromFlowAndWaitForFingerprint(
      companyId: companyId,
      brandId: brandId,
      mobileId: mobileId,
      userId: userId,
      representativeId: representativeId,
      areaId: areaId,
      ticketId: ticketId,
      surveyAnswers: surveyAnswers,
      note: note,
      status: status,
      surveyAttachments: surveyAttachments,
    );
  }

  Future<void> _pollFingerprintUntilConfirmed({
    required int surveyId,
    required CreateSurveyResponse createResponse,
  }) async {
    var attempt = 0;

    while (!_stopFingerprintPolling && !isClosed) {
      attempt++;

      emit(
        CreateSurveyLoading(
          message: attempt == 1
              ? 'جاري التحقق من حالة البصمة...'
              : 'جاري تحديث حالة البصمة...',
        ),
      );

      final surveyResult = await getSurveyByIdUseCase(id: surveyId);

      if (_stopFingerprintPolling || isClosed) return;

      final shouldRefreshAgain = surveyResult.fold(
        (failure) {
          emit(CreateSurveyError(failure));
          return false;
        },
        (survey) {
          if (survey.isFingerPrint) {
            emit(
              CreateSurveySuccess(
                createResponse,
                fingerprintSurvey: survey,
              ),
            );
            return false;
          }

          emit(
            CreateSurveyWaitingFingerprint(
              surveyId: surveyId,
              survey: survey,
              attempt: attempt,
              nextRefreshSeconds: fingerprintRefreshDelay.inSeconds,
            ),
          );
          return true;
        },
      );

      if (!shouldRefreshAgain) return;

      await Future.delayed(fingerprintRefreshDelay);
    }
  }

  Future<void> _createSurveyOnly({
    required CreateSurveyRequest request,
  }) async {
    final result = await createSurveyUseCase(request: request);

    if (_stopFingerprintPolling || isClosed) return;

    result.fold(
      (failure) => emit(CreateSurveyError(failure)),
      (response) => emit(CreateSurveySuccess(response)),
    );
  }

  @override
  Future<void> close() {
    _stopFingerprintPolling = true;
    return super.close();
  }
}
