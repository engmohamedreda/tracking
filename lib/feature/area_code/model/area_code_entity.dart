class AreaCodeEntity {
  final int id;
  final String code;

  const AreaCodeEntity({
    required this.id,
    required this.code,
  });

  factory AreaCodeEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return AreaCodeEntity(
      id: _asInt(map['id']),
      code: _asString(map['code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
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
