import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/create_survey_request.dart';
import '../model/create_survey_response.dart';
import '../response/interface/i_create_survey_repo.dart';

@injectable
class CreateSurveyUseCase {
  final ICreateSurveyRepo createSurveyRepo;

  CreateSurveyUseCase(this.createSurveyRepo);

  Future<Either<Failures, CreateSurveyResponse>> call({
    required CreateSurveyRequest request,
  }) {
    return createSurveyRepo.createSurvey(request: request);
  }
}
