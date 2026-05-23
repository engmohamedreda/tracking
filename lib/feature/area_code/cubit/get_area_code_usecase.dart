import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_area_code_response.dart';
import '../response/interface/i_get_area_code_repo.dart';

@injectable
class GetAreaCodeUseCase {
  final IGetAreaCodeRepo getAreaCodeRepo;

  GetAreaCodeUseCase(this.getAreaCodeRepo);

  Future<Either<Failures, GetAreaCodeResponse>> call() {
    return getAreaCodeRepo.getAreaCode();
  }
}
