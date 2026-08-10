import '../model/delete_device_attendence_response.dart';

abstract class DeleteDeviceAttendenceState {}
class DeleteDeviceAttendenceInitial extends DeleteDeviceAttendenceState {}
class DeleteDeviceAttendenceLoading extends DeleteDeviceAttendenceState {}
class DeleteDeviceAttendenceSuccess extends DeleteDeviceAttendenceState {
  final DeleteDeviceAttendenceResponse response;
  DeleteDeviceAttendenceSuccess(this.response);
}
class DeleteDeviceAttendenceError extends DeleteDeviceAttendenceState {
  final String message;
  DeleteDeviceAttendenceError(this.message);
}