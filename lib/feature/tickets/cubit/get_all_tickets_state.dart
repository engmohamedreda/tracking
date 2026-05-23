import '../../../core/helper/failures.dart';
import '../model/get_all_tickets_response.dart';

abstract class GetAllTicketsState {}

class GetAllTicketsInitial extends GetAllTicketsState {}

class GetAllTicketsLoading extends GetAllTicketsState {}

class GetAllTicketsSuccess extends GetAllTicketsState {
  final GetAllTicketsResponse response;

  GetAllTicketsSuccess(this.response);
}

class GetAllTicketsError extends GetAllTicketsState {
  final Failures failure;

  GetAllTicketsError(this.failure);
}
