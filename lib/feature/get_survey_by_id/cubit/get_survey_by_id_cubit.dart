import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'get_survey_by_id_state.dart';
import 'get_survey_by_id_usecase.dart';

@injectable
class GetSurveyByIdCubit extends Cubit<GetSurveyByIdState> {
  final GetSurveyByIdUseCase getSurveyByIdUseCase;

  GetSurveyByIdCubit(this.getSurveyByIdUseCase)
      : super(GetSurveyByIdInitial());

  Future<void> load({required int id}) async {
    emit(GetSurveyByIdLoading());

    final result = await getSurveyByIdUseCase(id: id);

    result.fold(
      (failure) => emit(GetSurveyByIdError(failure)),
      (response) => emit(GetSurveyByIdSuccess(response)),
    );
  }
}
