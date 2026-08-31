import '../../../core/helper/Api/ApiManager/EndPoint.dart';

/// الست endpoints بتاعة تحميل التمبلتس.
/// كلهم GET وبيرجعوا ملف xlsx بايناري مش JSON،
/// والاسم بيجي في هيدر content-disposition.
enum ExcelTemplateType {
  companies,
  branches,
  areaCodes,
  mobiles,
  representatives,
  users;

  String get endpoint {
    switch (this) {
      case ExcelTemplateType.companies:
        return Endpoint.companiesTemplate;
      case ExcelTemplateType.branches:
        return Endpoint.branchesTemplate;
      case ExcelTemplateType.areaCodes:
        return Endpoint.areaCodesTemplate;
      case ExcelTemplateType.mobiles:
        return Endpoint.mobilesTemplate;
      case ExcelTemplateType.representatives:
        return Endpoint.representativesTemplate;
      case ExcelTemplateType.users:
        return Endpoint.usersTemplate;
    }
  }

  /// اسم احتياطي لو السيرفر مبعتش content-disposition.
  /// نفس الأسماء اللي راجعة من الـ API.
  String get fallbackFileName {
    switch (this) {
      case ExcelTemplateType.companies:
        return 'CompaniesTemplate.xlsx';
      case ExcelTemplateType.branches:
        return 'BranchesTemplate.xlsx';
      case ExcelTemplateType.areaCodes:
        return 'AreaCodesTemplate.xlsx';
      case ExcelTemplateType.mobiles:
        return 'MobilesTemplate.xlsx';
      case ExcelTemplateType.representatives:
        return 'RepresentativesTemplate.xlsx';
      case ExcelTemplateType.users:
        return 'UsersTemplate.xlsx';
    }
  }

  String get title {
    switch (this) {
      case ExcelTemplateType.companies:
        return 'تحميل تمبلت الشركات';
      case ExcelTemplateType.branches:
        return 'تحميل  الفروع';
      case ExcelTemplateType.areaCodes:
        return 'تحميل تمبلت أكواد المناطق';
      case ExcelTemplateType.mobiles:
        return 'تحميل تمبلت الموبايلات';
      case ExcelTemplateType.representatives:
        return 'تحميل تمبلت المناديب';
      case ExcelTemplateType.users:
        return 'تحميل تمبلت المستخدمين';
    }
  }

  String get successMessage {
    switch (this) {
      case ExcelTemplateType.companies:
        return 'تم تحميل تمبلت الشركات بنجاح';
      case ExcelTemplateType.branches:
        return 'تم تحميل  الفروع بنجاح';
      case ExcelTemplateType.areaCodes:
        return 'تم تحميل تمبلت أكواد المناطق بنجاح';
      case ExcelTemplateType.mobiles:
        return 'تم تحميل تمبلت الموبايلات بنجاح';
      case ExcelTemplateType.representatives:
        return 'تم تحميل تمبلت المناديب بنجاح';
      case ExcelTemplateType.users:
        return 'تم تحميل تمبلت المستخدمين بنجاح';
    }
  }
}
