import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/representative_entity.dart';
import 'get_representative_state.dart';
import 'get_representative_usecase.dart';

@injectable
class GetRepresentativeCubit extends Cubit<GetRepresentativeState> {
  final GetRepresentativeUseCase getRepresentativeUseCase;

  GetRepresentativeCubit(this.getRepresentativeUseCase)
      : super(GetRepresentativeInitial());

  static const int defaultPageSize = 10;

  List<RepresentativeEntity> representatives = [];

  int? selectedBranchId;
  int? selectedCompanyId;
  int currentPage = 1;
  int pageSize = defaultPageSize;
  int totalCount = 0;
  int totalPages = 1;
  bool hasPrevious = false;
  bool hasNext = false;

  Future<void> load({
    int? branchId,
    int? companyId,
    int page = 1,
    int? pageSize,
  }) async {
    selectedBranchId = branchId;
    selectedCompanyId = companyId;
    this.pageSize = pageSize ?? this.pageSize;

    emit(GetRepresentativeLoading());

    final result = await getRepresentativeUseCase(
      branchId: branchId,
      companyId: companyId,
      page: page,
      pageSize: this.pageSize,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetRepresentativeError(failure));
      },
      (response) {
        representatives = response.representatives;
        currentPage = response.currentPage;
        this.pageSize = response.pageSize;
        totalCount = response.totalCount;
        totalPages = response.totalPages;
        hasPrevious = response.hasPrevious;
        hasNext = response.hasNext;
        emit(GetRepresentativeSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load(
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      page: currentPage,
      pageSize: pageSize,
    );
  }

  Future<void> nextPage() async {
    if (!hasNext) return;

    await load(
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      page: currentPage + 1,
      pageSize: pageSize,
    );
  }

  Future<void> previousPage() async {
    if (!hasPrevious) return;

    await load(
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      page: currentPage - 1,
      pageSize: pageSize,
    );
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages) return;

    await load(
      branchId: selectedBranchId,
      companyId: selectedCompanyId,
      page: page,
      pageSize: pageSize,
    );
  }

  /// بيغيّر الفلاتر ويرجع لأول صفحة.
  Future<void> applyFilters({
    int? branchId,
    int? companyId,
  }) async {
    await load(
      branchId: branchId,
      companyId: companyId,
      page: 1,
      pageSize: pageSize,
    );
  }

  Future<void> clearFilters() async {
    await load(page: 1, pageSize: pageSize);
  }
}
