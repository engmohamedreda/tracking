import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_all_transactions_response.dart';
import '../response/interface/i_get_all_transactions_repo.dart';

@injectable
class GetAllTransactionsUseCase {
  final IGetAllTransactionsRepo getAllTransactionsRepo;

  GetAllTransactionsUseCase(this.getAllTransactionsRepo);

  Future<Either<Failures, GetAllTransactionsResponse>> call({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int pageSize = 10,
  }) {
    return getAllTransactionsRepo.getAllTransactions(
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
