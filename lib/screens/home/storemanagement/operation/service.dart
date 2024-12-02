import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

import 'model.dart';

class StoreOperationService {
  final Ref ref;

  StoreOperationService(this.ref);

  /// GET - 영업 정보 조회
  Future<Response<dynamic>> getOperationInfo({required String storeId}) async {
    try {
      return ref.read(requestApiProvider).get(path: RestApiUri.getOperationInfo.replaceAll('{storeId}', storeId));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 배달 상태 수정
  Future<Response<dynamic>> updateDeliveryStatus({required String storeId, required int deliveryStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateDeliveryStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'deliveryStatus': deliveryStatus,
        },
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 포장 상태 수정
  Future<Response<dynamic>> updatePickupStatus({required String storeId, required int pickUpStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updatePickupStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'pickUpStatus': pickUpStatus,
        },
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 가게 영업 시간 변경
  Future<Response<dynamic>> updateOperationTime({required String storeId, required List<OperationTimeDetailModel> operationTimeDetails}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateOperationTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'dayList': operationTimeDetails.asMap().entries.map((entry) {
            return entry.key;
          }).toList(),
          'startTimeList': operationTimeDetails.map((operationTimeDetail) {
            return operationTimeDetail.startTime;
          }).toList(),
          'endTimeList': operationTimeDetails.map((operationTimeDetail) {
            return operationTimeDetail.endTime;
          }).toList()
        },
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 가게 휴게 시간 변경
  Future<Response<dynamic>> updateBreakTime({required String storeId, required List<OperationTimeDetailModel> breakTimeDetails}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateBreakTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'dayList': breakTimeDetails.asMap().entries.map((entry) {
            return entry.key;
          }).toList(),
          'startTimeList': breakTimeDetails.map((operationTimeDetail) {
            return operationTimeDetail.startTime;
          }).toList(),
          'endTimeList': breakTimeDetails.map((operationTimeDetail) {
            return operationTimeDetail.endTime;
          }).toList()
        },
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

final storeOperationServiceProvider = Provider<StoreOperationService>((ref) => StoreOperationService(ref));
