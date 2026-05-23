import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_survey_questions_response.dart';

abstract class IGetSurveyQuestionsRepo {
  Future<Either<Failures, GetSurveyQuestionsResponse>> getSurveyQuestions();
}
