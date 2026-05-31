import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_survey_by_id_response.dart';
import '../response/interface/i_get_survey_by_id_repo.dart';

@injectable
class GetSurveyByIdUseCase {
  final IGetSurveyByIdRepo getSurveyByIdRepo;

  GetSurveyByIdUseCase(this.getSurveyByIdRepo);

  Future<Either<Failures, GetSurveyByIdResponse>> call({
    required int id,
  }) {
    return getSurveyByIdRepo.getSurveyById(id: id);
  }
}
