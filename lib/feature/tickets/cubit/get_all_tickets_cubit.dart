import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/ticket_entity.dart';
import 'get_all_tickets_state.dart';
import 'get_all_tickets_usecase.dart';

@injectable
class GetAllTicketsCubit extends Cubit<GetAllTicketsState> {
  final GetAllTicketsUseCase getAllTicketsUseCase;

  GetAllTicketsCubit(this.getAllTicketsUseCase)
      : super(GetAllTicketsInitial());

  List<TicketEntity> tickets = [];

  Future<void> load() async {
    emit(GetAllTicketsLoading());

    final result = await getAllTicketsUseCase();

    result.fold(
      (failure) {
        emit(GetAllTicketsError(failure));
      },
      (response) {
        tickets = response.tickets;
        emit(GetAllTicketsSuccess(response));
      },
    );
  }

  Future<void> refresh({bool silent = false}) async {
    if (!silent) {
      await load();
      return;
    }

    final result = await getAllTicketsUseCase();

    result.fold(
      (failure) {
        emit(GetAllTicketsError(failure));
      },
      (response) {
        tickets = response.tickets;
        emit(GetAllTicketsSuccess(response));
      },
    );
  }
}
