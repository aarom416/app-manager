import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class MyInfoOperationService {
  final Ref ref;

  MyInfoOperationService(this.ref);

  Future<Response<dynamic>> operationStatus(
      {required String storeId, required int status}) async {
    try {
      final response = ref.read(requestApiProvider).post(
          RestApiUri.operationStatus,
          data: {'storeId': storeId, 'operationStatus': status});

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

final myInfoOperationServiceProvider =
    Provider<MyInfoOperationService>((ref) => MyInfoOperationService(ref));
