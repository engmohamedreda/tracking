import 'package:flutter/material.dart';

import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/model/excel_template_type.dart';
import '../../widget/excel_section_card.dart';
import 'excel_section_shared.dart';

/// قسم المستخدمين: نموذج + رفع شيت بس.
/// مفيش endpoint في الـ API لعرض المستخدمين (مفيش Get_Users)،
/// فالقسم ده مفيهوش بيانات معروضة تحت زي باقي الأقسام.
class ExcelUsersSection extends StatelessWidget {
  const ExcelUsersSection({super.key});

  static const ExcelImportType _importType = ExcelImportType.users;
  static const ExcelTemplateType _templateType = ExcelTemplateType.users;

  @override
  Widget build(BuildContext context) {
    final flags = ExcelSectionFlags.of(
      context,
      importType: _importType,
      templateType: _templateType,
    );

    return ExcelSectionCard(
      title: 'المستخدمين',
      subtitle: ' ',
      icon: Icons.group_outlined,
      isTemplateLoading: flags.isTemplateLoading,
      isImportLoading: flags.isImportLoading,
      isDataLoading: false,
      onDownloadTemplate: () =>
          ExcelSectionActions.downloadTemplate(context, _templateType),
      onUploadSheet: () =>
          ExcelSectionActions.uploadSheet(context, _importType),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
       
      ),
    );
  }
}
