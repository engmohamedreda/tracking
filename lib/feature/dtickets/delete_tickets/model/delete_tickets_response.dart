class DeleteTicketsResponse {
  final bool isDeleted;
  final String message;

  DeleteTicketsResponse({
    required this.isDeleted,
    required this.message,
  });

  factory DeleteTicketsResponse.fromJson(dynamic json) {
    if (json is bool) {
      return DeleteTicketsResponse(
        isDeleted: json,
        message: json ? 'تم حذف التذكرة بنجاح' : 'لم يتم حذف التذكرة',
      );
    }

    final map = _asMap(json);
    final boolValue = map['success'] ?? map['isDeleted'] ?? map['deleted'] ?? map['data'];
    final isDeleted = _asBool(boolValue);

    return DeleteTicketsResponse(
      isDeleted: isDeleted,
      message: _asString(
        map['message'],
        defaultValue: isDeleted ? 'تم حذف التذكرة بنجاح' : 'لم يتم حذف التذكرة',
      ),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

String _asString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  final text = value.toString();
  if (text.isEmpty) return defaultValue;
  return text;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is num) return value.toInt() == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return false;
}
