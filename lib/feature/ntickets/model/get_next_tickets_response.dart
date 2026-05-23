import 'ticket_entity.dart';

class GetNextTicketsResponse {
  final TicketEntity ticket;

  const GetNextTicketsResponse({
    required this.ticket,
  });

  factory GetNextTicketsResponse.fromJson(dynamic json) {
    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['ticket'] ??
        map['item'] ??
        map['result'] ??
        map['nextTicket'] ??
        json;

    return GetNextTicketsResponse(
      ticket: TicketEntity.fromJson(data),
    );
  }

  bool get hasTicket => ticket.isValid;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
