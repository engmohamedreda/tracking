import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/ticket_entity.dart';
import 'get_next_tickets_state.dart';
import 'get_next_tickets_usecase.dart';

@injectable
class GetNextTicketsCubit extends Cubit<GetNextTicketsState> {
  final GetNextTicketsUseCase getNextTicketsUseCase;

  GetNextTicketsCubit(this.getNextTicketsUseCase)
      : super(GetNextTicketsInitial());

  TicketEntity? currentTicket;

  Future<void> load() async {
    emit(GetNextTicketsLoading());

    final result = await getNextTicketsUseCase();

    result.fold(
      (failure) {
        emit(GetNextTicketsError(failure));
      },
      (response) {
        currentTicket = response.ticket;
        emit(GetNextTicketsSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load();
  }
}
