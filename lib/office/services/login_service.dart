import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class LoginService {
  final Ref ref;

  LoginService(this.ref);

  Future<Response<dynamic>> directLogin({
    required String loginId,
    required String password,
  }) async {
    try {
      final response = ref.read(requestApiProvider).post(
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

  Future<Response<dynamic>> verifyPhone({required String loginId}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.verifyPhone,
        queryParameters: {
          'loginId': loginId,
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

  Future<Response<dynamic>> fcmToken({required String fcmToken}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.fcmToken,
        data: {
          'fcmToken': fcmToken,
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

  Future<Response<dynamic>> logout({required String fcmTokenId}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.logout,
        queryParameters: {
          'fcmTokenId': fcmTokenId,
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

  Future<Response<dynamic>> autoLogin() async {
    try {
      final response =
          ref.read(requestApiProvider).get(path: RestApiUri.autoLogin);
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

final loginServiceProvider = Provider<LoginService>((ref) => LoginService(ref));
