import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreSettlementService {
  final Ref ref;

  StoreSettlementService(this.ref);

  /// GET - 사업자 정보 페이지의 모든 정보를 조회
  Future<Response<dynamic>> getSettlementInfo(
      {required String storeId,
      required String startDate,
      required String endDate}) async {
    try {
      final response = ref.read(requestApiProvider).get(
          path: RestApiUri.getSettlementInfo.replaceAll('{storeId}', storeId),
          queryParameters: {
            'startDateString': startDate,
            'endDateString': endDate
          });

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> generateSettlementReport(
      {required String storeId,
      required String email,
      required String startDate,
      required String endDate}) {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.generateSettlementReport, data: {
        'storeId': storeId,
        'email': email,
        'searchMonth': null,
        'startDateString': startDate,
        'endDateString': endDate
      });

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

final storeSettlementServiceProvider =
    Provider<StoreSettlementService>((ref) => StoreSettlementService(ref));
