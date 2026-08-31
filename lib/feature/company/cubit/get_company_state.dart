import '../../../core/helper/failures.dart';
import '../model/get_company_response.dart';

abstract class GetCompanyState {}

class GetCompanyInitial extends GetCompanyState {}

class GetCompanyLoading extends GetCompanyState {}

class GetCompanySuccess extends GetCompanyState {
  final GetCompanyResponse response;

  GetCompanySuccess(this.response);
}

class GetCompanyError extends GetCompanyState {
  final Failures failure;

  GetCompanyError(this.failure);
}
