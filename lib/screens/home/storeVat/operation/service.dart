import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreVatService {
  final Ref ref;

  StoreVatService(this.ref);

  /// GET - 사업자 매출 부가세 정보를 조회
  Future<Response<dynamic>> getVatSalesInfo({
    required String storeId,
    required Map<String, String> queryParameters,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getVatSalesInfo.replaceAll('{storeId}', storeId),
            data: {
              'storeId': UserHive.getBox(key: UserKey.storeId),
            },
            queryParameters: queryParameters,
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

  /// GET - 사업자 매출 부가세 정보를 조회
  Future<Response<dynamic>> getVatPurchasesInfo({
    required String storeId,
    required Map<String, String> queryParameters,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path:
                RestApiUri.getVatPurchasesInfo.replaceAll('{storeId}', storeId),
            data: {
              'storeId': UserHive.getBox(key: UserKey.storeId),
            },
            queryParameters: queryParameters,
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

  Future<Response<dynamic>> generateVatReport({
    required Object data,
  }) {
    try {
      final response = ref.read(requestApiProvider).post(
            RestApiUri.generateVatReport,
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

final storeVatServiceProvider =
    Provider<StoreVatService>((ref) => StoreVatService(ref));
