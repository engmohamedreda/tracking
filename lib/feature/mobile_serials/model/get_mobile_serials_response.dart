import 'mobile_serial_entity.dart';

class GetMobileSerialsResponse {
  final MobileSerialEntity mobileSerial;

  const GetMobileSerialsResponse({
    required this.mobileSerial,
  });

  factory GetMobileSerialsResponse.fromJson(dynamic json) {
    if (json is List) {
      if (json.isEmpty) {
        return const GetMobileSerialsResponse(
          mobileSerial: MobileSerialEntity.empty(),
        );
      }

      return GetMobileSerialsResponse(
        mobileSerial: MobileSerialEntity.fromJson(json.first),
      );
    }

    final map = _asMap(json);

    final dynamic data = map['data'] ??
        map['mobileSerial'] ??
        map['serial'] ??
        map['item'] ??
        map['result'];

    if (data is Map || data is List) {
      return GetMobileSerialsResponse.fromJson(data);
    }

    return GetMobileSerialsResponse(
      mobileSerial: MobileSerialEntity.fromJson(map),
    );
  }

  bool get hasData => mobileSerial.hasData;
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return {};
}
