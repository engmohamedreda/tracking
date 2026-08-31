import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/excel_template_response.dart';
import '../model/excel_template_type.dart';
import '../response/interface/i_excel_template_repo.dart';

@injectable
class ExcelTemplateUseCase {
  final IExcelTemplateRepo excelTemplateRepo;

  ExcelTemplateUseCase(this.excelTemplateRepo);

  Future<Either<Failures, ExcelTemplateResponse>> call({
    required ExcelTemplateType type,
  }) {
    return excelTemplateRepo.downloadTemplate(type: type);
  }
}
