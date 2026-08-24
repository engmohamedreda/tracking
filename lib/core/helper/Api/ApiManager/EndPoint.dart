class Endpoint {
  static const String newLogin =
      'http://192.168.2.20:6060/api/Auth/Newlogin';
  static const String getAllTickets =
      'http://192.168.2.20:6060/api/Tickets/GetAllTickets';
  static const String getNextTickets =
      'http://192.168.2.20:6060/api/Tickets/GetNextTickets';
  static const String deleteTickets =
      'http://192.168.2.20:6060/api/Tickets/DeleteTickets';
  static const String getAreaCode =
      'http://192.168.2.20:6060/api/AreaCode/GetAreaCode';
  static const String getMobilesSerials =
      'http://192.168.2.20:6060/api/AreaCode/GetMobilesSerials';
  static const String getSurveyQuestions =
      'http://192.168.2.20:6060/api/Survay/Questions';
  static const String createSurvey =
      'http://192.168.2.20:6060/api/Survay/CreateSurvay';
  static const String getSurveyById =
      'http://192.168.2.20:6060/api/Survay/GetSurvayById';
  static const String exportSurveys =
      'http://192.168.2.20:6060/api/Survay/export-survays';
  static const String usersTemplate =
      'http://192.168.2.20:6060/api/ExcelSheetProcess/users-template';
  static const String deleteDeviceAttendence =
      'http://192.168.2.20:6060/api/Fingerprint/DeleteDeviceAttendence';
  static String noShowTicket(int ticketId) =>
      'http://192.168.2.20:6060/api/Tickets/NoShow/$ticketId';
}
