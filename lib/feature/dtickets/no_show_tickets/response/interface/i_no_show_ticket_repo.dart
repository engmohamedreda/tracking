import 'package:dartz/dartz.dart';

import '../../../../../core/helper/failures.dart';
import '../../model/no_show_ticket_response.dart';

abstract class INoShowTicketRepo {
  Future<Either<Failures, NoShowTicketResponse>> markNoShow({
    required int ticketId,
  });
}
