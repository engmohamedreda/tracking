import 'dart:typed_data';

/// ملف الإكسيل المختار من file_picker.
/// بنستخدم bytes مش path علشان يشتغل على الويب والموبايل.
class ExcelImportFile {
  final String fileName;
  final Uint8List bytes;

  const ExcelImportFile({
    required this.fileName,
    required this.bytes,
  });

  bool get isEmpty => bytes.isEmpty || fileName.trim().isEmpty;

  int get sizeInBytes => bytes.length;

  String get extension {
    final name = fileName.trim();
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex == -1 || dotIndex == name.length - 1) return '';
    return name.substring(dotIndex + 1).toLowerCase();
  }

  bool get isExcel => extension == 'xlsx' || extension == 'xls';
}
