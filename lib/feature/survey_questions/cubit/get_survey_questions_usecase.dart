import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_survey_questions_response.dart';
import '../response/interface/i_get_survey_questions_repo.dart';

@injectable
class GetSurveyQuestionsUseCase {
  final IGetSurveyQuestionsRepo getSurveyQuestionsRepo;

  GetSurveyQuestionsUseCase(this.getSurveyQuestionsRepo);

  Future<Either<Failures, GetSurveyQuestionsResponse>> call() {
    return getSurveyQuestionsRepo.getSurveyQuestions();
  }
}
