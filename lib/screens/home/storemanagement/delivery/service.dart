import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

import 'model.dart';

class DeliveryService {
  final Ref ref;

  DeliveryService(this.ref);

  /// GET - 배달/포장 정보 조회
  Future<Response<dynamic>> getDeliveryTakeoutInfo(
      {required String storeId}) async {
    try {
      return ref.read(requestApiProvider).get(
          path: RestApiUri.getDeliveryTakeoutInfo
              .replaceAll('{storeId}', storeId));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 배달 예상 시간 수정
  Future<Response<dynamic>> updateDeliveryTime(
      {required String storeId,
      required int minDeliveryTime,
      required int maxDeliveryTime}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateDeliveryTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'minTime': minDeliveryTime,
          'maxTime': maxDeliveryTime
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

  /// POST - 포장 예상 시간 수정
  Future<Response<dynamic>> updatePickupTime(
      {required String storeId,
      required int minTakeOutTime,
      required int maxTakeOutTime}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updatePickupTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'minTime': minTakeOutTime,
          'maxTime': maxTakeOutTime
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

  /// POST - 가게 배달팁 변경
  /*
      가게 배달팁을 변경합니다.
      현재 최대 가격 금액이 다음 설정하려는 최소 주문 금액과 같아야 합니다. 예를 들어 '8000원 이상 10000원 이하' -> '10000원 이상 30000원 이하'
      '8000원 이상' 인 경우 최소 가격은 8000원, 최대 가격은 null 입니다.
      배달팁 내용, 최소 가격, 최대 가겨, 배달 팁 리스트의 크기는 모두 같고 인덱스 순으로 같은 배달팁입니다.
      배달팁 변경 페이지에 존재하는 배달팁에 대한 정보를 전송해야 합니다. (기존에 설정되어 있는 배달팁 포함)

      {
        "storeId": 1,
        "contentList": "[8,000원 이상, 8,000원 이상 19,000원 미만]",
        "minPriceList": [
          8000,
          8000
        ],
        "maxPriceList": [
          null,
          19000
        ],
        "deliveryTipList": [
          3900,
          2000
        ]
      }
   */
  Future<Response<dynamic>> updateDeliveryTip(
      {required String storeId,
      required int baseDeliveryTip,
      required int minimumOrderPrice,
      required List<DeliveryTipModel> storeDeliveryTipDTOList}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updatePickupTime,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'contentList': storeDeliveryTipDTOList.map((deliveryTipModel) {
            return deliveryTipModel.maxPrice == 0
                ? "${deliveryTipModel.minPrice.toKoreanCurrency}원 이상"
                : "${deliveryTipModel.minPrice.toKoreanCurrency}원 이상 ${deliveryTipModel.maxPrice.toKoreanCurrency}원 미만";
          }).toList(),
          'minPriceList': storeDeliveryTipDTOList.map((deliveryTipModel) {
            return deliveryTipModel.minPrice;
          }).toList(),
          'maxPriceList': storeDeliveryTipDTOList.map((deliveryTipModel) {
            return deliveryTipModel.maxPrice;
          }).toList(),
          'deliveryTipList': storeDeliveryTipDTOList.map((deliveryTipModel) {
            return deliveryTipModel.deliveryTip;
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

final deliveryServiceProvider =
    Provider<DeliveryService>((ref) => DeliveryService(ref));
