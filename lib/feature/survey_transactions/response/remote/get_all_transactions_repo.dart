import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/get_all_transactions_response.dart';
import '../interface/i_get_all_transactions_repo.dart';

@LazySingleton(as: IGetAllTransactionsRepo)
class GetAllTransactionsRepo implements IGetAllTransactionsRepo {
  final Apimanager apimanager;

  GetAllTransactionsRepo(this.apimanager);

  @override
  Future<Either<Failures, GetAllTransactionsResponse>> getAllTransactions({
    DateTime? from,
    DateTime? to,
    int? branchId,
    int? companyId,
    String? status,
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
        endpoint: Endpoint.getAllTransactions,
        // الفلاتر بتتبعت بس لو مبعوتة، والتواريخ بتتحول لـ ISO 8601
        // زي ما الـ Swagger متوقع (string date-time).
        queryParameters: {
          if (from != null) 'From': from.toIso8601String(),
          if (to != null) 'To': to.toIso8601String(),
          'BranchId': ?branchId,
          'CompanyId': ?companyId,
          if (status != null && status.trim().isNotEmpty) 'Status': status,
          'page': page,
          'pageSize': pageSize,
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
          GetAllTransactionsResponse.fromJson(response.data),
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
