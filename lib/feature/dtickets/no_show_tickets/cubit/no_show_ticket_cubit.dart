import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'no_show_ticket_state.dart';
import 'no_show_ticket_usecase.dart';

@injectable
class NoShowTicketCubit extends Cubit<NoShowTicketState> {
  final NoShowTicketUseCase noShowTicketUseCase;

  NoShowTicketCubit(this.noShowTicketUseCase) : super(NoShowTicketInitial());

  Future<void> markNoShow({
    required int ticketId,
  }) async {
    emit(NoShowTicketLoading());

    final result = await noShowTicketUseCase(ticketId: ticketId);

    result.fold(
      (failure) => emit(NoShowTicketError(failure.errorMsg)),
      (response) => emit(NoShowTicketSuccess(response)),
    );
  }
}
