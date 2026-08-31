class CompanyEntity {
  final int id;
  final String name;

  const CompanyEntity({
    required this.id,
    required this.name,
  });

  factory CompanyEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return CompanyEntity(
      id: _asInt(map['id']),
      name: _asString(map['name']),
    );
  }

  const CompanyEntity.empty()
      : id = 0,
        name = '';

  bool get hasData => id != 0 || name.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
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
