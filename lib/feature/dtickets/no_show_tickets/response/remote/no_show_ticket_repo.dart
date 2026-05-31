import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../../core/helper/failures.dart';
import '../../model/no_show_ticket_response.dart';
import '../interface/i_no_show_ticket_repo.dart';

@LazySingleton(as: INoShowTicketRepo)
class NoShowTicketRepo implements INoShowTicketRepo {
  final Apimanager apimanager;

  NoShowTicketRepo(this.apimanager);

  @override
  Future<Either<Failures, NoShowTicketResponse>> markNoShow({
    required int ticketId,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (_isNoInternet(connectivityResult)) {
      return left(
        NEtworkerror(errorMsg: 'No internet connection'),
      );
    }

    try {
      final response = await apimanager.Postdata(
        endpoint: Endpoint.noShowTicket(ticketId),
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        return right(
          NoShowTicketResponse.fromJson(response.data),
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

    if (data != null && data.toString().isNotEmpty) {
      return data.toString();
    }

    return response.statusMessage ?? 'Something went wrong';
  }
}
