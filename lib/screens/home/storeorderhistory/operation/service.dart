import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreOrderHistoryService {
  final Ref ref;

  StoreOrderHistoryService(this.ref);

  Future<Response<dynamic>> getOrderHistoryByFilter(
      {required String storeId,
      required String page,
      required String filter,
      required String startDate,
      required String endDate}) async {
    try {
      Map<String, String> replacements = {
        "{storeId}": storeId,
        "{page}": page,
        "{filter}": filter,
      };

      String apiPath = RestApiUri.getOrderHistoryByFilter;
      // 치환 작업 수행
      replacements.forEach((key, value) {
        apiPath = apiPath.replaceAll(key, value);
      });

      final response = ref.read(requestApiProvider).get(
          path: apiPath,
          queryParameters: {'startDate': startDate, 'endDate': endDate});

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

final storeOrderHistoryServiceProvider =
    Provider<StoreOrderHistoryService>((ref) => StoreOrderHistoryService(ref));
