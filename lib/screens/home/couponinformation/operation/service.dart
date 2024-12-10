import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/main.dart';

class CouponInformationService {
  final Ref ref;

  CouponInformationService(this.ref);

  /// GET - 쿠폰 정보를 조회
  Future<Response<dynamic>> getCouponInformation({
    required String storeId,
    required String page,
    required Map<String, String> queryParameters,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getCouponInfo
                .replaceAll('{storeId}', storeId)
                .replaceAll('{page}', page),
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

  /// DELETE - 쿠폰 정보를 삭제
  Future<Response<dynamic>> deleteIssuedCoupon({
    required String couponId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).delete(
            RestApiUri.deleteIssuedCoupon.replaceAll('{couponId}', couponId),
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

final couponInformationServiceProvider =
    Provider<CouponInformationService>((ref) => CouponInformationService(ref));
