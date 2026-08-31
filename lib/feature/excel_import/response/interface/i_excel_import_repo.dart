import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/excel_import_request.dart';
import '../../model/excel_import_response.dart';

abstract class IExcelImportRepo {
  Future<Either<Failures, ExcelImportResponse>> importExcel({
    required ExcelImportRequest request,
  });
}
