import '../../../core/helper/failures.dart';
import '../model/export_surveys_response.dart';

abstract class ExportSurveysState {}

class ExportSurveysInitial extends ExportSurveysState {}

class ExportSurveysLoading extends ExportSurveysState {
  final String message;

  ExportSurveysLoading({this.message = 'جاري تصدير الملف...'});
}

/// نزل من السيرفر واتحفظ على الجهاز.
/// savedPath بيرجع null على الويب لأن المتصفح هو اللي بينزّل الملف.
class ExportSurveysSuccess extends ExportSurveysState {
  final ExportSurveysResponse response;
  final String? savedPath;

  ExportSurveysSuccess({
    required this.response,
    this.savedPath,
  });

  String get message => 'تم تصدير ملف المعاملات بنجاح';
}

/// نزل من السيرفر بس المستخدم قفل نافذة الحفظ.
class ExportSurveysSaveCancelled extends ExportSurveysState {
  final ExportSurveysResponse response;

  ExportSurveysSaveCancelled({required this.response});
}

class ExportSurveysError extends ExportSurveysState {
  final Failures failure;

  ExportSurveysError(this.failure);
}
