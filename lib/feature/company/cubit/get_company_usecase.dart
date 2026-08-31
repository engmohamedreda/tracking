import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_company_response.dart';
import '../response/interface/i_get_company_repo.dart';

@injectable
class GetCompanyUseCase {
  final IGetCompanyRepo getCompanyRepo;

  GetCompanyUseCase(this.getCompanyRepo);

  Future<Either<Failures, GetCompanyResponse>> call() {
    return getCompanyRepo.getCompany();
  }
}
