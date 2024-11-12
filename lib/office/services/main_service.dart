import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class MainService {
  Future<Response<dynamic>> ownerHome() async {
    try {
      final response = await RequestApi.get(
        path: RestApiUri.ownerHome,
      );

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> operationStatus({
    required String storeId,
    required int operationStatus,
  }) async {
    try {
      final response = await RequestApi.post(RestApiUri.operationStatus, data: {
        'storeId': storeId,
        'operationStatus': operationStatus,
      });

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }
}

final mainServiceProvider = Provider<MainService>((ref) => MainService());
