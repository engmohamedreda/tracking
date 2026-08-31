class Endpoint {
  static const String newLogin =
      'http://elamircloud.elamirgroup.com:6060/api/Auth/Newlogin';
  static const String getAllTickets =
      'http://elamircloud.elamirgroup.com:6060/api/Tickets/GetAllTickets';
  static const String getNextTickets ='http://elamircloud.elamirgroup.com:6060/api/Tickets/GetNextTickets';
  static const String deleteTickets =
      'http://elamircloud.elamirgroup.com:6060/api/Tickets/DeleteTickets';
  static const String getAreaCode =
      'http://elamircloud.elamirgroup.com:6060/api/AreaCode/GetAreaCode';
  static const String getMobilesSerials =
      'http://elamircloud.elamirgroup.com:6060/api/AreaCode/GetMobilesSerials';
  static const String getSurveyQuestions =
      'http://elamircloud.elamirgroup.com:6060/api/Survay/Questions';
  static const String createSurvey =
      'http://elamircloud.elamirgroup.com:6060/api/Survay/CreateSurvay';
  static const String getSurveyById =
      'http://elamircloud.elamirgroup.com:6060/api/Survay/GetSurvayById';
  static const String exportSurveys =
      'http://elamircloud.elamirgroup.com:6060/api/Survay/export-survays';
  static const String usersTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/users-template';
  static const String companiesTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/companies-template';
  static const String branchesTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/branches-template';
  static const String areaCodesTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/area-codes-template';
  static const String mobilesTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/mobiles-template';
  static const String representativesTemplate =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/representatives-template';
  static const String importUsers =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-users';
  static const String importCompany =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-company';
  static const String importBranch =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-Branch';
  static const String importAreaCode =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-AreaCode';
  static const String importMobileSerials =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-MobileSerials';
  static const String importRepresentative =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/import-Representative';
  static const String getAllTransactions =
      'http://elamircloud.elamirgroup.com:6060/api/Survay/GetAllTransactions';
  static const String getCompany =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/Get_Company';
  static const String getBranch =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/Get_Branch';
  static const String getExcelAreaCodes =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/Get_AreaCodes';
  static const String getExcelMobileSerials =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/Get_MobileSerials';
  static const String getRepresentative =
      'http://elamircloud.elamirgroup.com:6060/api/ExcelSheetProcess/Get_Representative';
  static const String deleteDeviceAttendence =
      'http://elamircloud.elamirgroup.com:6060/api/Fingerprint/DeleteDeviceAttendence';
  static String noShowTicket(int ticketId) =>
      'http://elamircloud.elamirgroup.com:6060/api/Tickets/NoShow/$ticketId';
}
