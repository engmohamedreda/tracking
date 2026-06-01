import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../../core/helper/failures.dart';
import '../../model/login_request.dart';
import '../../model/login_response.dart';
import '../interface/i_login_repo.dart';

@LazySingleton(as: ILoginRepo)
class LoginRepo implements ILoginRepo {
  final Apimanager apimanager;

  LoginRepo(this.apimanager);

  @override
  Future<Either<Failures, LoginResponse>> login({
    required String username,
    required String password,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    try {
      final request = LoginRequest(
        username: username,
        password: password,
      );

      final response = await apimanager.Postdata(
        endpoint: Endpoint.newLogin,
        body: request.toJson(),
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final loginResponse = LoginResponse.fromJson(response.data);

        if (!loginResponse.success) {
          return left(
            ServerError(
              errorMsg: _extractErrorMessage(response, loginResponse),
            ),
          );
        }

        await _saveLoginData(loginResponse);

        return right(loginResponse);
      }

      return left(
        ServerError(
          errorMsg: _extractErrorMessage(response, null),
        ),
      );
    } catch (e) {
      return left(
        ServerError(errorMsg: e.toString()),
      );
    }
  }

  Future<void> _saveLoginData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();

    // ApiManager already reads token from this key.
    await prefs.setString('token', loginResponse.token);

    // User id requested to be saved in SharedPreferences.
    await prefs.setString('userId', loginResponse.user.id);

    // Optional useful user data.
    await prefs.setString('userName', loginResponse.user.userName);
    await prefs.setString('fullName', loginResponse.user.fullName);
    await prefs.setInt('companyId', loginResponse.user.companyId);
    await prefs.setInt('branchId', loginResponse.user.branchId);
    await prefs.setString('companyName', loginResponse.user.companyName);
    await prefs.setString('branchName', loginResponse.user.branchName);
  }

  bool _isNoInternet(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult.contains(ConnectivityResult.none) &&
          connectivityResult.length == 1;
    }

    return connectivityResult == ConnectivityResult.none;
  }

  String _extractErrorMessage(
    Response response,
    LoginResponse? loginResponse,
  ) {
    final data = response.data;

    if (data is Map) {
      final message = data['message'] ??
          data['error'] ??
          data['title'] ??
          data['errors'];

      if (message != null) return message.toString();
    }

    if (loginResponse != null && loginResponse.deviceStatus.message.isNotEmpty) {
      return loginResponse.deviceStatus.message;
    }

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
