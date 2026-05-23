import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/create_survey_request.dart';
import '../../model/create_survey_response.dart';

abstract class ICreateSurveyRepo {
  Future<Either<Failures, CreateSurveyResponse>> createSurvey({
    required CreateSurveyRequest request,
  });
}
