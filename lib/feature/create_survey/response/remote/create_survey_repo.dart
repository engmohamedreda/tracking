import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/create_survey_request.dart';
import '../../model/create_survey_response.dart';
import '../interface/i_create_survey_repo.dart';

@LazySingleton(as: ICreateSurveyRepo)
class CreateSurveyRepo implements ICreateSurveyRepo {
  final Apimanager apimanager;

  CreateSurveyRepo(this.apimanager);

  @override
  Future<Either<Failures, CreateSurveyResponse>> createSurvey({
    required CreateSurveyRequest request,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'No internet connection'),
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserId = prefs.getString('userId') ?? '';
      final userId = request.userId.trim().isNotEmpty
          ? request.userId.trim()
          : savedUserId.trim();

      final formData = await request.toFormData(overrideUserId: userId);

      // مهم: ده هيطبع في الـ terminal كل القيم اللي رايحة للـ API
      // وكمان يطلعلك إيه الناقص قبل ما الريكوست يتبعت.
      _printCreateSurveyDebug(
        request: request,
        formData: formData,
        effectiveUserId: userId,
      );

      final response = await apimanager.Postdata(
        endpoint: Endpoint.createSurvey,
        body: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => true,
        ),
      );

      _printCreateSurveyResponseDebug(response);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          CreateSurveyResponse.fromJson(response.data),
        );
      }

      return left(
        ServerError(
          errorMsg: _extractErrorMessage(response),
        ),
      );
    } catch (e) {
      print('================ CREATE SURVEY EXCEPTION ================');
      print(e.toString());
      print('=========================================================');
      return left(
        ServerError(errorMsg: e.toString()),
      );
    }
  }

  void _printCreateSurveyDebug({
    required CreateSurveyRequest request,
    required FormData formData,
    required String effectiveUserId,
  }) {
    final missing = request.findMissingFields(overrideUserId: effectiveUserId);

    print('================ CREATE SURVEY REQUEST DEBUG ================');
    print('Endpoint: ${Endpoint.createSurvey}');

    if (missing.isEmpty) {
      print('Missing check: OK - no obvious missing values');
    } else {
      print('Missing / possible missing fields: ${missing.join(', ')}');
    }

    print('---------------- Fields sent to multipart/form-data ----------------');
    for (final field in formData.fields) {
      print('${field.key} = ${_shortValue(field.value)}');
    }

    print('---------------- Files sent to multipart/form-data ----------------');
    if (formData.files.isEmpty) {
      print('NO FILES SENT -> SurvayAttachment is empty');
    } else {
      for (final file in formData.files) {
        final multipartFile = file.value;
        print(
          '${file.key} = filename: ${multipartFile.filename}, '
          'length: ${multipartFile.length}',
        );
      }
    }

    print('---------------- Debug JSON ----------------');
    print(jsonEncode(request.toDebugJson(overrideUserId: effectiveUserId)));
    print('===============================================================');
  }

  void _printCreateSurveyResponseDebug(Response response) {
    print('================ CREATE SURVEY RESPONSE DEBUG ================');
    print('StatusCode: ${response.statusCode}');
    print('StatusMessage: ${response.statusMessage}');
    print('Body: ${response.data}');
    print('===============================================================');
  }

  String _shortValue(String value) {
    if (value.length <= 600) return value;
    return '${value.substring(0, 600)}... [length=${value.length}]';
  }

  bool _isNoInternet(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult.length == 1 &&
          connectivityResult.contains(ConnectivityResult.none);
    }

    return connectivityResult == ConnectivityResult.none;
  }

  String _extractErrorMessage(Response response) {
    final data = response.data;

    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? data['title'];
      if (message != null) return message.toString();
    }

    if (data != null && data.toString().isNotEmpty) {
      return data.toString();
    }

    return response.statusMessage ?? 'Something went wrong';
  }
}
