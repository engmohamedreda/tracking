import '../../../core/helper/failures.dart';
import '../model/excel_import_file.dart';
import '../model/excel_import_response.dart';
import '../model/excel_import_type.dart';

abstract class ExcelImportState {}

class ExcelImportInitial extends ExcelImportState {}

/// بعد اختيار الملف وقبل الإرسال.
class ExcelImportFileSelected extends ExcelImportState {
  final ExcelImportType type;
  final ExcelImportFile file;

  ExcelImportFileSelected({
    required this.type,
    required this.file,
  });
}

class ExcelImportLoading extends ExcelImportState {
  final ExcelImportType type;
  final String message;

  ExcelImportLoading({
    required this.type,
    this.message = 'جاري رفع الملف...',
  });
}

class ExcelImportSuccess extends ExcelImportState {
  final ExcelImportType type;
  final ExcelImportResponse response;

  ExcelImportSuccess({
    required this.type,
    required this.response,
  });
}

class ExcelImportError extends ExcelImportState {
  final ExcelImportType type;
  final Failures failure;

  ExcelImportError({
    required this.type,
    required this.failure,
  });
}
