import '../../../core/helper/failures.dart';
import '../model/create_survey_response.dart';

abstract class CreateSurveyState {}

class CreateSurveyInitial extends CreateSurveyState {}

class CreateSurveyLoading extends CreateSurveyState {}

class CreateSurveySuccess extends CreateSurveyState {
  final CreateSurveyResponse response;

  CreateSurveySuccess(this.response);
}

class CreateSurveyError extends CreateSurveyState {
  final Failures failure;

  CreateSurveyError(this.failure);
}
