import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/export_surveys_response.dart';
import '../response/interface/i_export_surveys_repo.dart';

@injectable
class ExportSurveysUseCase {
  final IExportSurveysRepo exportSurveysRepo;

  ExportSurveysUseCase(this.exportSurveysRepo);

  Future<Either<Failures, ExportSurveysResponse>> call({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int pageSize = 100,
  }) {
    return exportSurveysRepo.exportSurveys(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: pageSize,
    );
  }
}
