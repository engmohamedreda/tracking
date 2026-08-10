import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../core/helper/failures.dart';
import '../model/delete_device_attendence_response.dart';
import '../response/interface/i_delete_device_attendence_repo.dart';

@injectable
class DeleteDeviceAttendenceUseCase {
  final IDeleteDeviceAttendenceRepo repo;

  DeleteDeviceAttendenceUseCase(this.repo);

  Future<Either<Failures, DeleteDeviceAttendenceResponse>> call() =>
      repo.deleteDeviceAttendence();
}