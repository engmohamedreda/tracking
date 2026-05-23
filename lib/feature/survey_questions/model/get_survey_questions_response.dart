import 'survey_question_entity.dart';

class GetSurveyQuestionsResponse {
  final List<SurveyQuestionEntity> questions;

  const GetSurveyQuestionsResponse({
    required this.questions,
  });

  factory GetSurveyQuestionsResponse.fromJson(dynamic json) {
    if (json is List) {
      final questions = json
          .map((item) => SurveyQuestionEntity.fromJson(item))
          .where((question) => question.hasData)
          .toList();

      questions.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      return GetSurveyQuestionsResponse(
        questions: questions,
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['questions'] ??
        map['surveyQuestions'] ??
        map['items'] ??
        map['result'] ??
        map['results'];

    if (data is List) {
      return GetSurveyQuestionsResponse.fromJson(data);
    }

    return const GetSurveyQuestionsResponse(questions: []);
  }

  int get count => questions.length;

  bool get hasData => questions.isNotEmpty;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
