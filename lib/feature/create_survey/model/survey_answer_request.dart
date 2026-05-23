class SurveyAnswerRequest {
  final int id;
  final String title;
  final bool answer;
  final int questionId;

  const SurveyAnswerRequest({
    this.id = 0,
    required this.title,
    required this.answer,
    required this.questionId,
  });

  factory SurveyAnswerRequest.fromJson(dynamic json) {
    final map = _asMap(json);

    return SurveyAnswerRequest(
      id: _asInt(map['id']),
      title: _asString(map['title']),
      answer: _asBool(map['answer']),
      questionId: _asInt(map['questionId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'answer': answer,
      'questionId': questionId,
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
