class NoShowTicketResponse {
  final bool isSuccess;
  final String message;

  NoShowTicketResponse({
    required this.isSuccess,
    required this.message,
  });

  factory NoShowTicketResponse.fromJson(dynamic json) {
    if (json == null) {
      return NoShowTicketResponse(
        isSuccess: true,
        message: 'Ticket marked as no-show successfully',
      );
    }

    if (json is bool) {
      return NoShowTicketResponse(
        isSuccess: json,
        message: json
            ? 'Ticket marked as no-show successfully'
            : 'Ticket was not marked as no-show',
      );
    }

    if (json is String) {
      return NoShowTicketResponse(
        isSuccess: true,
        message: json.isEmpty ? 'Ticket marked as no-show successfully' : json,
      );
    }

    final map = _asMap(json);
    final successValue = map['success'] ??
        map['isSuccess'] ??
        map['noShow'] ??
        map['isNoShow'] ??
        map['data'];

    final isSuccess = successValue == null ? true : _asBool(successValue);

    return NoShowTicketResponse(
      isSuccess: isSuccess,
      message: _asString(
        map['message'],
        defaultValue: isSuccess
            ? 'Ticket marked as no-show successfully'
            : 'Ticket was not marked as no-show',
      ),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

String _asString(dynamic value, {String defaultValue = ''}) {
  if (value == null) return defaultValue;
  final text = value.toString();
  if (text.isEmpty) return defaultValue;
  return text;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is num) return value.toInt() == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return false;
}
