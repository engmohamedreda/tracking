import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../branch/cubit/get_branch_cubit.dart';
import '../../../../branch/cubit/get_branch_state.dart';
import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم الفروع: نموذج الفروع + رفع شيت الفروع + الفروع المعروضة فعلياً.
class ExcelBranchSection extends StatelessWidget {
  const ExcelBranchSection({super.key});

  static const ExcelImportType _importType = ExcelImportType.branch;
  static const ExcelTemplateType _templateType = ExcelTemplateType.branches;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    final state = context.watch<GetBranchCubit>().state;

    return ExcelSectionCard(
      title: 'الفروع',
      subtitle: '',
      icon: Icons.store_mall_directory_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: state is GetBranchLoading,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      onRefresh: () => context.read<GetBranchCubit>().refresh(),
      child: _buildData(context, state),
    );
  }

  Widget _buildData(BuildContext context, GetBranchState state) {
    if (state is GetBranchLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetBranchError) {
      return ExcelSectionError(
        message: state.failure.errorMsg,
        onRetry: () => context.read<GetBranchCubit>().load(),
      );
    }

    if (state is GetBranchSuccess) {
      return ExcelDataList(
        emptyMessage: 'لا توجد فروع مسجلة',
        rows: state.response.branches
            .map(
              (branch) => ExcelDataRow(
                id: branch.id,
                title: branch.name,
              ),
            )
            .toList(),
      );
    }

    return const ExcelSectionLoader();
  }
}
