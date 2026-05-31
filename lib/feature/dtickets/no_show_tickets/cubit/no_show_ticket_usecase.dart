import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/failures.dart';
import '../model/no_show_ticket_response.dart';
import '../response/interface/i_no_show_ticket_repo.dart';

@injectable
class NoShowTicketUseCase {
  final INoShowTicketRepo noShowTicketRepo;

  NoShowTicketUseCase(this.noShowTicketRepo);

  Future<Either<Failures, NoShowTicketResponse>> call({
    required int ticketId,
  }) {
    return noShowTicketRepo.markNoShow(ticketId: ticketId);
  }
}
