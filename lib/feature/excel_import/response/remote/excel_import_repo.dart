import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/failures.dart';
import '../../model/excel_import_request.dart';
import '../../model/excel_import_response.dart';
import '../interface/i_excel_import_repo.dart';

@LazySingleton(as: IExcelImportRepo)
class ExcelImportRepo implements IExcelImportRepo {
  final Apimanager apimanager;

  ExcelImportRepo(this.apimanager);

  @override
  Future<Either<Failures, ExcelImportResponse>> importExcel({
    required ExcelImportRequest request,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    final missing = request.findMissingFields();
    if (missing.isNotEmpty) {
      return left(
        ServerError(errorMsg: 'من فضلك اختر ملف إكسيل صحيح أولاً'),
      );
    }

    try {
      final formData = request.toFormData();

      _printRequestDebug(request: request, formData: formData);

      final response = await apimanager.Postdata(
        endpoint: request.endpoint,
        body: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => true,
        ),
      );

      _printResponseDebug(response);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          ExcelImportResponse.fromJson(
            response.data,
            defaultMessage: request.type.successMessage,
          ),
        );
      }

      return left(
        ServerError(errorMsg: _extractErrorMessage(response)),
      );
    } catch (e) {
      print('================ EXCEL IMPORT EXCEPTION ================');
      print(e.toString());
      print('=======================================================');
      return left(
        ServerError(errorMsg: e.toString()),
      );
    }
  }

  void _printRequestDebug({
    required ExcelImportRequest request,
    required FormData formData,
  }) {
    print('================ EXCEL IMPORT REQUEST DEBUG ================');
    print('Endpoint: ${request.endpoint}');
    print('Method: POST');
    print('ContentType: multipart/form-data');
    print(jsonEncode(request.toDebugJson()));

    if (formData.files.isEmpty) {
      print('NO FILES SENT -> excelfile is empty');
    } else {
      for (final file in formData.files) {
        print(
          '${file.key} = filename: ${file.value.filename}, '
          'length: ${file.value.length}',
        );
      }
    }
    print('===========================================================');
  }

  void _printResponseDebug(Response response) {
    print('================ EXCEL IMPORT RESPONSE DEBUG ================');
    print('StatusCode: ${response.statusCode}');
    print('StatusMessage: ${response.statusMessage}');
    print('Body: ${response.data}');
    print('============================================================');
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

    if (data != null && data.toString().trim().isNotEmpty) {
      return data.toString();
    }

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
