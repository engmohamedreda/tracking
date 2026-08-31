import '../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../excel_template/model/excel_template_type.dart';

/// الست endpoints بتاعة الاستيراد في ExcelSheetProcess.
/// كلهم POST + multipart/form-data + حقل واحد اسمه excelfile.
enum ExcelImportType {
  company,
  branch,
  areaCode,
  mobileSerials,
  representative,
  users;

  String get endpoint {
    switch (this) {
      case ExcelImportType.company:
        return Endpoint.importCompany;
      case ExcelImportType.branch:
        return Endpoint.importBranch;
      case ExcelImportType.areaCode:
        return Endpoint.importAreaCode;
      case ExcelImportType.mobileSerials:
        return Endpoint.importMobileSerials;
      case ExcelImportType.representative:
        return Endpoint.importRepresentative;
      case ExcelImportType.users:
        return Endpoint.importUsers;
    }
  }

  /// التمبلت المقابل لكل نوع، علشان الشاشة تنزّل التمبلت
  /// وترفعه بعد ما تملاه من نفس المكان.
  ExcelTemplateType get templateType {
    switch (this) {
      case ExcelImportType.company:
        return ExcelTemplateType.companies;
      case ExcelImportType.branch:
        return ExcelTemplateType.branches;
      case ExcelImportType.areaCode:
        return ExcelTemplateType.areaCodes;
      case ExcelImportType.mobileSerials:
        return ExcelTemplateType.mobiles;
      case ExcelImportType.representative:
        return ExcelTemplateType.representatives;
      case ExcelImportType.users:
        return ExcelTemplateType.users;
    }
  }

  /// اسم الحقل في الـ form-data زي ما هو في الـ Swagger بالحرف الصغير.
  String get fileFieldName => 'excelfile';

  String get title {
    switch (this) {
      case ExcelImportType.company:
        return 'استيراد الشركات';
      case ExcelImportType.branch:
        return 'استيراد الفروع';
      case ExcelImportType.areaCode:
        return 'استيراد أكواد المناطق';
      case ExcelImportType.mobileSerials:
        return 'استيراد سيريالات الموبايل';
      case ExcelImportType.representative:
        return 'استيراد المناديب';
      case ExcelImportType.users:
        return 'استيراد المستخدمين';
    }
  }

  String get successMessage {
    switch (this) {
      case ExcelImportType.company:
        return 'تم استيراد ملف الشركات بنجاح';
      case ExcelImportType.branch:
        return 'تم استيراد ملف الفروع بنجاح';
      case ExcelImportType.areaCode:
        return 'تم استيراد ملف أكواد المناطق بنجاح';
      case ExcelImportType.mobileSerials:
        return 'تم استيراد ملف سيريالات الموبايل بنجاح';
      case ExcelImportType.representative:
        return 'تم استيراد ملف المناديب بنجاح';
      case ExcelImportType.users:
        return 'تم استيراد ملف المستخدمين بنجاح';
    }
  }
}
