import '../model/delete_tickets_response.dart';

abstract class DeleteTicketsState {}

class DeleteTicketsInitial extends DeleteTicketsState {}

class DeleteTicketsLoading extends DeleteTicketsState {}

class DeleteTicketsSuccess extends DeleteTicketsState {
  final DeleteTicketsResponse response;

  DeleteTicketsSuccess(this.response);
}

class DeleteTicketsError extends DeleteTicketsState {
  final String message;

  DeleteTicketsError(this.message);
}
