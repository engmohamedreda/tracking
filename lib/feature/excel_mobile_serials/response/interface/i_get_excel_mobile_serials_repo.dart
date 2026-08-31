import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_excel_mobile_serials_response.dart';

abstract class IGetExcelMobileSerialsRepo {
  /// AreaCodeId اختياري، و page/Pageize بيتبعتوا دايماً.
  /// خد بالك إن اسم الـ query param في الـ API هو `Pageize`.
  Future<Either<Failures, GetExcelMobileSerialsResponse>>
      getExcelMobileSerials({
    int? areaCodeId,
    int page,
    int pageSize,
  });
}
