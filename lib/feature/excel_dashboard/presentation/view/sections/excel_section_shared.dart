import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../excel_import/cubit/excel_import_cubit.dart';
import '../../../../excel_import/cubit/excel_import_state.dart';
import '../../../../excel_import/model/excel_import_type.dart';
import '../../../../excel_template/cubit/excel_template_cubit.dart';
import '../../../../excel_template/cubit/excel_template_state.dart';
import '../../../../excel_template/model/excel_template_type.dart';

/// حسابات الـ loading المشتركة بين كل الأقسام.
/// الكيوبت واحد للكل، فبنفلتر بالـ type علشان كل قسم
/// يظهر اللودر بتاعه هو بس.
class ExcelSectionFlags {
  final bool isTemplateLoading;
  final bool isImportLoading;

  const ExcelSectionFlags({
    required this.isTemplateLoading,
    required this.isImportLoading,
  });

  static ExcelSectionFlags of(
    BuildContext context, {
    required ExcelImportType importType,
    required ExcelTemplateType templateType,
  }) {
    final templateState = context.watch<ExcelTemplateCubit>().state;
    final importState = context.watch<ExcelImportCubit>().state;

    return ExcelSectionFlags(
      isTemplateLoading: templateState is ExcelTemplateLoading &&
          templateState.type == templateType,
      isImportLoading:
          importState is ExcelImportLoading && importState.type == importType,
    );
  }
}

/// أكشنز القسم: تحميل النموذج ورفع الشيت.
class ExcelSectionActions {
  const ExcelSectionActions._();

  static void downloadTemplate(
    BuildContext context,
    ExcelTemplateType type,
  ) {
    context.read<ExcelTemplateCubit>().downloadAndSave(type: type);
  }

  static void uploadSheet(
    BuildContext context,
    ExcelImportType type,
  ) {
    context.read<ExcelImportCubit>().pickAndUpload(type: type);
  }
}
