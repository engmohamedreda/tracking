import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'delete_tickets_state.dart';
import 'delete_tickets_usecase.dart';

@injectable
class DeleteTicketsCubit extends Cubit<DeleteTicketsState> {
  final DeleteTicketsUseCase deleteTicketsUseCase;

  DeleteTicketsCubit(this.deleteTicketsUseCase) : super(DeleteTicketsInitial());

  Future<void> deleteTicket({
    required int ticketId,
  }) async {
    emit(DeleteTicketsLoading());

    final result = await deleteTicketsUseCase(ticketId: ticketId);

    result.fold(
      (failure) {
        emit(DeleteTicketsError(failure.errorMsg));
      },
      (response) {
        emit(DeleteTicketsSuccess(response));
      },
    );
  }
}
