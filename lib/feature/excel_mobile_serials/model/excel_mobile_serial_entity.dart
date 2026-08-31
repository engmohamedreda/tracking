class ExcelMobileSerialEntity {
  final int id;
  final String serial;
  final String areaCode;

  const ExcelMobileSerialEntity({
    required this.id,
    required this.serial,
    required this.areaCode,
  });

  /// الشكل الفعلي الراجع من الـ API:
  /// {"id":1,"serial":"rk8y40015mt","areaCode":"CGC001"}
  factory ExcelMobileSerialEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return ExcelMobileSerialEntity(
      id: _asInt(map['id']),
      serial: _asString(map['serial']),
      areaCode: _asString(map['areaCode']),
    );
  }

  const ExcelMobileSerialEntity.empty()
      : id = 0,
        serial = '',
        areaCode = '';

  bool get hasData => id != 0 || serial.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serial': serial,
      'areaCode': areaCode,
    };
  }
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
