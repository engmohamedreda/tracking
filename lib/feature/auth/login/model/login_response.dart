class LoginResponse {
  final bool success;
  final String token;
  final LoginUser user;
  final LoginDevice device;
  final LoginDeviceStatus deviceStatus;

  const LoginResponse({
    required this.success,
    required this.token,
    required this.user,
    required this.device,
    required this.deviceStatus,
  });

  factory LoginResponse.fromJson(dynamic json) {
    final map = _asMap(json);

    return LoginResponse(
      success: _asBool(map['success']),
      token: _asString(map['token']),
      user: LoginUser.fromJson(map['user']),
      device: LoginDevice.fromJson(map['device']),
      deviceStatus: LoginDeviceStatus.fromJson(map['deviceStatus']),
    );
  }
}

class LoginUser {
  final String id;
  final String userName;
  final String fullName;
  final int companyId;
  final int branchId;
  final String roleName;
  final String companyName;
  final String branchName;

  const LoginUser({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.companyId,
    required this.branchId,
    required this.roleName,
    required this.companyName,
    required this.branchName,
  });

  factory LoginUser.fromJson(dynamic json) {
    final map = _asMap(json);

    return LoginUser(
      id: _asString(map['id']),
      userName: _asString(map['userName']),
      fullName: _asString(map['fullName']),
      companyId: _asInt(map['companyId']),
      // الـ API بيرجع brandId مش branchId في بعض الحالات.
      branchId: _asInt(map['branchId'] ?? map['brandId']),
      roleName: _asString(map['roleName']),
      companyName: _asString(map['companyName']),
      branchName: _asString(map['branchName']),
    );
  }

  /// الـ SuperAdmin هو الوحيد اللي يشوف لوحة الإكسيل.
  /// بنقارن من غير حساسية لحالة الحروف والمسافات لأن السيرفر
  /// ممكن يرجعها بأشكال مختلفة.
  bool get isSuperAdmin =>
      roleName.replaceAll(' ', '').toLowerCase() == 'superadmin';
}

class LoginDevice {
  final String name;
  final String ipAddress;
  final int port;
  final bool isConnected;

  const LoginDevice({
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.isConnected,
  });

  factory LoginDevice.fromJson(dynamic json) {
    final map = _asMap(json);

    return LoginDevice(
      name: _asString(map['name']),
      ipAddress: _asString(map['ipAddress']),
      port: _asInt(map['port']),
      isConnected: _asBool(map['isConnected']),
    );
  }
}

class LoginDeviceStatus {
  final bool isConnected;
  final String message;

  const LoginDeviceStatus({
    required this.isConnected,
    required this.message,
  });

  factory LoginDeviceStatus.fromJson(dynamic json) {
    final map = _asMap(json);

    return LoginDeviceStatus(
      isConnected: _asBool(map['isConnected']),
      message: _asString(map['message']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
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

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) {
    final normalized = value.toLowerCase().trim();
    return normalized == 'true' || normalized == '1';
  }
  return false;
}
