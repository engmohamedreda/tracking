import 'area_code_entity.dart';

class GetAreaCodeResponse {
  final List<AreaCodeEntity> areaCodes;

  const GetAreaCodeResponse({
    required this.areaCodes,
  });

  factory GetAreaCodeResponse.fromJson(dynamic json) {
    if (json is List) {
      return GetAreaCodeResponse(
        areaCodes: json
            .map((item) => AreaCodeEntity.fromJson(item))
            .where((areaCode) => areaCode.id != 0 || areaCode.code.isNotEmpty)
            .toList(),
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['areaCodes'] ??
        map['codes'] ??
        map['items'] ??
        map['result'] ??
        map['results'];

    if (data is List) {
      return GetAreaCodeResponse(
        areaCodes: data
            .map((item) => AreaCodeEntity.fromJson(item))
            .where((areaCode) => areaCode.id != 0 || areaCode.code.isNotEmpty)
            .toList(),
      );
    }

    return const GetAreaCodeResponse(areaCodes: []);
  }

  int get count => areaCodes.length;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
