import '../../../core/helper/failures.dart';
import '../model/get_excel_mobile_serials_response.dart';

abstract class GetExcelMobileSerialsState {}

class GetExcelMobileSerialsInitial extends GetExcelMobileSerialsState {}

class GetExcelMobileSerialsLoading extends GetExcelMobileSerialsState {}

class GetExcelMobileSerialsSuccess extends GetExcelMobileSerialsState {
  final GetExcelMobileSerialsResponse response;

  GetExcelMobileSerialsSuccess(this.response);
}

class GetExcelMobileSerialsError extends GetExcelMobileSerialsState {
  final Failures failure;

  GetExcelMobileSerialsError(this.failure);
}
