import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/helper/Api/ApiManager/ApiManager.dart';
import '../../../../../core/helper/Api/ApiManager/EndPoint.dart';
import '../../../../../core/helper/failures.dart';
import '../../model/delete_tickets_response.dart';
import '../interface/i_delete_tickets_repo.dart';

@LazySingleton(as: IDeleteTicketsRepo)
class DeleteTicketsRepo implements IDeleteTicketsRepo {
  final Apimanager apimanager;

  DeleteTicketsRepo(this.apimanager);

  @override
  Future<Either<Failures, DeleteTicketsResponse>> deleteTicket({
    required int ticketId,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return left(
        NEtworkerror(errorMsg: 'لا يوجد اتصال بالإنترنت'),
      );
    }

    try {
      final response = await apimanager.Postdata(
        endpoint: Endpoint.deleteTickets,
        queryParameters: {
          'TicketId': ticketId,
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
          DeleteTicketsResponse.fromJson(response.data),
        );
      } else {
        return left(
          ServerError(
            errorMsg: _extractErrorMessage(response),
          ),
        );
      }
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

    return response.statusMessage ?? 'حدث خطأ غير متوقع';
  }
}
