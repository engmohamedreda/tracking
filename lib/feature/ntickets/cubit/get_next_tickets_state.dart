import '../../../core/helper/failures.dart';
import '../model/get_next_tickets_response.dart';

abstract class GetNextTicketsState {}

class GetNextTicketsInitial extends GetNextTicketsState {}

class GetNextTicketsLoading extends GetNextTicketsState {}

class GetNextTicketsSuccess extends GetNextTicketsState {
  final GetNextTicketsResponse response;

  GetNextTicketsSuccess(this.response);
}

class GetNextTicketsError extends GetNextTicketsState {
  final Failures failure;

  GetNextTicketsError(this.failure);
}
