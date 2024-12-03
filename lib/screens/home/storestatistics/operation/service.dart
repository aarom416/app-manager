import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreStatisticsService {
  final Ref ref;

  StoreStatisticsService(this.ref);

  /// GET - 사업자 정보 페이지의 모든 정보를 조회
  Future<Response<dynamic>> loadStatisticsByStoreId(
      {required String storeId}) async {
    try {
      final response = ref.read(requestApiProvider).get(
        path:
            RestApiUri.loadStatisticsByStoreId.replaceAll('{storeId}', storeId),
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
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

final storeStatisticsServiceProvider =
    Provider<StoreStatisticsService>((ref) => StoreStatisticsService(ref));
