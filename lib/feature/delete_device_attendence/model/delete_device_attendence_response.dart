class DeleteDeviceAttendenceResponse {
  final bool success;
  final String message;

  const DeleteDeviceAttendenceResponse({required this.success, required this.message});

  factory DeleteDeviceAttendenceResponse.fromJson(dynamic json) {
    if (json is bool) {
      return DeleteDeviceAttendenceResponse(
        success: json,
        message: json ? 'تم حذف حضور الجهاز بنجاح' : 'لم يتم حذف حضور الجهاز',
      );
    }
    if (json is Map) {
      final value = json['success'] ?? json['isDeleted'] ?? json['deleted'] ?? json['data'];
      final success = value is bool || value?.toString().toLowerCase() == 'true';
      return DeleteDeviceAttendenceResponse(
        success: success,
        message: (json['message'] ?? json['error'] ??
                (success ? 'تم حذف حضور الجهاز بنجاح' : 'لم يتم حذف حضور الجهاز'))
            .toString(),
      );
    }
    return const DeleteDeviceAttendenceResponse(
      success: true,
      message: 'تم حذف حضور الجهاز بنجاح',
    );
  }
}