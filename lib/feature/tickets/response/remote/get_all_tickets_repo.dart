import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../core/helper/failures.dart';
import '../../model/get_all_tickets_response.dart';
import '../interface/i_get_all_tickets_repo.dart';

@LazySingleton(as: IGetAllTicketsRepo)
class GetAllTicketsRepo implements IGetAllTicketsRepo {
  final Apimanager apimanager;

  GetAllTicketsRepo(this.apimanager);

  @override
  Future<Either<Failures, GetAllTicketsResponse>> getAllTickets() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return left(
        NEtworkerror(errorMsg: 'No internet connection'),
      );
    }

    try {
      final response = await apimanager.getData(
        endpoint: Endpoint.getAllTickets,
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          GetAllTicketsResponse.fromJson(response.data),
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

    return response.statusMessage ?? 'Something went wrong';
  }
}
