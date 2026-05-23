import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_all_tickets_response.dart';
import '../response/interface/i_get_all_tickets_repo.dart';

@injectable
class GetAllTicketsUseCase {
  final IGetAllTicketsRepo getAllTicketsRepo;

  GetAllTicketsUseCase(this.getAllTicketsRepo);

  Future<Either<Failures, GetAllTicketsResponse>> call() {
    return getAllTicketsRepo.getAllTickets();
  }
}
