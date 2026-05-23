import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../cubit/get_survey_questions_cubit.dart';
import '../../cubit/get_survey_questions_state.dart';
import '../../model/survey_question_entity.dart';

class GetSurveyQuestionsScreen extends StatelessWidget {
  const GetSurveyQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetSurveyQuestionsCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Survey Questions'),
        ),
        body: BlocBuilder<GetSurveyQuestionsCubit, GetSurveyQuestionsState>(
          builder: (context, state) {
            if (state is GetSurveyQuestionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetSurveyQuestionsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.failure.errorMsg,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<GetSurveyQuestionsCubit>().load(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is GetSurveyQuestionsSuccess) {
              final questions = state.response.questions;

              if (questions.isEmpty) {
                return const Center(
                  child: Text('No survey questions found'),
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    context.read<GetSurveyQuestionsCubit>().refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: questions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _SurveyQuestionCard(question: questions[index]);
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _SurveyQuestionCard extends StatefulWidget {
  final SurveyQuestionEntity question;

  const _SurveyQuestionCard({
    required this.question,
  });

  @override
  State<_SurveyQuestionCard> createState() => _SurveyQuestionCardState();
}

class _SurveyQuestionCardState extends State<_SurveyQuestionCard> {
  bool? answer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Text(widget.question.sortOrder.toString()),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.question.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        answer = true;
                      });
                    },
                    child: Text(answer == true ? 'Yes ✓' : 'Yes'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        answer = false;
                      });
                    },
                    child: Text(answer == false ? 'No ✓' : 'No'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
