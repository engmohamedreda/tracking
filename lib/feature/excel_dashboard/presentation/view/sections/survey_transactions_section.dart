import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../survey_transactions/cubit/get_all_transactions_cubit.dart';
import '../../../../survey_transactions/cubit/get_all_transactions_state.dart';
import '../../../../export_surveys/cubit/export_surveys_cubit.dart';
import '../../../../export_surveys/cubit/export_surveys_state.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_pagination_bar.dart';
import '../../widget/excel_section_card.dart';

/// عرض معاملات الاستبيانات في لوحة التحكم أسفل قسم المستخدمين.
class SurveyTransactionsSection extends StatefulWidget {
  const SurveyTransactionsSection({super.key});

  @override
  State<SurveyTransactionsSection> createState() =>
      _SurveyTransactionsSectionState();
}

class _SurveyTransactionsSectionState extends State<SurveyTransactionsSection> {
  DateTime? _from;
  DateTime? _to;

  Future<void> _pickDate({required bool isFrom}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _from : _to) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isFrom ? 'اختر تاريخ البداية' : 'اختر تاريخ النهاية',
    );

    if (selected == null || !mounted) return;

    setState(() {
      if (isFrom) {
        _from = selected;
        if (_to != null && _to!.isBefore(selected)) _to = null;
      } else {
        _to = selected;
      }
    });
  }

  void _search() {
    context.read<GetAllTransactionsCubit>().applyFilters(from: _from, to: _to);
  }

  void _clearDates() {
    setState(() {
      _from = null;
      _to = null;
    });
    context.read<GetAllTransactionsCubit>().clearFilters();
  }

  Future<void> _showExportDateRangeDialog() async {
    final exportCubit = context.read<ExportSurveysCubit>();
    DateTime? exportFrom = _from;
    DateTime? exportTo = _to;
    String? validationMessage;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickDate({required bool isFrom}) async {
              final selected = await showDatePicker(
                context: dialogContext,
                initialDate: (isFrom ? exportFrom : exportTo) ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                helpText: isFrom ? 'اختر تاريخ البداية' : 'اختر تاريخ النهاية',
              );

              if (selected == null) return;

              setDialogState(() {
                if (isFrom) {
                  exportFrom = selected;
                  if (exportTo != null && exportTo!.isBefore(selected)) {
                    exportTo = null;
                  }
                } else {
                  exportTo = selected;
                }
                validationMessage = null;
              });
            }

            void export() {
              if (exportFrom == null || exportTo == null) {
                setDialogState(() {
                  validationMessage = 'من فضلك اختر تاريخ من وتاريخ إلى.';
                });
                return;
              }

              if (exportFrom!.isAfter(exportTo!)) {
                setDialogState(() {
                  validationMessage =
                      'تاريخ البداية يجب أن يكون قبل تاريخ النهاية.';
                });
                return;
              }

              Navigator.of(dialogContext).pop();
              exportCubit.exportAndSave(
                from: _startOfDay(exportFrom!),
                to: _endOfDay(exportTo!),
              );
            }

            return AlertDialog(
              title: const Text('تصدير معاملات الاستبيانات'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('اختر الفترة المطلوب تنزيلها في ملف Excel.'),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => pickDate(isFrom: true),
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text('من: ${_formatDate(exportFrom)}'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => pickDate(isFrom: false),
                      icon: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: Text('إلى: ${_formatDate(exportTo)}'),
                    ),
                    if (validationMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        validationMessage!,
                        style: const TextStyle(color: Color(0xFFDC2626)),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء'),
                ),
                FilledButton.icon(
                  onPressed: export,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('تنزيل'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GetAllTransactionsCubit>();
    final state = cubit.state;
    final exportState = context.watch<ExportSurveysCubit>().state;
    final isExporting = exportState is ExportSurveysLoading;

    return BlocListener<ExportSurveysCubit, ExportSurveysState>(
      listener: (context, state) {
        if (state is ExportSurveysSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ExportSurveysError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.failure.errorMsg)));
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: Color(0xFF0F766E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'معاملات الاستبيانات',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      IconButton.filledTonal(
                        tooltip: 'تحديث',
                        onPressed: state is GetAllTransactionsLoading
                            ? null
                            : cubit.refresh,
                        icon: const Icon(Icons.refresh, size: 20),
                      ),
                      FilledButton.icon(
                        onPressed: isExporting
                            ? null
                            : _showExportDateRangeDialog,
                        icon: isExporting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.download_outlined),
                        label: const Text('تنزيل Excel'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(isFrom: true),
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text('من: ${_formatDate(_from)}'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pickDate(isFrom: false),
                    icon: const Icon(Icons.calendar_today_outlined, size: 18),
                    label: Text('إلى: ${_formatDate(_to)}'),
                  ),
                  FilledButton.icon(
                    onPressed: state is GetAllTransactionsLoading
                        ? null
                        : _search,
                    icon: const Icon(Icons.search),
                    label: const Text('بحث'),
                  ),
                  TextButton.icon(
                    onPressed: (_from == null && _to == null)
                        ? null
                        : _clearDates,
                    icon: const Icon(Icons.clear),
                    label: const Text('مسح الفلتر'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _TransactionsData(cubit: cubit, state: state),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'غير محدد';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}

class _TransactionsData extends StatelessWidget {
  final GetAllTransactionsCubit cubit;
  final GetAllTransactionsState state;

  const _TransactionsData({required this.cubit, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is GetAllTransactionsInitial ||
        state is GetAllTransactionsLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetAllTransactionsError) {
      return ExcelSectionError(
        message: (state as GetAllTransactionsError).failure.errorMsg,
        onRetry: cubit.load,
      );
    }

    if (state is GetAllTransactionsSuccess) {
      final response = (state as GetAllTransactionsSuccess).response;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcelDataList(
            emptyMessage: 'لا توجد معاملات استبيانات مسجلة',
            rows: response.transactions
                .map(
                  (transaction) => ExcelDataRow(
                    id: transaction.id,
                    title: transaction.representativeName.isNotEmpty
                        ? transaction.representativeName
                        : 'معاملة #${transaction.id}',
                    chips: [
                      ExcelDataChip(label: 'الحالة', value: transaction.status),
                      ExcelDataChip(
                        label: 'الشركة',
                        value: transaction.companyName,
                      ),
                      ExcelDataChip(
                        label: 'الفرع',
                        value: transaction.brandName,
                      ),
                      ExcelDataChip(
                        label: 'المستخدم',
                        value: transaction.userId,
                      ),
                      ExcelDataChip(
                        label: 'التاريخ',
                        value: transaction.createdAt,
                      ),
                      ExcelDataChip(
                        label: 'الإجابات',
                        value: '${transaction.answersCount}',
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          if (response.totalPages > 1)
            ExcelPaginationBar(
              currentPage: response.currentPage,
              totalPages: response.totalPages,
              totalCount: response.totalCount,
              hasPrevious: response.hasPrevious,
              hasNext: response.hasNext,
              isLoading: false,
              onPrevious: cubit.previousPage,
              onNext: cubit.nextPage,
            ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
