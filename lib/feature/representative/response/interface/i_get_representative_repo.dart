import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_representative_response.dart';

abstract class IGetRepresentativeRepo {
  /// BranchId و CompanyId اختياريين، و page/Pageize بيتبعتوا دايماً.
  /// خد بالك إن اسم الـ query param في الـ API هو `Pageize`.
  Future<Either<Failures, GetRepresentativeResponse>> getRepresentative({
    int? branchId,
    int? companyId,
    int page,
    int pageSize,
  });
}
