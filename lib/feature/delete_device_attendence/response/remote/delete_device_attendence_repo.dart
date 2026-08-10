import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/delete_device_attendence_response.dart';
import '../interface/i_delete_device_attendence_repo.dart';

@LazySingleton(as: IDeleteDeviceAttendenceRepo)
class DeleteDeviceAttendenceRepo implements IDeleteDeviceAttendenceRepo {
  final Apimanager apimanager;

  DeleteDeviceAttendenceRepo(this.apimanager);

  @override
  Future<Either<Failures, DeleteDeviceAttendenceResponse>> deleteDeviceAttendence() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity is List<ConnectivityResult> &&
        connectivity.length == 1 &&
        connectivity.contains(ConnectivityResult.none)) {
      return left(NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      print('========== DELETE DEVICE ATTENDENCE REQUEST ==========');
      print('Endpoint: ${Endpoint.deleteDeviceAttendence}');
      print('Method: GET');
      final response = await apimanager.getData(
        endpoint: Endpoint.deleteDeviceAttendence,
        options: Options(contentType: 'application/json', validateStatus: (status) => true),
      );
      print('========== DELETE DEVICE ATTENDENCE RESPONSE ==========');
      print('Status code: ${response.statusCode}');
      print('Status message: ${response.statusMessage}');
      print('Body: ${response.data}');
      print('========================================================');

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return right(DeleteDeviceAttendenceResponse.fromJson(response.data));
      }

      return left(ServerError(errorMsg: _extractErrorMessage(response)));
    } catch (e) {
      return left(ServerError(errorMsg: e.toString()));
    }
  }

  String _extractErrorMessage(Response response) {
    final data = response.data;
    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? data['title'];
      if (message != null) return message.toString();
    }
    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}