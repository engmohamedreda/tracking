import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/failures.dart';
import '../../model/excel_template_response.dart';
import '../../model/excel_template_type.dart';
import '../interface/i_excel_template_repo.dart';

@LazySingleton(as: IExcelTemplateRepo)
class ExcelTemplateRepo implements IExcelTemplateRepo {
  final Apimanager apimanager;

  ExcelTemplateRepo(this.apimanager);

  @override
  Future<Either<Failures, ExcelTemplateResponse>> downloadTemplate({
    required ExcelTemplateType type,
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
        endpoint: type.endpoint,
        headers: const {'accept': '*/*'},
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
        ),
      );

      _printResponseDebug(type: type, response: response);

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        final bytes = _asBytes(response.data);

        if (bytes.isEmpty) {
          return left(
            ServerError(errorMsg: 'الملف الراجع من السيرفر فاضي'),
          );
        }

        final fileName = ExcelTemplateResponse.parseFileName(
          contentDisposition:
              response.headers.value('content-disposition'),
          fallback: type.fallbackFileName,
        );

        return right(
          ExcelTemplateResponse(
            type: type,
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
      print('================ EXCEL TEMPLATE EXCEPTION ================');
      print(e.toString());
      print('=========================================================');
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

  void _printResponseDebug({
    required ExcelTemplateType type,
    required Response response,
  }) {
    print('================ EXCEL TEMPLATE RESPONSE DEBUG ================');
    print('Type: ${type.name}');
    print('Endpoint: ${type.endpoint}');
    print('StatusCode: ${response.statusCode}');
    print('content-type: ${response.headers.value('content-type')}');
    print('content-length: ${response.headers.value('content-length')}');
    print(
      'content-disposition: ${response.headers.value('content-disposition')}',
    );
    print('==============================================================');
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
