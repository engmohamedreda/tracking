import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class Apimanager {
  final Dio dio = Dio();

  Apimanager() {
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      )
    ]);
  }

  Future<Response> getData({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? headers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final mergedHeaders = {
      'Authorization': 'Bearer $token',
      ...?headers,
      ...?options?.headers,
    };

    final finalOptions = (options ?? Options()).copyWith(
      headers: mergedHeaders,
      validateStatus: (status) => true,
    );

    return dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: finalOptions,
    );
  }

  Future<Response> Postdata({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Object? body,
    Map<String, dynamic>? headers,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final mergedHeaders = {
      'Authorization': 'Bearer $token',
      ...?headers,
      ...?options?.headers,
    };

    final finalOptions = (options ?? Options()).copyWith(
      headers: mergedHeaders,
      validateStatus: (status) => true,
    );

    return dio.post(
      endpoint,
      data: body,
      queryParameters: queryParameters,
      options: finalOptions,
    );
  }
}
