class RepresentativeEntity {
  final int id;
  final String name;
  final String fingerPrint;
  final String phone;
  final String companyName;
  final String branchName;

  const RepresentativeEntity({
    required this.id,
    required this.name,
    required this.fingerPrint,
    required this.phone,
    required this.companyName,
    required this.branchName,
  });

  /// الشكل الفعلي الراجع من الـ API:
  /// {"id":1,"name":"...","fingerPrint":"16146","phone":"01124090080",
  ///  "companyName":"Wagd_Nestle","branchName":"Gesr Elsuez"}
  factory RepresentativeEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return RepresentativeEntity(
      id: _asInt(map['id']),
      name: _asString(map['name']),
      fingerPrint: _asString(map['fingerPrint']),
      phone: _asString(map['phone']),
      companyName: _asString(map['companyName']),
      branchName: _asString(map['branchName']),
    );
  }

  const RepresentativeEntity.empty()
      : id = 0,
        name = '',
        fingerPrint = '',
        phone = '',
        companyName = '',
        branchName = '';

  bool get hasData => id != 0 || name.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fingerPrint': fingerPrint,
      'phone': phone,
      'companyName': companyName,
      'branchName': branchName,
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
