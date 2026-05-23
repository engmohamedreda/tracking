import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_mobile_serials_response.dart';
import '../response/interface/i_get_mobile_serials_repo.dart';

@injectable
class GetMobileSerialsUseCase {
  final IGetMobileSerialsRepo getMobileSerialsRepo;

  GetMobileSerialsUseCase(this.getMobileSerialsRepo);

  Future<Either<Failures, GetMobileSerialsResponse>> call({
    required int areaCodeId,
  }) {
    return getMobileSerialsRepo.getMobileSerials(
      areaCodeId: areaCodeId,
    );
  }
}
