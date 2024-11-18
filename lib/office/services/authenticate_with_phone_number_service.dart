import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class AuthenticateWithPhoneNumberService {
  final Ref ref;

  AuthenticateWithPhoneNumberService(this.ref);

  Future<Response<dynamic>> identityVerification({
    required String loginId,
    required String method,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
        path: RestApiUri.identityVerification,
        queryParameters: {
          'loginId': loginId,
          'method': method,
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

final authenticateWithPhoneNumberServiceProvider =
    Provider<AuthenticateWithPhoneNumberService>(
        (ref) => AuthenticateWithPhoneNumberService(ref));
