import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/survey_transaction_entity.dart';
import 'get_all_transactions_state.dart';
import 'get_all_transactions_usecase.dart';

@injectable
class GetAllTransactionsCubit extends Cubit<GetAllTransactionsState> {
  final GetAllTransactionsUseCase getAllTransactionsUseCase;

  GetAllTransactionsCubit(this.getAllTransactionsUseCase)
      : super(GetAllTransactionsInitial());

  static const int defaultPageSize = 10;

  List<SurveyTransactionEntity> transactions = [];

  DateTime? selectedFrom;
  DateTime? selectedTo;
  int? selectedBranchId;
  int? selectedCompanyId;
  String? selectedStatus;

  int currentPage = 1;
  int pageSize = defaultPageSize;
  int totalCount = 0;
  int totalPages = 1;
  bool hasPrevious = false;
  bool hasNext = false;

  Future<void> load({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int? pageSize,
  }) async {
    selectedFrom = from;
    selectedTo = to;
    selectedBranchId = branchId;
    selectedCompanyId = companyId;
    selectedStatus = status;
    this.pageSize = pageSize ?? this.pageSize;

    emit(GetAllTransactionsLoading());

    final result = await getAllTransactionsUseCase(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: page,
      pageSize: this.pageSize,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetAllTransactionsError(failure));
      },
      (response) {
        transactions = response.transactions;
        currentPage = response.currentPage;
        this.pageSize = response.pageSize;
        totalCount = response.totalCount;
        totalPages = response.totalPages;
        hasPrevious = response.hasPrevious;
        hasNext = response.hasNext;
        emit(GetAllTransactionsSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await _loadWithCurrentFilters(page: currentPage);
  }

  Future<void> nextPage() async {
    if (!hasNext) return;
    await _loadWithCurrentFilters(page: currentPage + 1);
  }

  Future<void> previousPage() async {
    if (!hasPrevious) return;
    await _loadWithCurrentFilters(page: currentPage - 1);
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages) return;
    await _loadWithCurrentFilters(page: page);
  }

  /// بيغيّر الفلاتر ويرجع لأول صفحة.
  Future<void> applyFilters({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
  }) async {
    await load(
      from: from,
      to: to,
      branchId: branchId,
      companyId: companyId,
      status: status,
      page: 1,
      pageSize: pageSize,
    );
  }

  Future<void> clearFilters() async {
    await load(page: 1, pageSize: pageSize);
  }

  Future<void> _loadWithCurrentFilters({required int page}) async {
    await load(
      from: selectedFrom,
      to: selectedTo,
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      status: selectedStatus,
      page: page,
      pageSize: pageSize,
    );
  }
}
