class Endpoint {
  static const String newLogin = 'http://elamircloud.elamirgroup.com:6060/api/Auth/Newlogin';
  static const String getAllTickets = 'http://elamircloud.elamirgroup.com:6060/api/Tickets/GetAllTickets';
  static const String getNextTickets = 'http://elamircloud.elamirgroup.com:6060/api/Tickets/GetNextTickets';
  static const String deleteTickets = 'http://elamircloud.elamirgroup.com:6060/api/Tickets/DeleteTickets';
  static const String getAreaCode = 'http://elamircloud.elamirgroup.com:6060/api/AreaCode/GetAreaCode';
  static const String getMobilesSerials = 'http://elamircloud.elamirgroup.com:6060/api/AreaCode/GetMobilesSerials';
  static const String getSurveyQuestions = 'http://elamircloud.elamirgroup.com:6060/api/Survay/Questions';
  static const String createSurvey = 'http://elamircloud.elamirgroup.com:6060/api/Survay/CreateSurvay';
  static const String getSurveyById = 'http://elamircloud.elamirgroup.com:6060/api/Survay/GetSurvayById';
  static const String deleteDeviceAttendence = 'http://elamircloud.elamirgroup.com:6060/api/Fingerprint/DeleteDeviceAttendence';
  static String noShowTicket(int ticketId) => 'http://elamircloud.elamirgroup.com:6060/api/Tickets/NoShow/$ticketId';
}
