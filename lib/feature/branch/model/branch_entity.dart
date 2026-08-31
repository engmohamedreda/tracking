class BranchEntity {
  final int id;
  final String name;

  const BranchEntity({
    required this.id,
    required this.name,
  });

  factory BranchEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return BranchEntity(
      id: _asInt(map['id']),
      name: _asString(map['name']),
    );
  }

  const BranchEntity.empty()
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
