import 'package:dartz/dartz.dart';

import '../../../../../core/helper/failures.dart';
import '../../model/delete_tickets_response.dart';

abstract class IDeleteTicketsRepo {
  Future<Either<Failures, DeleteTicketsResponse>> deleteTicket({
    required int ticketId,
  });
}
