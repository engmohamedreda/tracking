import 'dart:typed_data';

import 'excel_template_type.dart';

/// الـ response بيرجع ملف xlsx بايناري، فالموديل ماسك الـ bytes
/// واسم الملف المستخرج من هيدر content-disposition.
class ExcelTemplateResponse {
  final ExcelTemplateType type;
  final String fileName;
  final Uint8List bytes;
  final String contentType;

  const ExcelTemplateResponse({
    required this.type,
    required this.fileName,
    required this.bytes,
    this.contentType =
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  });

  bool get isEmpty => bytes.isEmpty;

  int get sizeInBytes => bytes.length;

  /// بيستخرج الاسم من:
  /// attachment; filename=CompaniesTemplate.xlsx; filename*=UTF-8''CompaniesTemplate.xlsx
  /// وبيفضّل filename* لأنها بتشيل الترميز، ولو مفيش بياخد الـ fallback.
  static String parseFileName({
    required String? contentDisposition,
    required String fallback,
  }) {
    final header = contentDisposition?.trim() ?? '';
    if (header.isEmpty) return fallback;

    final extended = RegExp(
      "filename\\*\\s*=\\s*(?:UTF-8''|utf-8'')?\"?([^\";]+)\"?",
      caseSensitive: false,
    ).firstMatch(header);

    final plain = RegExp(
      'filename\\s*=\\s*"?([^";]+)"?',
      caseSensitive: false,
    ).firstMatch(header);

    final raw = extended?.group(1) ?? plain?.group(1);
    if (raw == null) return fallback;

    var name = raw.trim();
    if (name.isEmpty) return fallback;

    try {
      name = Uri.decodeComponent(name);
    } catch (_) {
      // لو الاسم مش encoded سيبه زي ما هو.
    }

    // بنشيل أي مسار لو جه مع الاسم.
    name = name.split('/').last.split(r'\').last.trim();

    return name.isEmpty ? fallback : name;
  }
}
