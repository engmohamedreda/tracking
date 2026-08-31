import 'company_entity.dart';

/// الـ endpoint بيرجع List مباشرة: [{"id":1,"name":"Wagd_Nestle"}]
/// بس سايبين الـ parsing متسامح لو اتغلّف في object بعدين.
class GetCompanyResponse {
  final List<CompanyEntity> companies;

  const GetCompanyResponse({
    required this.companies,
  });

  factory GetCompanyResponse.fromJson(dynamic json) {
    if (json is List) {
      return GetCompanyResponse(
        companies: json
            .map((item) => CompanyEntity.fromJson(item))
            .where((company) => company.hasData)
            .toList(),
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['companies'] ??
        map['items'] ??
        map['result'] ??
        map['results'];

    if (data is List) {
      return GetCompanyResponse(
        companies: data
            .map((item) => CompanyEntity.fromJson(item))
            .where((company) => company.hasData)
            .toList(),
      );
    }

    return const GetCompanyResponse(companies: []);
  }

  int get count => companies.length;

  bool get isEmpty => companies.isEmpty;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
