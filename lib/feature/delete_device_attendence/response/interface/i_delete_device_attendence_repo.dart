import 'package:dartz/dartz.dart';
import '../../../../core/helper/failures.dart';
import '../../model/delete_device_attendence_response.dart';

abstract class IDeleteDeviceAttendenceRepo {
  Future<Either<Failures, DeleteDeviceAttendenceResponse>> deleteDeviceAttendence();
}