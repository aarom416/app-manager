import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreHistoryService {
  final Ref ref;

  StoreHistoryService(this.ref);

  /// GET - 사업자 이력 정보를 조회
  Future<Response<dynamic>> getStoreHistory(
      {required String storeId,
      required String page,
      required String filter}) async {
    try {
      Map<String, String> replacements = {
        "{storeId}": storeId,
        "{page}": page,
        "{filter}": filter,
      };

      String apiPath = RestApiUri.getStoreHistory;
      // 치환 작업 수행
      replacements.forEach((key, value) {
        apiPath = apiPath.replaceAll(key, value);
      });

      final response = ref.read(requestApiProvider).get(
        path: apiPath,
        queryParameters: {
          'startDate': '2024-11-08',
          'endDate': '2024-12-04',
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

final storeHistoryServiceProvider =
    Provider<StoreHistoryService>((ref) => StoreHistoryService(ref));
