import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class OrderService {
  final Ref ref;

  OrderService(this.ref);

  Future<Response<dynamic>> getNewOrderList({
    required String storeId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getNewOrderList.replaceAll('{storeId}', storeId),
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

  Future<Response<dynamic>> getNewOrderDetail({
    required int orderInformationId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getNewOrderDetail.replaceAll(
                '{orderInformationId}', orderInformationId.toString()),
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

  Future<Response<dynamic>> getAcceptedOrderList({
    required String storeId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getAcceptedOrderList
                .replaceAll('{storeId}', storeId),
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

  Future<Response<dynamic>> getAcceptedOrderDetail({
    required int orderInformationId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getAcceptedOrderDetail.replaceAll(
                '{orderInformationId}', orderInformationId.toString()),
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

  Future<Response<dynamic>> getCompletedOrderList({
    required String storeId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getCompletedOrderList
                .replaceAll('{storeId}', storeId),
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

  Future<Response<dynamic>> getCompletedOrderDetail({
    required int orderInformationId,
  }) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.getCompletedOrderDetail.replaceAll(
                '{orderInformationId}', orderInformationId.toString()),
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

  /// 주문 접수
  Future<Response<dynamic>> acceptOrder(
      {required int orderInformationId,
      required int storeId,
      required int cookTime}) async {
    try {
      final response =
          ref.read(requestApiProvider).post(RestApiUri.acceptOrder, data: {
        'orderInformationId': orderInformationId,
        'storeId': storeId,
        'cookTime': cookTime
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

  /// 포장 주문 취소
  Future<Response<dynamic>> takeoutOrderCancel(
      {required int orderInformationId, required int cancelReason}) async {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.cancelTakeoutOrder, data: {
        'orderInformationId': orderInformationId,
        'cancelReason': cancelReason,
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

  /// 배달 주문 취소
  Future<Response<dynamic>> deliveryOrderCancel(
      {required int orderInformationId, required int cancelReason}) async {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.cancelDeliveryOrder, data: {
        'orderInformationId': orderInformationId,
        'cancelReason': cancelReason,
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

  /// 포장 주문 거절
  Future<Response<dynamic>> takeoutOrderReject(
      {required int orderInformationId, required int rejectReason}) async {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.rejectTakeoutOrder, data: {
        'orderInformationId': orderInformationId,
        'rejectReason': rejectReason
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

  /// 배달 주문 거절
  Future<Response<dynamic>> deliveryOrderReject(
      {required int orderInformationId, required int rejectReason}) async {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.rejectDeliveryOrder, data: {
        'orderInformationId': orderInformationId,
        'rejectReason': rejectReason
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

  /// 배달 완료 알림 보내기
  Future<Response<dynamic>> notifyDeliveryComplete(
      {required int orderInformationId}) async {
    try {
      final response = ref.read(requestApiProvider).post(RestApiUri
          .notifyDeliveryComplete
          .replaceAll('{orderInformationId}', orderInformationId.toString()));

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// 준비 완료 알림 보내기
  Future<Response<dynamic>> notifyCookingComplete(
      {required int orderInformationId}) async {
    try {
      final response = ref.read(requestApiProvider).post(
            RestApiUri.notifyCookingComplete.replaceAll(
                '{orderInformationId}', orderInformationId.toString()),
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

final orderServiceProvider = Provider<OrderService>((ref) => OrderService(ref));
