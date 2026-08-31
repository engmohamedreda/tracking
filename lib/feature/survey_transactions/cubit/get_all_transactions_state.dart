import '../../../core/helper/failures.dart';
import '../model/get_all_transactions_response.dart';

abstract class GetAllTransactionsState {}

class GetAllTransactionsInitial extends GetAllTransactionsState {}

class GetAllTransactionsLoading extends GetAllTransactionsState {}

class GetAllTransactionsSuccess extends GetAllTransactionsState {
  final GetAllTransactionsResponse response;

  GetAllTransactionsSuccess(this.response);
}

class GetAllTransactionsError extends GetAllTransactionsState {
  final Failures failure;

  GetAllTransactionsError(this.failure);
}
