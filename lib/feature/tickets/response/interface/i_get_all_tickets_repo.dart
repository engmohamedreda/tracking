import 'package:dartz/dartz.dart';

import '../../../../core/helper/failures.dart';
import '../../model/get_all_tickets_response.dart';

abstract class IGetAllTicketsRepo {
  Future<Either<Failures, GetAllTicketsResponse>> getAllTickets();
}
