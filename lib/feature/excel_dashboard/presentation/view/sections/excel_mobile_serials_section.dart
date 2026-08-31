import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_mobile_serials/cubit/get_excel_mobile_serials_cubit.dart';
import '../../../../excel_mobile_serials/cubit/get_excel_mobile_serials_state.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_pagination_bar.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم سيريالات الموبايل: نموذج + رفع شيت + السيريالات المعروضة بصفحات.
class ExcelMobileSerialsSection extends StatelessWidget {
  const ExcelMobileSerialsSection({super.key});

  static const ExcelImportType _importType = ExcelImportType.mobileSerials;
  static const ExcelTemplateType _templateType = ExcelTemplateType.mobiles;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    final cubit = context.watch<GetExcelMobileSerialsCubit>();
    final state = cubit.state;

    return ExcelSectionCard(
      title: 'سيريالات الموبايل',
      subtitle: '    ',
      icon: Icons.smartphone_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: state is GetExcelMobileSerialsLoading,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      onRefresh: () => context.read<GetExcelMobileSerialsCubit>().refresh(),
      child: _buildData(context, cubit, state),
    );
  }

  Widget _buildData(
    BuildContext context,
    GetExcelMobileSerialsCubit cubit,
    GetExcelMobileSerialsState state,
  ) {
    if (state is GetExcelMobileSerialsLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetExcelMobileSerialsError) {
      return ExcelSectionError(
        message: state.failure.errorMsg,
        onRetry: () => context.read<GetExcelMobileSerialsCubit>().load(),
      );
    }

    if (state is GetExcelMobileSerialsSuccess) {
      final response = state.response;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcelDataList(
            emptyMessage: 'لا توجد سيريالات مسجلة',
            rows: response.mobileSerials
                .map(
                  (serial) => ExcelDataRow(
                    id: serial.id,
                    title: serial.serial,
                    chips: [
                      ExcelDataChip(
                        label: 'كود المنطقة',
                        value: serial.areaCode,
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
