/// الـ Swagger مش مبين شكل الـ response غير 200 OK،
/// فالـ parsing متسامح: bool أو نص أو Map أو List.
class ExcelImportResponse {
  final bool success;
  final String message;
  final int insertedCount;
  final List<String> errors;
  final dynamic raw;

  const ExcelImportResponse({
    required this.success,
    required this.message,
    this.insertedCount = 0,
    this.errors = const [],
    this.raw,
  });

  factory ExcelImportResponse.fromJson(
    dynamic json, {
    required String defaultMessage,
  }) {
    if (json == null) {
      return ExcelImportResponse(
        success: true,
        message: defaultMessage,
        raw: json,
      );
    }

    if (json is bool) {
      return ExcelImportResponse(
        success: json,
        message: json ? defaultMessage : 'لم يتم استيراد الملف',
        raw: json,
      );
    }

    if (json is num) {
      return ExcelImportResponse(
        success: json > 0,
        message: json > 0 ? defaultMessage : 'لم يتم استيراد أي صف من الملف',
        insertedCount: json.toInt(),
        raw: json,
      );
    }

    if (json is String) {
      final text = json.trim();
      if (text.isEmpty) {
        return ExcelImportResponse(
          success: true,
          message: defaultMessage,
          raw: json,
        );
      }
      return ExcelImportResponse(
        success: !_looksLikeError(text),
        message: text,
        raw: json,
      );
    }

    if (json is List) {
      return ExcelImportResponse(
        success: true,
        message: defaultMessage,
        insertedCount: json.length,
        raw: json,
      );
    }

    if (json is Map) {
      final map = _asMap(json);

      final successValue = map['success'] ??
          map['isSuccess'] ??
          map['status'] ??
          map['result'];

      final message = (map['message'] ??
              map['Message'] ??
              map['error'] ??
              map['title'] ??
              defaultMessage)
          .toString();

      final countValue = map['insertedCount'] ??
          map['count'] ??
          map['rows'] ??
          map['totalRows'] ??
          map['inserted'];

      return ExcelImportResponse(
        success: _asBool(successValue, fallback: !_looksLikeError(message)),
        message: message.trim().isEmpty ? defaultMessage : message,
        insertedCount: _asInt(countValue),
        errors: _asStringList(map['errors'] ?? map['Errors'] ?? map['failed']),
        raw: json,
      );
    }

    return ExcelImportResponse(
      success: true,
      message: defaultMessage,
      raw: json,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

bool _asBool(dynamic value, {required bool fallback}) {
  if (value == null) return fallback;
  if (value is bool) return value;
  if (value is num) return value > 0;

  final text = value.toString().trim().toLowerCase();
  if (text == 'true' || text == 'success' || text == 'ok' || text == '1') {
    return true;
  }
  if (text == 'false' || text == 'error' || text == 'failed' || text == '0') {
    return false;
  }

  return fallback;
}

int _asInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

List<String> _asStringList(dynamic value) {
  if (value is List) {
    return value
        .map((item) => item.toString())
        .where((item) => item.trim().isNotEmpty)
        .toList();
  }
  if (value is String && value.trim().isNotEmpty) return [value.trim()];
  return const [];
}

bool _looksLikeError(String text) {
  final lower = text.toLowerCase();
  return lower.contains('error') ||
      lower.contains('fail') ||
      lower.contains('invalid') ||
      lower.contains('exception') ||
      text.contains('خطأ') ||
      text.contains('فشل');
}
