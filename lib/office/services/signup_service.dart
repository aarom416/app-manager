import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class SignupService {
  Future<Response<dynamic>> checkLoginId({required String loginId}) async {
    try {
      final response = await RequestApi.post(
          RestApiUri.checkLoginId.replaceAll('{loginId}', loginId));
      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> sendCode({required String email}) async {
    try {
      final response = await RequestApi.post(
        RestApiUri.sendCode,
        queryParameters: {
          'email': email,
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

  Future<Response<dynamic>> verifyCode(
      {required String email, required String authCode}) async {
    try {
      final response = await RequestApi.post(
        RestApiUri.verifyCode,
        data: {
          'email': email,
          'authCode': authCode,
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

  Future<Response<dynamic>> signUp(Map<String, Object> data) async {
    try {
      final response = await RequestApi.post(
        RestApiUri.signUp,
        data: data,
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

final signupServiceProvider = Provider<SignupService>((ref) => SignupService());
