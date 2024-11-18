import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class SuccessChangePasswordService {
  Future<Response<dynamic>> load() async {
    try {
      final response = await RequestApi.get(
        path: RestApiUri.loadNotification.replaceAll('{page}', '0'),
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
}

final successChangePasswordServiceProvider =
    Provider<SuccessChangePasswordService>(
        (ref) => SuccessChangePasswordService());
