import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class MyInfoOrderHistoryService {
  final Ref ref;

  MyInfoOrderHistoryService(this.ref);

  Future<Response<dynamic>> getOrderHistory(
      {required String storeId,
      required String page,
      required String filter}) async {
    try {
      Map<String, String> replacements = {
        "{storeId}": storeId,
        "{page}": page,
        "{filter}": filter,
      };

      String apiPath = RestApiUri.getOrderHistory;
      // 치환 작업 수행
      replacements.forEach((key, value) {
        apiPath = apiPath.replaceAll(key, value);
      });

      final response = ref.read(requestApiProvider).get(
            path: apiPath,
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

final myInfoOrderHistoryServiceProvider = Provider<MyInfoOrderHistoryService>(
    (ref) => MyInfoOrderHistoryService(ref));
