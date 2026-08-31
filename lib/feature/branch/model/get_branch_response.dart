import 'branch_entity.dart';

/// الـ endpoint بيرجع List مباشرة:
/// [{"id":1,"name":"Gesr Elsuez"},{"id":2,"name":"Giza"}]
class GetBranchResponse {
  final List<BranchEntity> branches;

  const GetBranchResponse({
    required this.branches,
  });

  factory GetBranchResponse.fromJson(dynamic json) {
    if (json is List) {
      return GetBranchResponse(
        branches: json
            .map((item) => BranchEntity.fromJson(item))
            .where((branch) => branch.hasData)
            .toList(),
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['branches'] ??
        map['items'] ??
        map['result'] ??
        map['results'];

    if (data is List) {
      return GetBranchResponse(
        branches: data
            .map((item) => BranchEntity.fromJson(item))
            .where((branch) => branch.hasData)
            .toList(),
      );
    }

    return const GetBranchResponse(branches: []);
  }

  int get count => branches.length;

  bool get isEmpty => branches.isEmpty;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
