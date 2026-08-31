class ExcelAreaCodeEntity {
  final int id;
  final String code;
  final String companyName;
  final String branchName;

  const ExcelAreaCodeEntity({
    required this.id,
    required this.code,
    required this.companyName,
    required this.branchName,
  });

  /// الشكل الفعلي الراجع من الـ API:
  /// {"id":1,"code":"CGC001","companyName":"Wagd_Nestle","branchName":"Gesr Elsuez"}
  factory ExcelAreaCodeEntity.fromJson(dynamic json) {
    final map = _asMap(json);

    return ExcelAreaCodeEntity(
      id: _asInt(map['id']),
      code: _asString(map['code']),
      companyName: _asString(map['companyName']),
      branchName: _asString(map['branchName']),
    );
  }

  const ExcelAreaCodeEntity.empty()
      : id = 0,
        code = '',
        companyName = '',
        branchName = '';

  bool get hasData => id != 0 || code.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
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
