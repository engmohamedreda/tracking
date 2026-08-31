import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/excel_mobile_serial_entity.dart';
import 'get_excel_mobile_serials_state.dart';
import 'get_excel_mobile_serials_usecase.dart';

@injectable
class GetExcelMobileSerialsCubit extends Cubit<GetExcelMobileSerialsState> {
  final GetExcelMobileSerialsUseCase getExcelMobileSerialsUseCase;

  GetExcelMobileSerialsCubit(this.getExcelMobileSerialsUseCase)
      : super(GetExcelMobileSerialsInitial());

  static const int defaultPageSize = 10;

  List<ExcelMobileSerialEntity> mobileSerials = [];

  int? selectedAreaCodeId;
  int currentPage = 1;
  int pageSize = defaultPageSize;
  int totalCount = 0;
  int totalPages = 1;
  bool hasPrevious = false;
  bool hasNext = false;

  Future<void> load({
    int? areaCodeId,
    int page = 1,
    int? pageSize,
  }) async {
    selectedAreaCodeId = areaCodeId;
    this.pageSize = pageSize ?? this.pageSize;

    emit(GetExcelMobileSerialsLoading());

    final result = await getExcelMobileSerialsUseCase(
      areaCodeId: areaCodeId,
      page: page,
      pageSize: this.pageSize,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(GetExcelMobileSerialsError(failure));
      },
      (response) {
        mobileSerials = response.mobileSerials;
        currentPage = response.currentPage;
        this.pageSize = response.pageSize;
        totalCount = response.totalCount;
        totalPages = response.totalPages;
        hasPrevious = response.hasPrevious;
        hasNext = response.hasNext;
        emit(GetExcelMobileSerialsSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load(
      areaCodeId: selectedAreaCodeId,
      page: currentPage,
      pageSize: pageSize,
    );
  }

  Future<void> nextPage() async {
    if (!hasNext) return;

    await load(
      areaCodeId: selectedAreaCodeId,
      page: currentPage + 1,
      pageSize: pageSize,
    );
  }

  Future<void> previousPage() async {
    if (!hasPrevious) return;

    await load(
      areaCodeId: selectedAreaCodeId,
      page: currentPage - 1,
      pageSize: pageSize,
    );
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages) return;

    await load(
      areaCodeId: selectedAreaCodeId,
      page: page,
      pageSize: pageSize,
    );
  }

  /// بيغيّر الفلتر ويرجع لأول صفحة.
  Future<void> applyFilters({int? areaCodeId}) async {
    await load(areaCodeId: areaCodeId, page: 1, pageSize: pageSize);
  }

  Future<void> clearFilters() async {
    await load(page: 1, pageSize: pageSize);
  }
}
