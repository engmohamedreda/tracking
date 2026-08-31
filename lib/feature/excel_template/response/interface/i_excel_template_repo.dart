import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/excel_template_response.dart';
import '../../model/excel_template_type.dart';

abstract class IExcelTemplateRepo {
  Future<Either<Failures, ExcelTemplateResponse>> downloadTemplate({
    required ExcelTemplateType type,
  });
}
