import '../../../core/helper/failures.dart';
import '../model/get_area_code_response.dart';

abstract class GetAreaCodeState {}

class GetAreaCodeInitial extends GetAreaCodeState {}

class GetAreaCodeLoading extends GetAreaCodeState {}

class GetAreaCodeSuccess extends GetAreaCodeState {
  final GetAreaCodeResponse response;

  GetAreaCodeSuccess(this.response);
}

class GetAreaCodeError extends GetAreaCodeState {
  final Failures failure;

  GetAreaCodeError(this.failure);
}
