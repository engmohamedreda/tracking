import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_excel_area_codes_response.dart';

abstract class IGetExcelAreaCodesRepo {
  /// BranchId و CompanyId اختياريين، و page/Pageize بيتبعتوا دايماً.
  /// خد بالك إن اسم الـ query param في الـ API هو `Pageize` بالغلطة المطبعية دي.
  Future<Either<Failures, GetExcelAreaCodesResponse>> getExcelAreaCodes({
    int? branchId,
    int? companyId,
    int page,
    int pageSize,
  });
}
