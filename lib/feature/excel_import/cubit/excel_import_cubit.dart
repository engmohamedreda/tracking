import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/excel_import_file.dart';
import '../model/excel_import_type.dart';
import 'excel_import_state.dart';
import 'excel_import_usecase.dart';

@injectable
class ExcelImportCubit extends Cubit<ExcelImportState> {
  final ExcelImportUseCase excelImportUseCase;

  ExcelImportCubit(this.excelImportUseCase) : super(ExcelImportInitial());

  /// النوع المختار حالياً + الملف المختار حالياً،
  /// متاحين للشاشة تقرأ منهم في أي وقت.
  ExcelImportType? selectedType;
  ExcelImportFile? selectedFile;

  void selectType(ExcelImportType type) {
    selectedType = type;
    selectedFile = null;
    emit(ExcelImportInitial());
  }

  /// بيفتح الـ picker ويقرأ الـ bytes.
  /// withData: true مهمة علشان الـ bytes تكون موجودة على الويب كمان.
  Future<void> pickFile({required ExcelImportType type}) async {
    selectedType = type;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['xlsx', 'xls'],
        withData: true,
        allowMultiple: false,
      );

      if (isClosed) return;

      if (result == null || result.files.isEmpty) return;

      final picked = result.files.first;
      final bytes = picked.bytes;

      if (bytes == null || bytes.isEmpty) {
        emit(
          ExcelImportError(
            type: type,
            failure: ServerError(errorMsg: 'لم نتمكن من قراءة محتوى الملف'),
          ),
        );
        return;
      }

      final file = ExcelImportFile(
        fileName: picked.name,
        bytes: bytes,
      );

      if (!file.isExcel) {
        emit(
          ExcelImportError(
            type: type,
            failure: ServerError(errorMsg: 'من فضلك اختر ملف إكسيل (xlsx أو xls)'),
          ),
        );
        return;
      }

      selectedFile = file;
      emit(ExcelImportFileSelected(type: type, file: file));
    } catch (e) {
      if (isClosed) return;
      emit(
        ExcelImportError(
          type: type,
          failure: ServerError(errorMsg: e.toString()),
        ),
      );
    }
  }

  /// بيرفع الملف المختار على الـ endpoint بتاع النوع المطلوب.
  Future<void> upload({
    ExcelImportType? type,
    ExcelImportFile? file,
  }) async {
    final effectiveType = type ?? selectedType;
    final effectiveFile = file ?? selectedFile;

    if (effectiveType == null) return;

    if (effectiveFile == null || effectiveFile.isEmpty) {
      emit(
        ExcelImportError(
          type: effectiveType,
          failure: ServerError(errorMsg: 'من فضلك اختر ملف إكسيل أولاً'),
        ),
      );
      return;
    }

    selectedType = effectiveType;
    selectedFile = effectiveFile;

    emit(ExcelImportLoading(type: effectiveType));

    final result = await excelImportUseCase(
      type: effectiveType,
      file: effectiveFile,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        ExcelImportError(type: effectiveType, failure: failure),
      ),
      (response) {
        if (!response.success) {
          emit(
            ExcelImportError(
              type: effectiveType,
              failure: ServerError(errorMsg: response.message),
            ),
          );
          return;
        }

        emit(
          ExcelImportSuccess(type: effectiveType, response: response),
        );
      },
    );
  }

  /// اختيار الملف ورفعه في خطوة واحدة.
  Future<void> pickAndUpload({required ExcelImportType type}) async {
    await pickFile(type: type);

    if (isClosed) return;
    if (state is! ExcelImportFileSelected) return;

    await upload(type: type, file: selectedFile);
  }

  void reset() {
    selectedFile = null;
    emit(ExcelImportInitial());
  }
}
