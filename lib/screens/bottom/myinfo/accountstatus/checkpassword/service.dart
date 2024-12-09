import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class MyInfoCheckPasswordService {
  final Ref ref;

  MyInfoCheckPasswordService(this.ref);

  Future<Response<dynamic>> checkPassword({required String password}) async {
    try {
      final response = ref.read(requestApiProvider).get(
          path: RestApiUri.checkPassword,
          queryParameters: {'password': password});

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

final myInfoCheckPasswordServiceProvider = Provider<MyInfoCheckPasswordService>(
    (ref) => MyInfoCheckPasswordService(ref));
