import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../company/cubit/get_company_cubit.dart';
import '../../../../company/cubit/get_company_state.dart';
import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../widget/excel_data_list.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم الشركات: نموذج الشركات + رفع شيت الشركات + الشركات المعروضة فعلياً.
class ExcelCompanySection extends StatelessWidget {
  const ExcelCompanySection({super.key});

  static const ExcelImportType _importType = ExcelImportType.company;
  static const ExcelTemplateType _templateType = ExcelTemplateType.companies;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    final state = context.watch<GetCompanyCubit>().state;

    return ExcelSectionCard(
      title: 'الشركات',
      subtitle: '    ',
      icon: Icons.business_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: state is GetCompanyLoading,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      onRefresh: () => context.read<GetCompanyCubit>().refresh(),
      child: _buildData(context, state),
    );
  }

  Widget _buildData(BuildContext context, GetCompanyState state) {
    if (state is GetCompanyLoading) {
      return const ExcelSectionLoader();
    }

    if (state is GetCompanyError) {
      return ExcelSectionError(
        message: state.failure.errorMsg,
        onRetry: () => context.read<GetCompanyCubit>().load(),
      );
    }

    if (state is GetCompanySuccess) {
      return ExcelDataList(
        emptyMessage: 'لا توجد شركات مسجلة',
        rows: state.response.companies
            .map(
              (company) => ExcelDataRow(
                id: company.id,
                title: company.name,
              ),
            )
            .toList(),
      );
    }

    return const ExcelSectionLoader();
  }
}
