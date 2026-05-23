import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/mobile_serial_entity.dart';
import 'get_mobile_serials_state.dart';
import 'get_mobile_serials_usecase.dart';

@injectable
class GetMobileSerialsCubit extends Cubit<GetMobileSerialsState> {
  final GetMobileSerialsUseCase getMobileSerialsUseCase;

  GetMobileSerialsCubit(this.getMobileSerialsUseCase)
      : super(GetMobileSerialsInitial());

  int? selectedAreaCodeId;
  MobileSerialEntity? mobileSerial;

  Future<void> load({
    required int areaCodeId,
  }) async {
    selectedAreaCodeId = areaCodeId;
    emit(GetMobileSerialsLoading());

    final result = await getMobileSerialsUseCase(
      areaCodeId: areaCodeId,
    );

    result.fold(
      (failure) {
        emit(GetMobileSerialsError(failure));
      },
      (response) {
        mobileSerial = response.mobileSerial;
        emit(GetMobileSerialsSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    final areaCodeId = selectedAreaCodeId;
    if (areaCodeId == null) return;

    await load(areaCodeId: areaCodeId);
  }
}
