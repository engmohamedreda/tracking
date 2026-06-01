import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/di/di.dart';
import '../../../area_code/cubit/get_area_code_cubit.dart';
import '../../../area_code/cubit/get_area_code_state.dart';
import '../../../area_code/model/area_code_entity.dart';
import '../../../create_survey/presentation/view/create_survey_screen.dart';
import '../../../mobile_serials/cubit/get_mobile_serials_cubit.dart';
import '../../../mobile_serials/cubit/get_mobile_serials_state.dart';
import '../../../mobile_serials/model/mobile_serial_entity.dart';
import '../../../ntickets/model/ticket_entity.dart';
import '../../../survey_questions/cubit/get_survey_questions_cubit.dart';
import '../../../survey_questions/cubit/get_survey_questions_state.dart';
import '../../../survey_questions/model/survey_question_entity.dart';

class TicketSurveySetupScreen extends StatelessWidget {
  final TicketEntity ticket;

  const TicketSurveySetupScreen({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<GetAreaCodeCubit>()..load()),
        BlocProvider(create: (_) => getIt<GetMobileSerialsCubit>()),
        BlocProvider(create: (_) => getIt<GetSurveyQuestionsCubit>()..load()),
      ],
      child: _TicketSurveySetupView(ticket: ticket),
    );
  }
}

class _TicketSurveySetupView extends StatefulWidget {
  final TicketEntity ticket;

  const _TicketSurveySetupView({required this.ticket});

  @override
  State<_TicketSurveySetupView> createState() => _TicketSurveySetupViewState();
}

class _TicketSurveySetupViewState extends State<_TicketSurveySetupView> {
  final TextEditingController noteController = TextEditingController();

  String? selectedOperation;
  AreaCodeEntity? selectedAreaCode;
  MobileSerialEntity? selectedMobileSerial;

  static const List<String> operations = ['إرسال', 'استلام'];

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canOpen = _canOpenSurvey(context);

