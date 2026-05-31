class CreateSurveyResponse {
  final bool success;
  final String message;
  final dynamic data;

  /// The id returned from CreateSurvay.
  /// This id is used directly in GetSurvayById?id={id}.
  final int id;

  const CreateSurveyResponse({
    required this.success,
    required this.message,
    this.data,
    this.id = 0,
  });

  factory CreateSurveyResponse.fromJson(dynamic json) {
    if (json is int || json is num) {
      final createdId = _asInt(json);
      return CreateSurveyResponse(
        success: createdId > 0,
        message: createdId > 0
            ? 'Survey created successfully'
            : 'Survey not created',
        data: json,
        id: createdId,
      );
    }

    if (json is bool) {
      return CreateSurveyResponse(
        success: json,
        message: json ? 'Survey created successfully' : 'Survey not created',
        data: json,
      );
    }

    if (json is String) {
      final createdId = int.tryParse(json.trim()) ?? 0;
      return CreateSurveyResponse(
        success: createdId > 0 ||
            json.toLowerCase().contains('success') ||
            json.toLowerCase().trim() == 'true',
        message: json,
        data: json,
        id: createdId,
      );
    }

    final map = _asMap(json);
    final successValue = map['success'] ?? map['isSuccess'] ?? map['succeeded'];
    final messageValue = map['message'] ?? map['error'] ?? map['title'];
    final createdId = _extractCreatedSurveyId(json);

    return CreateSurveyResponse(
      success: _asBool(successValue) || successValue == null,
      message: _asString(messageValue).isEmpty
          ? 'Survey created successfully'
          : _asString(messageValue),
      data: map['data'] ?? json,
      id: createdId,
    );
  }
}

int _extractCreatedSurveyId(dynamic value) {
  final directId = _asInt(value);
  if (directId > 0) return directId;

  final map = _asMap(value);
  if (map.isEmpty) return 0;

  const idKeys = [
    'id',
    'Id',
    'surveyId',
    'SurveyId',
    'survayId',
    'SurvayId',
    'createdId',
    'CreatedId',
    'resultId',
    'ResultId',
  ];

  for (final key in idKeys) {
    final id = _asInt(map[key]);
    if (id > 0) return id;
  }

  const nestedKeys = [
    'data',
    'Data',
    'result',
    'Result',
    'survey',
    'Survey',
    'survay',
    'Survay',
    'item',
    'Item',
  ];

  for (final key in nestedKeys) {
    final nestedValue = map[key];
    final nestedId = _extractCreatedSurveyId(nestedValue);
    if (nestedId > 0) return nestedId;
  }

  return 0;
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

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
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
