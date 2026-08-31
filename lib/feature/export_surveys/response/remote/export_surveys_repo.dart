import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/export_surveys_response.dart';
import '../interface/i_export_surveys_repo.dart';

@LazySingleton(as: IExportSurveysRepo)
class ExportSurveysRepo implements IExportSurveysRepo {
  final Apimanager apimanager;

  ExportSurveysRepo(this.apimanager);

  /// الاسم اللي السيرفر فعلاً بيبعته في content-disposition.
  static const String _fallbackFileName = 'Survays.xlsx';

  @override
  Future<Either<Failures, ExportSurveysResponse>> exportSurveys({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
    int page = 1,
    int pageSize = 100,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    try {
      // مهم: responseType لازم bytes لأن الـ endpoint بيرجع ملف xlsx
      // مش JSON، ولو سيبناه json الـ Dio بيحاول يعمل decode ويرمي error.
      final response = await apimanager.getData(
        endpoint: Endpoint.exportSurveys,
        // هنا الباراميترز بالحرف الصغير زي ما هي في الـ Swagger.
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (from != null) 'from': from.toIso8601String(),
          if (to != null) 'to': to.toIso8601String(),
          'branchId': ?branchId,
          'companyId': ?companyId,
          if (status != null && status.trim().isNotEmpty) 'status': status,
        },
        headers: const {'accept': '*/*'},
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final bytes = _asBytes(response.data);

        if (bytes.isEmpty) {
          return left(
            ServerError(errorMsg: 'الملف الراجع من السيرفر فاضي'),
          );
        }

        final fileName = ExportSurveysResponse.parseFileName(
          contentDisposition: response.headers.value('content-disposition'),
          fallback: _fallbackFileName,
        );

        return right(
          ExportSurveysResponse(
            fileName: fileName,
            bytes: bytes,
            contentType: response.headers.value('content-type') ??
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          ),
        );
      }

      return left(
        ServerError(errorMsg: _extractErrorMessage(response)),
      );
    } catch (e) {
      return left(
        ServerError(errorMsg: e.toString()),
      );
    }
  }

  /// الـ data بترجع `List<int>` على الموبايل و ByteBuffer/Uint8List على الويب،
  /// فبنوحدها كلها لـ Uint8List.
  Uint8List _asBytes(dynamic data) {
    if (data == null) return Uint8List(0);
    if (data is Uint8List) return data;
    if (data is ByteBuffer) return data.asUint8List();
    if (data is List<int>) return Uint8List.fromList(data);
    if (data is List) {
      return Uint8List.fromList(
        data.map((item) => int.tryParse(item.toString()) ?? 0).toList(),
      );
    }
    return Uint8List(0);
  }

  bool _isNoInternet(dynamic connectivityResult) {
    if (connectivityResult is List<ConnectivityResult>) {
      return connectivityResult.length == 1 &&
          connectivityResult.contains(ConnectivityResult.none);
    }

    return connectivityResult == ConnectivityResult.none;
  }

  /// في حالة الخطأ الـ body بيرجع bytes كمان، فبنحوله لنص الأول.
  String _extractErrorMessage(Response response) {
    final data = response.data;

    if (data is List<int> && data.isNotEmpty) {
      try {
        final text = String.fromCharCodes(data).trim();
        if (text.isNotEmpty) return text;
      } catch (_) {
        // متجاهلين، هنرجع الرسالة العامة تحت.
      }
    }

    if (data is Map) {
      final message = data['message'] ?? data['error'] ?? data['title'];
      if (message != null) return message.toString();
    }

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
