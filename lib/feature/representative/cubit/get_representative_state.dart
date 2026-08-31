import '../../../core/helper/failures.dart';
import '../model/get_representative_response.dart';

abstract class GetRepresentativeState {}

class GetRepresentativeInitial extends GetRepresentativeState {}

class GetRepresentativeLoading extends GetRepresentativeState {}

class GetRepresentativeSuccess extends GetRepresentativeState {
  final GetRepresentativeResponse response;

  GetRepresentativeSuccess(this.response);
}

class GetRepresentativeError extends GetRepresentativeState {
  final Failures failure;

  GetRepresentativeError(this.failure);
}
