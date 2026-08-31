import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../../../representative/cubit/get_representative_cubit.dart';
import '../../../../representative/cubit/get_representative_state.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_pagination_bar.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم المناديب: نموذج + رفع شيت + المناديب المعروضين بصفحات.
class ExcelRepresentativesSection extends StatelessWidget {
  const ExcelRepresentativesSection({super.key});

  static const ExcelImportType _importType = ExcelImportType.representative;
  static const ExcelTemplateType _templateType =
      ExcelTemplateType.representatives;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    final cubit = context.watch<GetRepresentativeCubit>();
    final state = cubit.state;

    return ExcelSectionCard(
      title: 'المناديب',
      subtitle: '',
      icon: Icons.badge_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: state is GetRepresentativeLoading,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      onRefresh: () => context.read<GetRepresentativeCubit>().refresh(),
      child: _buildData(context, cubit, state),
    );
  }

  Widget _buildData(
    BuildContext context,
    GetRepresentativeCubit cubit,
    GetRepresentativeState state,
  ) {
    if (state is GetRepresentativeLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetRepresentativeError) {
      return ExcelSectionError(
        message: state.failure.errorMsg,
        onRetry: () => context.read<GetRepresentativeCubit>().load(),
      );
    }

    if (state is GetRepresentativeSuccess) {
      final response = state.response;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcelDataList(
            emptyMessage: 'لا توجد مناديب مسجلة',
            rows: response.representatives
                .map(
                  (representative) => ExcelDataRow(
                    id: representative.id,
                    title: representative.name,
                    chips: [
                      ExcelDataChip(
                        label: 'البصمة',
                        value: representative.fingerPrint,
                      ),
                      ExcelDataChip(
                        label: 'الموبايل',
                        value: representative.phone,
                      ),
                      ExcelDataChip(
                        label: 'الشركة',
                        value: representative.companyName,
                      ),
                      ExcelDataChip(
                        label: 'الفرع',
                        value: representative.branchName,
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

    return const ExcelSectionLoader();
  }
}
