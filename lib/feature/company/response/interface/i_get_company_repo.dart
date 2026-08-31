import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_company_response.dart';

abstract class IGetCompanyRepo {
  Future<Either<Failures, GetCompanyResponse>> getCompany();
}
