import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../model/survey_question_entity.dart';
import 'get_survey_questions_state.dart';
import 'get_survey_questions_usecase.dart';

@injectable
class GetSurveyQuestionsCubit extends Cubit<GetSurveyQuestionsState> {
  final GetSurveyQuestionsUseCase getSurveyQuestionsUseCase;

  GetSurveyQuestionsCubit(this.getSurveyQuestionsUseCase)
      : super(GetSurveyQuestionsInitial());

  List<SurveyQuestionEntity> questions = [];

  Future<void> load() async {
    emit(GetSurveyQuestionsLoading());

    final result = await getSurveyQuestionsUseCase();

    result.fold(
      (failure) {
        emit(GetSurveyQuestionsError(failure));
      },
      (response) {
        questions = response.questions;
        emit(GetSurveyQuestionsSuccess(response));
      },
    );
  }

  Future<void> refresh() async {
    await load();
  }
}
