import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_excel_area_codes_response.dart';
import '../response/interface/i_get_excel_area_codes_repo.dart';

@injectable
class GetExcelAreaCodesUseCase {
  final IGetExcelAreaCodesRepo getExcelAreaCodesRepo;

  GetExcelAreaCodesUseCase(this.getExcelAreaCodesRepo);

  Future<Either<Failures, GetExcelAreaCodesResponse>> call({
    int? branchId,
    int? companyId,
    int page = 1,
    int pageSize = 10,
  }) {
    return getExcelAreaCodesRepo.getExcelAreaCodes(
      branchId: branchId,
      companyId: companyId,
      page: page,
      pageSize: pageSize,
    );
  }
}
