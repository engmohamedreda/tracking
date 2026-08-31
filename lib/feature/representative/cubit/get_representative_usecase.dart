import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_representative_response.dart';
import '../response/interface/i_get_representative_repo.dart';

@injectable
class GetRepresentativeUseCase {
  final IGetRepresentativeRepo getRepresentativeRepo;

  GetRepresentativeUseCase(this.getRepresentativeRepo);

  Future<Either<Failures, GetRepresentativeResponse>> call({
    int? branchId,
    int? companyId,
    int page = 1,
    int pageSize = 10,
  }) {
    return getRepresentativeRepo.getRepresentative(
      branchId: branchId,
      companyId: companyId,
      page: page,
      pageSize: pageSize,
    );
  }
}
