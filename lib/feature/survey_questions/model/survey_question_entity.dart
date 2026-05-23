class SurveyQuestionEntity {
  final int id;
  final String title;
  final int sortOrder;

  const SurveyQuestionEntity({
    required this.id,
    required this.title,
    required this.sortOrder,
  });

  factory SurveyQuestionEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return SurveyQuestionEntity(
      id: _asInt(map['id']),
      title: _asString(map['title']),
      sortOrder: _asInt(map['sortOrder']),
    );
  }

  const SurveyQuestionEntity.empty()
      : id = 0,
        title = '',
        sortOrder = 0;

  bool get hasData => id != 0 || title.isNotEmpty || sortOrder != 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sortOrder': sortOrder,
    };
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

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
