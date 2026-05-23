class TicketEntity {
  final int id;
  final int ticketsNumber;
  final String status;
  final String checkInTime;
  final String checkCalledTime;
  final String checkCompletedTime;
  final String branchName;
  final String companyName;
  final int representativeId;
  final String representativeName;
  final String representativeFingerPrint;
  final int companyId;
  final int branchId;

  const TicketEntity({
    required this.id,
    required this.ticketsNumber,
    required this.status,
    required this.checkInTime,
    required this.checkCalledTime,
    required this.checkCompletedTime,
    required this.branchName,
    required this.companyName,
    required this.representativeId,
    required this.representativeName,
    required this.representativeFingerPrint,
    required this.companyId,
    required this.branchId,
  });

  factory TicketEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return TicketEntity(
      id: _asInt(map['id']),
      ticketsNumber: _asInt(map['ticketsNumber']),
      status: _asString(map['status']),
      checkInTime: _asString(map['checkInTime']),
      checkCalledTime: _asString(map['checkCalledTime']),
      checkCompletedTime: _asString(map['checkCompletedTime']),
      branchName: _asString(map['branchName']),
      companyName: _asString(map['companyName']),
      representativeId: _asInt(map['representativeId']),
      representativeName: _asString(map['representativeName']),
      representativeFingerPrint: _asString(map['representativeFingerPrint']),
      companyId: _asInt(map['companyId']),
      branchId: _asInt(map['branchId']),
    );
  }

  bool get isWaiting => status.toLowerCase() == 'waiting';

  bool get hasCalledTime =>
      checkCalledTime.isNotEmpty && !checkCalledTime.startsWith('0001-01-01');

  bool get hasCompletedTime =>
      checkCompletedTime.isNotEmpty &&
      !checkCompletedTime.startsWith('0001-01-01');
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

String _asString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
