import '../../../core/helper/failures.dart';
import '../model/get_survey_questions_response.dart';

abstract class GetSurveyQuestionsState {}

class GetSurveyQuestionsInitial extends GetSurveyQuestionsState {}

class GetSurveyQuestionsLoading extends GetSurveyQuestionsState {}

class GetSurveyQuestionsSuccess extends GetSurveyQuestionsState {
  final GetSurveyQuestionsResponse response;

  GetSurveyQuestionsSuccess(this.response);
}

class GetSurveyQuestionsError extends GetSurveyQuestionsState {
  final Failures failure;

  GetSurveyQuestionsError(this.failure);
}
