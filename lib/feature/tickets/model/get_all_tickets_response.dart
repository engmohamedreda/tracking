import 'ticket_entity.dart';

class GetAllTicketsResponse {
  final List<TicketEntity> tickets;

  const GetAllTicketsResponse({
    required this.tickets,
  });

  factory GetAllTicketsResponse.fromJson(dynamic json) {
    if (json is List) {
      return GetAllTicketsResponse(
        tickets: json
            .map((item) => TicketEntity.fromJson(item))
            .where((ticket) => ticket.id != 0)
            .toList(),
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['tickets'] ??
        map['items'] ??
        map['result'] ??
        map['results'];

    if (data is List) {
      return GetAllTicketsResponse(
        tickets: data
            .map((item) => TicketEntity.fromJson(item))
            .where((ticket) => ticket.id != 0)
            .toList(),
      );
    }

    return const GetAllTicketsResponse(tickets: []);
  }

  int get count => tickets.length;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
