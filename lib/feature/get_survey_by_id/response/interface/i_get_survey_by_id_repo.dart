import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_survey_by_id_response.dart';

abstract class IGetSurveyByIdRepo {
  Future<Either<Failures, GetSurveyByIdResponse>> getSurveyById({
    required int id,
  });
}
