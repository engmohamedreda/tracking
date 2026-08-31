import '../../../core/helper/failures.dart';
import '../model/excel_template_response.dart';
import '../model/excel_template_type.dart';

abstract class ExcelTemplateState {}

class ExcelTemplateInitial extends ExcelTemplateState {}

class ExcelTemplateLoading extends ExcelTemplateState {
  final ExcelTemplateType type;
  final String message;

  ExcelTemplateLoading({
    required this.type,
    this.message = 'جاري تحميل التمبلت...',
  });
}

/// نزل من السيرفر واتحفظ على الجهاز.
/// savedPath بيرجع null على الويب لأن المتصفح هو اللي بينزّل الملف.
class ExcelTemplateSuccess extends ExcelTemplateState {
  final ExcelTemplateType type;
  final ExcelTemplateResponse response;
  final String? savedPath;

  ExcelTemplateSuccess({
    required this.type,
    required this.response,
    this.savedPath,
  });

  String get message => type.successMessage;
}

/// نزل من السيرفر بس المستخدم قفل نافذة الحفظ.
class ExcelTemplateSaveCancelled extends ExcelTemplateState {
  final ExcelTemplateType type;
  final ExcelTemplateResponse response;

  ExcelTemplateSaveCancelled({
    required this.type,
    required this.response,
  });
}

class ExcelTemplateError extends ExcelTemplateState {
  final ExcelTemplateType type;
  final Failures failure;

  ExcelTemplateError({
    required this.type,
    required this.failure,
  });
}
