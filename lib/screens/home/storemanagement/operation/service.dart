import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

import 'model.dart';

class OperationService {
  final Ref ref;

  OperationService(this.ref);

  /// GET - 영업 정보 조회
  Future<Response<dynamic>> getOperationInfo({required String storeId}) async {
    try {
      return ref.read(requestApiProvider).get(
          path: RestApiUri.getOperationInfo.replaceAll('{storeId}', storeId));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 배달 상태 수정
  Future<Response<dynamic>> updateDeliveryStatus(
      {required String storeId, required int deliveryStatus}) async {
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
  Future<Response<dynamic>> updatePickupStatus(
      {required String storeId, required int pickUpStatus}) async {
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
  Future<Response<dynamic>> updateOperationTime(
      {required String storeId,
      required List<OperationTimeDetailModel> operationTimeDetails}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateOperationTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'dayList': operationTimeDetails.asMap().entries.map((entry) {
            if (entry.value.day == '일') {
              return 0;
            } else {
              return entry.key + 1;
            }
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
  Future<Response<dynamic>> updateBreakTime(
      {required String storeId,
      required List<OperationTimeDetailModel> breakTimeDetails}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateBreakTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'dayList': breakTimeDetails
              .asMap()
              .entries
              .where((breakTime) => breakTime.value.toggle)
              .map((entry) {
            if (entry.value.day == '일') {
              return 0;
            } else {
              return entry.key + 1;
            }
          }).toList(),
          'startTimeList': breakTimeDetails
              .where((breakTime) => breakTime.toggle)
              .map((operationTimeDetail) {
            return operationTimeDetail.startTime;
          }).toList(),
          'endTimeList': breakTimeDetails
              .where((breakTime) => breakTime.toggle)
              .map((operationTimeDetail) {
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

  /// POST - 가게 휴무일 변경
  Future<Response<dynamic>> updateHolidayDetail({
    required String storeId,
    required int holidayStatus,
    required List<OperationTimeDetailModel> regularHolidays,
    required List<OperationTimeDetailModel> temporaryHolidays,
  }) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateHolidayDetail,
        /*
          {
            "storeId": 1,
            "holidayStatus": 1,
            "cycleList": [
              1,
              7,
              3
            ],
            "dayList": [
              0,
              1,
              2
            ],
            "startDateList": "[2024-01-01, 2024-02-01]",
            "endDateList": "[2024-01-07, 2024-02-07]",
            "mentList": "['', 가게 사정으로 휴업합니다.]"
          }
       */
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'holidayStatus': holidayStatus,
          'cycleList': regularHolidays.map((operationTimeDetail) {
            return operationTimeDetail.cycle;
          }).toList(),
          'dayList': regularHolidays.map((operationTimeDetail) {
            return ['일', '월', '화', '수', '목', '금', '토']
                .indexOf(operationTimeDetail.day);
          }).toList(),
          'startDateList': temporaryHolidays.map((operationTimeDetail) {
            return operationTimeDetail.startDate;
          }).toList(),
          'endDateList': temporaryHolidays.map((operationTimeDetail) {
            return operationTimeDetail.endDate;
          }).toList(),
          'mentList': temporaryHolidays.map((operationTimeDetail) {
            return operationTimeDetail.ment;
          }).toList(),
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

final operationServiceProvider =
    Provider<OperationService>((ref) => OperationService(ref));
