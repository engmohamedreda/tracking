import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_branch_response.dart';
import '../response/interface/i_get_branch_repo.dart';

@injectable
class GetBranchUseCase {
  final IGetBranchRepo getBranchRepo;

  GetBranchUseCase(this.getBranchRepo);

  Future<Either<Failures, GetBranchResponse>> call() {
    return getBranchRepo.getBranch();
  }
}
