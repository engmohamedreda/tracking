import '../model/no_show_ticket_response.dart';

abstract class NoShowTicketState {}

class NoShowTicketInitial extends NoShowTicketState {}

class NoShowTicketLoading extends NoShowTicketState {}

class NoShowTicketSuccess extends NoShowTicketState {
  final NoShowTicketResponse response;

  NoShowTicketSuccess(this.response);
}

class NoShowTicketError extends NoShowTicketState {
  final String message;

  NoShowTicketError(this.message);
}
