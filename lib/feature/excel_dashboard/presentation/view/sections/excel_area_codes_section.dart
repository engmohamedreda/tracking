import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../excel_area_codes/cubit/get_excel_area_codes_cubit.dart';
import '../../../../excel_area_codes/cubit/get_excel_area_codes_state.dart';
import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_pagination_bar.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم أكواد المناطق: نموذج + رفع شيت + الأكواد المعروضة بصفحات.
class ExcelAreaCodesSection extends StatelessWidget {
  const ExcelAreaCodesSection({super.key});

  static const ExcelImportType _importType = ExcelImportType.areaCode;
  static const ExcelTemplateType _templateType = ExcelTemplateType.areaCodes;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    final cubit = context.watch<GetExcelAreaCodesCubit>();
    final state = cubit.state;

    return ExcelSectionCard(
      title: 'أكواد المناطق',
      subtitle: '',
      icon: Icons.qr_code_2_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: state is GetExcelAreaCodesLoading,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      onRefresh: () => context.read<GetExcelAreaCodesCubit>().refresh(),
      child: _buildData(context, cubit, state),
    );
  }

  Widget _buildData(
    BuildContext context,
    GetExcelAreaCodesCubit cubit,
    GetExcelAreaCodesState state,
  ) {
    if (state is GetExcelAreaCodesLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetExcelAreaCodesError) {
      return ExcelSectionError(
        message: state.failure.errorMsg,
        onRetry: () => context.read<GetExcelAreaCodesCubit>().load(),
      );
    }

    if (state is GetExcelAreaCodesSuccess) {
      final response = state.response;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcelDataList(
            emptyMessage: 'لا توجد أكواد مناطق مسجلة',
            rows: response.areaCodes
                .map(
                  (areaCode) => ExcelDataRow(
                    id: areaCode.id,
                    title: areaCode.code,
                    chips: [
                      ExcelDataChip(
                        label: 'الشركة',
                        value: areaCode.companyName,
                      ),
                      ExcelDataChip(
                        label: 'الفرع',
                        value: areaCode.branchName,
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
