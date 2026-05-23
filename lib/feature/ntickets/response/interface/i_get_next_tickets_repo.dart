import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_next_tickets_response.dart';

abstract class IGetNextTicketsRepo {
  Future<Either<Failures, GetNextTicketsResponse>> getNextTickets();
}
