import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_all_transactions_response.dart';

abstract class IGetAllTransactionsRepo {
  /// كل الفلاتر اختيارية، و page/pageSize بيتبعتوا دايماً.
  /// هنا الـ API بيستخدم `pageSize` بشكل صحيح (مش `Pageize`
  /// زي endpoints بتاعة ExcelSheetProcess).
  Future<Either<Failures, GetAllTransactionsResponse>> getAllTransactions({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page,
    int pageSize,
  });
}
