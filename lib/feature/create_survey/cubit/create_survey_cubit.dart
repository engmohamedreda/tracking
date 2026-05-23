import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/create_survey_request.dart';
import '../model/survey_answer_request.dart';
import '../model/survey_attachment_request.dart';
import 'create_survey_state.dart';
import 'create_survey_usecase.dart';

@injectable
class CreateSurveyCubit extends Cubit<CreateSurveyState> {
  final CreateSurveyUseCase createSurveyUseCase;

  CreateSurveyCubit(this.createSurveyUseCase) : super(CreateSurveyInitial());

  Future<void> createSurvey({
    required CreateSurveyRequest request,
  }) async {
    emit(CreateSurveyLoading());

    final result = await createSurveyUseCase(request: request);

    result.fold(
      (failure) {
        emit(CreateSurveyError(failure));
      },
      (response) {
        emit(CreateSurveySuccess(response));
      },
    );
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
}
