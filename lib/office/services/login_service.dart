import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class LoginService {
  Future<Response<dynamic>> directLogin({
    required String loginId,
    required String password,
  }) async {
    try {
      final response = await RequestApi.post(
        RestApiUri.directLogin,
        queryParameters: {
          'loginId': loginId,
          'password': password,
        },
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

final loginServiceProvider = Provider<LoginService>((ref) => LoginService());
