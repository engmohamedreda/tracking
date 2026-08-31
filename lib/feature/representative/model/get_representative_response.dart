import 'representative_entity.dart';

/// الـ response بيرجع مغلّف بالـ pagination:
/// {"data":[...],"currentPage":1,"pageSize":10,"totalCount":89,
///  "totalPages":45,"hasPrevious":false,"hasNext":true}
class GetRepresentativeResponse {
  final List<RepresentativeEntity> representatives;
  final int currentPage;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;

  const GetRepresentativeResponse({
    required this.representatives,
    required this.currentPage,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
  });

  factory GetRepresentativeResponse.fromJson(dynamic json) {
    // لو السيرفر رجّع List مباشرة من غير غلاف pagination.
    if (json is List) {
      final items = json
          .map((item) => RepresentativeEntity.fromJson(item))
          .where((representative) => representative.hasData)
          .toList();

      return GetRepresentativeResponse(
        representatives: items,
        currentPage: 1,
        pageSize: items.length,
        totalCount: items.length,
        totalPages: 1,
        hasPrevious: false,
        hasNext: false,
      );
    }

    final map = _asMap(json);
    final dynamic data = map['data'] ?? map['items'] ?? map['result'];

    final items = data is List
        ? data
            .map((item) => RepresentativeEntity.fromJson(item))
            .where((representative) => representative.hasData)
            .toList()
        : <RepresentativeEntity>[];

    return GetRepresentativeResponse(
      representatives: items,
      currentPage: _asInt(map['currentPage'], fallback: 1),
      pageSize: _asInt(map['pageSize'], fallback: items.length),
      totalCount: _asInt(map['totalCount'], fallback: items.length),
      totalPages: _asInt(map['totalPages'], fallback: 1),
      hasPrevious: _asBool(map['hasPrevious']),
      hasNext: _asBool(map['hasNext']),
    );
  }

  int get count => representatives.length;

  bool get isEmpty => representatives.isEmpty;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is num) return value.toInt() == 1;
  if (value is String) {
    final lower = value.toLowerCase().trim();
    return lower == 'true' || lower == '1' || lower == 'yes';
  }
  return false;
}
