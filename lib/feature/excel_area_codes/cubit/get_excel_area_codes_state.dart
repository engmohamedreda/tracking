import '../../../core/helper/failures.dart';
import '../model/get_excel_area_codes_response.dart';

abstract class GetExcelAreaCodesState {}

class GetExcelAreaCodesInitial extends GetExcelAreaCodesState {}

class GetExcelAreaCodesLoading extends GetExcelAreaCodesState {}

class GetExcelAreaCodesSuccess extends GetExcelAreaCodesState {
  final GetExcelAreaCodesResponse response;

  GetExcelAreaCodesSuccess(this.response);
}

class GetExcelAreaCodesError extends GetExcelAreaCodesState {
  final Failures failure;

  GetExcelAreaCodesError(this.failure);
}
