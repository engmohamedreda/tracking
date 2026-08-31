import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_excel_mobile_serials_response.dart';
import '../response/interface/i_get_excel_mobile_serials_repo.dart';

@injectable
class GetExcelMobileSerialsUseCase {
  final IGetExcelMobileSerialsRepo getExcelMobileSerialsRepo;

  GetExcelMobileSerialsUseCase(this.getExcelMobileSerialsRepo);

  Future<Either<Failures, GetExcelMobileSerialsResponse>> call({
    int? areaCodeId,
    int page = 1,
    int pageSize = 10,
  }) {
    return getExcelMobileSerialsRepo.getExcelMobileSerials(
      areaCodeId: areaCodeId,
      page: page,
      pageSize: pageSize,
    );
  }
}
