import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/export_surveys_response.dart';
import 'export_surveys_state.dart';
import 'export_surveys_usecase.dart';

@injectable
class ExportSurveysCubit extends Cubit<ExportSurveysState> {
  final ExportSurveysUseCase exportSurveysUseCase;

  ExportSurveysCubit(this.exportSurveysUseCase) : super(ExportSurveysInitial());

  DateTime? selectedFrom;
  DateTime? selectedTo;
  int? selectedBranchId;
  int? selectedCompanyId;
  String? selectedStatus;
  int page = 1;
  int pageSize = 100;

  /// بينزل الملف من السيرفر بس، من غير حفظ.
  /// مفيدة لو عايز تعمل بحاجة تانية بالـ bytes.
  Future<ExportSurveysResponse?> export({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int pageSize = 100,
  }) async {
    _cacheFilters(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    emit(ExportSurveysLoading());

    final result = await exportSurveysUseCase(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    if (isClosed) return null;

    return result.fold(
      (failure) {
        emit(ExportSurveysError(failure));
        return null;
      },
      (response) => response,
    );
  }

  /// بينزل الملف ويفتح نافذة الحفظ.
  /// على الويب المتصفح هو اللي بينزّل الملف و saveFile بترجع null دايماً،
  /// فبنستخدم kIsWeb علشان منحسبهاش إلغاء.
  Future<void> exportAndSave({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int pageSize = 100,
  }) async {
    _cacheFilters(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    emit(ExportSurveysLoading());

    final result = await exportSurveysUseCase(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: pageSize,
    );

    if (isClosed) return;

    await result.fold(
      (failure) async {
        emit(ExportSurveysError(failure));
      },
      (response) async {
        emit(ExportSurveysLoading(message: 'جاري حفظ الملف...'));

        try {
          final savedPath = await FilePicker.platform.saveFile(
            dialogTitle: 'تصدير المعاملات',
            fileName: response.fileName,
            type: FileType.custom,
            allowedExtensions: const ['xlsx'],
            bytes: response.bytes,
          );

          if (isClosed) return;

          if (!kIsWeb && savedPath == null) {
            emit(ExportSurveysSaveCancelled(response: response));
            return;
          }

          emit(
            ExportSurveysSuccess(
              response: response,
              savedPath: savedPath,
            ),
          );
        } catch (e) {
          if (isClosed) return;
          emit(
            ExportSurveysError(
              ServerError(errorMsg: e.toString()),
            ),
          );
        }
      },
    );
  }

  /// بيعيد التصدير بنفس الفلاتر المستخدمة آخر مرة.
  Future<void> retry() async {
    await exportAndSave(
      from: selectedFrom,
      to: selectedTo,
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      status: selectedStatus,
      page: page,
      pageSize: pageSize,
    );
  }

  void reset() {
    emit(ExportSurveysInitial());
  }

  void _cacheFilters({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    required int page,
    required int pageSize,
  }) {
    selectedFrom = from;
    selectedTo = to;
    selectedBranchId = branchId;
    selectedCompanyId = companyId;
    selectedStatus = status;
    this.page = page;
    this.pageSize = pageSize;
  }
}
