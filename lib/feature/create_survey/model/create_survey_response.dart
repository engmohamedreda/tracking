class CreateSurveyResponse {
  final bool success;
  final String message;
  final dynamic data;

  const CreateSurveyResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateSurveyResponse.fromJson(dynamic json) {
    if (json is bool) {
      return CreateSurveyResponse(
        success: json,
        message: json ? 'Survey created successfully' : 'Survey not created',
        data: json,
      );
    }

    if (json is String) {
      return CreateSurveyResponse(
        success: json.toLowerCase().contains('success') || json == 'true',
        message: json,
        data: json,
      );
    }

    final map = _asMap(json);

    final successValue = map['success'] ?? map['isSuccess'] ?? map['succeeded'];
    final messageValue = map['message'] ?? map['error'] ?? map['title'];

    return CreateSurveyResponse(
      success: _asBool(successValue) || successValue == null,
      message: _asString(messageValue).isEmpty
          ? 'Survey created successfully'
          : _asString(messageValue),
      data: map['data'] ?? json,
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is num) return value.toInt() == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'success';
  }
  return false;
}
