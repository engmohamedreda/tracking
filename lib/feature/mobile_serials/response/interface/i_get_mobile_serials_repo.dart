import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_mobile_serials_response.dart';

abstract class IGetMobileSerialsRepo {
  Future<Either<Failures, GetMobileSerialsResponse>> getMobileSerials({
    required int areaCodeId,
  });
}
