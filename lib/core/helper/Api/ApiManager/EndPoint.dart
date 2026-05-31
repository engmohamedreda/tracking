class Endpoint {
  static const String newLogin = 'http://192.168.9.169:6060/api/Auth/Newlogin';
  static const String getAllTickets = 'http://192.168.9.169:6060/api/Tickets/GetAllTickets';
  static const String getNextTickets = 'http://192.168.9.169:6060/api/Tickets/GetNextTickets';
  static const String deleteTickets = 'http://192.168.9.169:6060/api/Tickets/DeleteTickets';
  static const String getAreaCode = 'http://192.168.9.169:6060/api/AreaCode/GetAreaCode';
  static const String getMobilesSerials = 'http://192.168.9.169:6060/api/AreaCode/GetMobilesSerials';
  static const String getSurveyQuestions = 'http://192.168.9.169:6060/api/Survay/Questions';
  static const String createSurvey = 'http://192.168.9.169:6060/api/Survay/CreateSurvay';
  static const String getSurveyById = 'http://192.168.9.169:6060/api/Survay/GetSurvayById';

  static String noShowTicket(int ticketId) =>
      'http://192.168.9.169:6060/api/Tickets/NoShow/$ticketId';
}
