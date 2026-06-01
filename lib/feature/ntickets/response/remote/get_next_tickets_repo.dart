import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/get_next_tickets_response.dart';
import '../interface/i_get_next_tickets_repo.dart';

@LazySingleton(as: IGetNextTicketsRepo)
class GetNextTicketsRepo implements IGetNextTicketsRepo {
  final Apimanager apimanager;

  GetNextTicketsRepo(this.apimanager);

  @override
  Future<Either<Failures, GetNextTicketsResponse>> getNextTickets() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    try {
      final response = await apimanager.getData(
        endpoint: Endpoint.getNextTickets,
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          GetNextTicketsResponse.fromJson(response.data),
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

  String _extractErrorMessage(Response response) {
    final data = response.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
