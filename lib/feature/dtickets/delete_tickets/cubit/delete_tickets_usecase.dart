import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/failures.dart';
import '../model/delete_tickets_response.dart';
import '../response/interface/i_delete_tickets_repo.dart';

@injectable
class DeleteTicketsUseCase {
  final IDeleteTicketsRepo deleteTicketsRepo;

  DeleteTicketsUseCase(this.deleteTicketsRepo);

  Future<Either<Failures, DeleteTicketsResponse>> call({
    required int ticketId,
  }) {
    return deleteTicketsRepo.deleteTicket(ticketId: ticketId);
  }
}
