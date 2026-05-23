import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/get_next_tickets_response.dart';
import '../response/interface/i_get_next_tickets_repo.dart';

@injectable
class GetNextTicketsUseCase {
  final IGetNextTicketsRepo getNextTicketsRepo;

  GetNextTicketsUseCase(this.getNextTicketsRepo);

  Future<Either<Failures, GetNextTicketsResponse>> call() {
    return getNextTicketsRepo.getNextTickets();
  }
}
