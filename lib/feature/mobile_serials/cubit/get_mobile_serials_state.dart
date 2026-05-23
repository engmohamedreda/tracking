import '../../../core/helper/failures.dart';
import '../model/get_mobile_serials_response.dart';

abstract class GetMobileSerialsState {}

class GetMobileSerialsInitial extends GetMobileSerialsState {}

class GetMobileSerialsLoading extends GetMobileSerialsState {}

class GetMobileSerialsSuccess extends GetMobileSerialsState {
  final GetMobileSerialsResponse response;

  GetMobileSerialsSuccess(this.response);
}

class GetMobileSerialsError extends GetMobileSerialsState {
  final Failures failure;

  GetMobileSerialsError(this.failure);
}
