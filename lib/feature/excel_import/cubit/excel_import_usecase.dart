import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/excel_import_file.dart';
import '../model/excel_import_request.dart';
import '../model/excel_import_response.dart';
import '../model/excel_import_type.dart';
import '../response/interface/i_excel_import_repo.dart';

@injectable
class ExcelImportUseCase {
  final IExcelImportRepo excelImportRepo;

  ExcelImportUseCase(this.excelImportRepo);

  Future<Either<Failures, ExcelImportResponse>> call({
    required ExcelImportType type,
    required ExcelImportFile file,
  }) {
    return excelImportRepo.importExcel(
      request: ExcelImportRequest(type: type, file: file),
    );
  }
}
