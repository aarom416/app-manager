import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class NotificationConfigurationService {
  final Ref ref;

  NotificationConfigurationService(this.ref);

  Future<Response<dynamic>> notificationStatus(
      {required String storeId, required String fcmTokenId}) async {
    try {
      final response = ref.read(requestApiProvider).get(
          path: RestApiUri.notificationStatus,
          queryParameters: {"storeId": storeId, "ownerFCMTokenId": fcmTokenId});

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> orderNotificationStatus(
      {required int orderNotificationStatus,
      required String fcmTokenId}) async {
    try {
      final response = ref
          .read(requestApiProvider)
          .post(RestApiUri.orderNotificationStatus, queryParameters: {
        "orderNotificationStatus": orderNotificationStatus,
        "ownerFCMTokenId": fcmTokenId
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

final notificationConfigurationServiceProvider =
    Provider<NotificationConfigurationService>(
        (ref) => NotificationConfigurationService(ref));
