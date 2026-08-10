import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'delete_device_attendence_state.dart';
import 'delete_device_attendence_usecase.dart';

@injectable
class DeleteDeviceAttendenceCubit extends Cubit<DeleteDeviceAttendenceState> {
  final DeleteDeviceAttendenceUseCase useCase;

  DeleteDeviceAttendenceCubit(this.useCase)
      : super(DeleteDeviceAttendenceInitial());

  Future<void> deleteDeviceAttendence() async {
    emit(DeleteDeviceAttendenceLoading());
    final result = await useCase();
    result.fold(
      (failure) => emit(DeleteDeviceAttendenceError(failure.errorMsg)),
      (response) => emit(DeleteDeviceAttendenceSuccess(response)),
    );
  }
}