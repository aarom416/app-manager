import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreRegistrationFormService {
  final Ref ref;

  StoreRegistrationFormService(this.ref);

  Future<Response<dynamic>> checkBusinessNumber(String businessNumber) async {
    try {
      final response = ref.read(requestApiProvider).post(
            RestApiUri.checkBusinessNumber
                .replaceAll('{businessRegistrationNumber}', businessNumber),
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

  Future<Response<dynamic>> enroll({required FormData formData}) async {
    try {
      final response = ref.read(requestApiProvider).post(
            RestApiUri.enroll,
            data: formData,
            contentType: RestApiUri.multipartFormData,
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

final storeRegistrationFormServiceProvider =
    Provider<StoreRegistrationFormService>(
        (ref) => StoreRegistrationFormService(ref));
