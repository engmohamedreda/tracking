import 'package:dio/dio.dart';

import 'excel_import_file.dart';
import 'excel_import_type.dart';

class ExcelImportRequest {
  final ExcelImportType type;
  final ExcelImportFile file;

  const ExcelImportRequest({
    required this.type,
    required this.file,
  });

  String get endpoint => type.endpoint;

  /// ملاحظة مهمة: مانستخدمش MultipartFile.fromFile هنا
  /// لأنها محتاجة dart:io وبتكسر على Flutter Web.
  FormData toFormData() {
    final formData = FormData();

    formData.files.add(
      MapEntry(
        type.fileFieldName,
        MultipartFile.fromBytes(
          file.bytes,
          filename: file.fileName,
        ),
      ),
    );

    return formData;
  }

  List<String> findMissingFields() {
    final missing = <String>[];

    if (file.fileName.trim().isEmpty) missing.add('excelfile.fileName');
    if (file.bytes.isEmpty) missing.add('excelfile.bytes');

    return missing;
  }

  Map<String, dynamic> toDebugJson() {
    return {
      'type': type.name,
      'endpoint': endpoint,
      'fieldName': type.fileFieldName,
      'fileName': file.fileName,
      'sizeInBytes': file.sizeInBytes,
      'extension': file.extension,
    };
  }
}
