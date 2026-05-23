import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_area_code_response.dart';

abstract class IGetAreaCodeRepo {
  Future<Either<Failures, GetAreaCodeResponse>> getAreaCode();
}
