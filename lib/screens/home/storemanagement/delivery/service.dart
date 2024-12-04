import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

import 'model.dart';

class DeliveryService {
  final Ref ref;

  DeliveryService(this.ref);

  /// GET - 배달/포장 정보 조회
  Future<Response<dynamic>> getDeliveryTakeoutInfo({required String storeId}) async {
    try {
      return ref.read(requestApiProvider).get(path: RestApiUri.getDeliveryTakeoutInfo.replaceAll('{storeId}', storeId));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 배달 예상 시간 수정
  Future<Response<dynamic>> updateDeliveryTime({required String storeId, required int minDeliveryTime, required int maxDeliveryTime}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateOperationTime,
        data: {'storeId': UserHive.getBox(key: UserKey.storeId), 'minTime': minDeliveryTime, 'maxTime': maxDeliveryTime},
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 포장 예상 시간 수정
  Future<Response<dynamic>> updatePickupTime({required String storeId, required int minTakeOutTime, required int maxTakeOutTime}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updatePickupTime,
        data: {'storeId': UserHive.getBox(key: UserKey.storeId), 'minTime': minTakeOutTime, 'maxTime': maxTakeOutTime},
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }
}

final deliveryServiceProvider = Provider<DeliveryService>((ref) => DeliveryService(ref));
