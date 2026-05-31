import '../../../core/helper/failures.dart';
import '../model/get_survey_by_id_response.dart';

abstract class GetSurveyByIdState {}

class GetSurveyByIdInitial extends GetSurveyByIdState {}

class GetSurveyByIdLoading extends GetSurveyByIdState {}

class GetSurveyByIdSuccess extends GetSurveyByIdState {
  final GetSurveyByIdResponse response;

  GetSurveyByIdSuccess(this.response);
}

class GetSurveyByIdError extends GetSurveyByIdState {
  final Failures failure;

  GetSurveyByIdError(this.failure);
}
