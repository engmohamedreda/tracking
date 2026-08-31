import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/export_surveys_response.dart';

abstract class IExportSurveysRepo {
  /// كل الفلاتر اختيارية، وبترجع ملف Excel بايناري.
  /// الـ defaults في الـ Swagger: page=1 و pageSize=100.
  Future<Either<Failures, ExportSurveysResponse>> exportSurveys({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page,
    int pageSize,
  });
}
