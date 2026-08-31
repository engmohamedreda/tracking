import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_branch_response.dart';

abstract class IGetBranchRepo {
  Future<Either<Failures, GetBranchResponse>> getBranch();
}