    return BlocListener<GetMobileSerialsCubit, GetMobileSerialsState>(
      listener: (context, state) {
        if (state is GetMobileSerialsSuccess && state.response.hasData) {
          setState(() {
            selectedMobileSerial = state.response.mobileSerial;
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FB),
        appBar: AppBar(
          title: const Text('تجهيز الاستبيان'),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context, false),
              icon: const Icon(Icons.arrow_back),
              label: const Text('رجوع'),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _PageHeader(ticket: widget.ticket),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 920;

                        final formCard = _FormCard(
                          operations: operations,
                          selectedOperation: selectedOperation,
                          onOperationChanged: (value) {
                            setState(() => selectedOperation = value);
                          },
                          selectedAreaCode: selectedAreaCode,
                          onAreaCodeChanged: (value) {
                            setState(() {
                              selectedAreaCode = value;
                              selectedMobileSerial = null;
                            });
                            if (value != null) {
                              context
                                  .read<GetMobileSerialsCubit>()
                                  .load(areaCodeId: value.id);
                            }
                          },
                          selectedMobileSerial: selectedMobileSerial,
                          onMobileChanged: (value) {
                            setState(() => selectedMobileSerial = value);
                          },
                          noteController: noteController,
                        );

                        final statusCard = _StatusCard(
                          selectedOperation: selectedOperation,
                          selectedAreaCode: selectedAreaCode,
                          selectedMobileSerial: selectedMobileSerial,
                        );

                        if (!isWide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              formCard,
                              const SizedBox(height: 16),
                              statusCard,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 7, child: formCard),
                            const SizedBox(width: 18),
                            Expanded(flex: 4, child: statusCard),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    _OpenSurveyBar(
                      enabled: canOpen,
                      onPressed: _openSurvey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _canOpenSurvey(BuildContext context) {
    final questionsState = context.watch<GetSurveyQuestionsCubit>().state;
    final hasQuestions = questionsState is GetSurveyQuestionsSuccess &&
        questionsState.response.questions.isNotEmpty;

    return selectedOperation != null &&
        selectedAreaCode != null &&
        selectedMobileSerial != null &&
        hasQuestions;
  }

  Future<void> _openSurvey() async {
    final questionsState = context.read<GetSurveyQuestionsCubit>().state;

    if (questionsState is! GetSurveyQuestionsSuccess ||
        questionsState.response.questions.isEmpty) {
      _showMessage('أسئلة الاستبيان غير جاهزة');
      return;
    }

    if (selectedOperation == null ||
        selectedAreaCode == null ||
        selectedMobileSerial == null) {
      _showMessage('اكمل نوع العملية وكود المنطقة وسيريال الموبايل');
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateSurveyScreen(
          companyId: widget.ticket.companyId,
          brandId: widget.ticket.branchId,
          mobileId: selectedMobileSerial!.id,
          representativeId: widget.ticket.representativeId,
          areaId: selectedAreaCode!.id,
          ticketId: widget.ticket.id,
          status: selectedOperation!,
          initialNote: noteController.text.trim(),
          questions: _toSurveyInputs(questionsState.response.questions),
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      Navigator.pop(context, true);
    }
  }

  List<CreateSurveyQuestionInput> _toSurveyInputs(
    List<SurveyQuestionEntity> questions,
  ) {
    return questions.map((question) {
      return CreateSurveyQuestionInput(
        id: question.id,
        title: question.title,
      );
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final TicketEntity ticket;

  const _PageHeader({required this.ticket});

  String _statusLabel(String value) {
    final lower = value.toLowerCase();
    if (lower == 'waiting') return 'انتظار';
    if (lower == 'iscalled') return 'تم النداء';
    return value.isEmpty ? '-' : value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0F766E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 18,
        spacing: 18,
        children: [
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استبيان العميل التالي',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'تذكرة رقم ${ticket.ticketsNumber}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  ticket.representativeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _HeaderInfo(label: 'الشركة', value: ticket.companyName),
          _HeaderInfo(label: 'الفرع', value: ticket.branchName),
          _HeaderInfo(label: 'رقم التذكرة', value: ticket.id.toString()),
          _HeaderInfo(label: 'الحالة', value: _statusLabel(ticket.status)),
        ],
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<String> operations;
  final String? selectedOperation;
  final ValueChanged<String?> onOperationChanged;
  final AreaCodeEntity? selectedAreaCode;
  final ValueChanged<AreaCodeEntity?> onAreaCodeChanged;
  final MobileSerialEntity? selectedMobileSerial;
  final ValueChanged<MobileSerialEntity?> onMobileChanged;
  final TextEditingController noteController;

  const _FormCard({
    required this.operations,
    required this.selectedOperation,
    required this.onOperationChanged,
    required this.selectedAreaCode,
    required this.onAreaCodeChanged,
    required this.selectedMobileSerial,
    required this.onMobileChanged,
    required this.noteController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.tune_outlined,
              title: 'تجهيز الاستبيان',
              subtitle: 'اختار نوع العملية وكود المنطقة وسيريال الموبايل.',
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 640;

                final operationField = DropdownButtonFormField<String>(
                  value: selectedOperation,
                  decoration: const InputDecoration(
                    labelText: 'نوع العملية',
                    prefixIcon: Icon(Icons.swap_horiz),
                  ),
                  items: operations.map((operation) {
                    return DropdownMenuItem<String>(
                      value: operation,
                      child: Text(operation),
                    );
                  }).toList(),
                  onChanged: onOperationChanged,
                );

                final areaField = _AreaCodeDropdown(
                  selectedAreaCode: selectedAreaCode,
                  onChanged: onAreaCodeChanged,
                );

                if (!isWide) {
                  return Column(
                    children: [
                      operationField,
                      const SizedBox(height: 16),
                      areaField,
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: operationField),
                    const SizedBox(width: 16),
                    Expanded(child: areaField),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _MobileSerialDropdown(
              selectedMobileSerial: selectedMobileSerial,
              onChanged: onMobileChanged,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              minLines: 4,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'ملاحظات',
                hintText: 'اكتب الملاحظات هنا',
                prefixIcon: Icon(Icons.note_alt_outlined),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AreaCodeDropdown extends StatelessWidget {
  final AreaCodeEntity? selectedAreaCode;
  final ValueChanged<AreaCodeEntity?> onChanged;

  const _AreaCodeDropdown({
    required this.selectedAreaCode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetAreaCodeCubit, GetAreaCodeState>(
      builder: (context, state) {
        if (state is GetAreaCodeLoading) {
          return const _LoadingBox(message: 'جاري تحميل أكواد المناطق...');
        }

        if (state is GetAreaCodeError) {
          return _ErrorBox(
            message: state.failure.errorMsg,
            onRetry: () => context.read<GetAreaCodeCubit>().load(),
          );
        }

        final areaCodes = state is GetAreaCodeSuccess
            ? state.response.areaCodes
            : <AreaCodeEntity>[];

        AreaCodeEntity? value;
        for (final item in areaCodes) {
          if (item.id == selectedAreaCode?.id) {
            value = item;
            break;
          }
        }

        return DropdownButtonFormField<AreaCodeEntity>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'كود المنطقة',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          items: areaCodes.map((areaCode) {
            return DropdownMenuItem<AreaCodeEntity>(
              value: areaCode,
              child: Text(areaCode.code),
            );
          }).toList(),
          onChanged: areaCodes.isEmpty ? null : onChanged,
        );
      },
    );
  }
}

class _MobileSerialDropdown extends StatelessWidget {
  final MobileSerialEntity? selectedMobileSerial;
  final ValueChanged<MobileSerialEntity?> onChanged;

  const _MobileSerialDropdown({
    required this.selectedMobileSerial,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetMobileSerialsCubit, GetMobileSerialsState>(
      builder: (context, state) {
        if (state is GetMobileSerialsLoading) {
          return const _LoadingBox(message: 'جاري تحميل سيريال الموبايل...');
        }

        if (state is GetMobileSerialsError) {
          return _ErrorBox(
            message: state.failure.errorMsg,
            onRetry: () => context.read<GetMobileSerialsCubit>().refresh(),
          );
        }

        if (state is GetMobileSerialsSuccess) {
          if (!state.response.hasData) {
            return const _InfoBox(
              message: 'لا يوجد سيريال موبايل لهذا الكود',
              icon: Icons.phone_android_outlined,
            );
          }

          final item = state.response.mobileSerial;
          final items = <MobileSerialEntity>[item];
          final value = selectedMobileSerial?.id == item.id ? item : null;

          return DropdownButtonFormField<MobileSerialEntity>(
            value: value,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'سيريال الموبايل',
              prefixIcon: Icon(Icons.phone_android_outlined),
            ),
            items: items.map((mobile) {
              return DropdownMenuItem<MobileSerialEntity>(
                value: mobile,
                child: Text(mobile.serial),
              );
            }).toList(),
            onChanged: onChanged,
          );
        }

        return DropdownButtonFormField<MobileSerialEntity>(
          value: null,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'سيريال الموبايل',
            prefixIcon: Icon(Icons.phone_android_outlined),
            helperText: 'اختار كود المنطقة أولًا',
          ),
          items: const [],
          onChanged: null,
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String? selectedOperation;
  final AreaCodeEntity? selectedAreaCode;
  final MobileSerialEntity? selectedMobileSerial;

  const _StatusCard({
    required this.selectedOperation,
    required this.selectedAreaCode,
    required this.selectedMobileSerial,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              icon: Icons.fact_check_outlined,
              title: 'جاهزية البيانات',
              subtitle: 'يجب تجهيز كل البيانات قبل فتح الاستبيان.',
            ),
            const SizedBox(height: 20),
            _CheckLine(
              label: selectedOperation == null
                  ? 'تم اختيار نوع العملية'
                  : selectedOperation!,
              done: selectedOperation != null,
            ),
            _CheckLine(
              label: selectedAreaCode == null
                  ? 'تم اختيار كود المنطقة'
                  : 'الكود: ${selectedAreaCode!.code}',
              done: selectedAreaCode != null,
            ),
            _CheckLine(
              label: selectedMobileSerial == null
                  ? 'تم تحميل سيريال الموبايل'
                  : 'السيريال: ${selectedMobileSerial!.serial}',
              done: selectedMobileSerial != null,
            ),
            BlocBuilder<GetSurveyQuestionsCubit, GetSurveyQuestionsState>(
              builder: (context, state) {
                if (state is GetSurveyQuestionsLoading) {
                  return const _CheckLine(
                    label: 'جاري تحميل أسئلة الاستبيان...',
                    done: false,
                  );
                }

                if (state is GetSurveyQuestionsError) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _CheckLine(label: 'خطأ في تحميل أسئلة الاستبيان', done: false),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () =>
                            context.read<GetSurveyQuestionsCubit>().load(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة تحميل الأسئلة'),
                      ),
                    ],
                  );
                }

                final count = state is GetSurveyQuestionsSuccess
                    ? state.response.questions.length
                    : 0;

                return _CheckLine(
                  label: count > 0
                      ? '$count سؤال جاهز للاستبيان'
                      : 'أسئلة الاستبيان',
                  done: count > 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  final String label;
  final bool done;

  const _CheckLine({required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    final color = done ? const Color(0xFF0F766E) : const Color(0xFF94A3B8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              done ? Icons.check : Icons.circle_outlined,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: done ? const Color(0xFF0F172A) : const Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenSurveyBar extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _OpenSurveyBar({
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 12,
        spacing: 12,
        children: [
          SizedBox(
            width: 520,
            child: Text(
              enabled
                  ? 'كل البيانات جاهزة، يمكنك فتح الاستبيان الآن.'
                  : 'اكمل الاختيارات وانتظر تحميل الأسئلة قبل فتح الاستبيان.',
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 260,
            child: ElevatedButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('فتح الاستبيان'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  final String message;

  const _LoadingBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBox({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String message;
  final IconData icon;

  const _InfoBox({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF64748B)),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
