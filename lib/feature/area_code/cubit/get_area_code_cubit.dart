import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/area_code_entity.dart';
import 'get_area_code_state.dart';
import 'get_area_code_usecase.dart';

@injectable
class GetAreaCodeCubit extends Cubit<GetAreaCodeState> {
  final GetAreaCodeUseCase getAreaCodeUseCase;

  GetAreaCodeCubit(this.getAreaCodeUseCase) : super(GetAreaCodeInitial());

  List<AreaCodeEntity> areaCodes = [];

  Future<void> load() async {
    emit(GetAreaCodeLoading());

    final result = await getAreaCodeUseCase();

    result.fold(
      (failure) {
        emit(GetAreaCodeError(failure));
      },
      (response) {
        areaCodes = response.areaCodes;
        emit(GetAreaCodeSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load();
  }
}
