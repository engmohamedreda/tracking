import '../../../core/helper/failures.dart';
import '../../get_survey_by_id/model/get_survey_by_id_response.dart';
import '../model/create_survey_response.dart';

abstract class CreateSurveyState {}

class CreateSurveyInitial extends CreateSurveyState {}

class CreateSurveyLoading extends CreateSurveyState {
  final String message;

  CreateSurveyLoading({this.message = 'Saving survey...'});
}

class CreateSurveyWaitingFingerprint extends CreateSurveyLoading {
  final int surveyId;
  final GetSurveyByIdResponse survey;
  final int attempt;
  final int nextRefreshSeconds;

  CreateSurveyWaitingFingerprint({
    required this.surveyId,
    required this.survey,
    required this.attempt,
    this.nextRefreshSeconds = 5,
  }) : super(
          message:
              'Fingerprint is not confirmed yet. Refreshing again in $nextRefreshSeconds seconds...',
        );
}

class CreateSurveySuccess extends CreateSurveyState {
  final CreateSurveyResponse response;
  final GetSurveyByIdResponse? fingerprintSurvey;

  CreateSurveySuccess(
    this.response, {
    this.fingerprintSurvey,
  });
}

class CreateSurveyError extends CreateSurveyState {
  final Failures failure;

  CreateSurveyError(this.failure);
}
