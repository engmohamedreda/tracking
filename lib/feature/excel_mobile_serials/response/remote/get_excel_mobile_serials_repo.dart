import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/get_excel_mobile_serials_response.dart';
import '../interface/i_get_excel_mobile_serials_repo.dart';

@LazySingleton(as: IGetExcelMobileSerialsRepo)
class GetExcelMobileSerialsRepo implements IGetExcelMobileSerialsRepo {
  final Apimanager apimanager;

  GetExcelMobileSerialsRepo(this.apimanager);

  @override
  Future<Either<Failures, GetExcelMobileSerialsResponse>>
      getExcelMobileSerials({
    int? areaCodeId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    try {
      final response = await apimanager.getData(
        endpoint: Endpoint.getExcelMobileSerials,
        // الفلتر بيتبعت بس لو مبعوت، والـ API اسم الباراميتر عنده
        // `Pageize` مش `PageSize`.
        queryParameters: {
          'AreaCodeId': ?areaCodeId,
          'page': page,
          'Pageize': pageSize,
        },
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          GetExcelMobileSerialsResponse.fromJson(response.data),
        );
      }

      return left(
        ServerError(
          errorMsg: _extractErrorMessage(response),
        ),
      );
    } catch (e) {
      return left(
        ServerError(errorMsg: e.toString()),
      );
    }
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

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
