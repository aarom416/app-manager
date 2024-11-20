import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreManagementBasicInfoService {
  final Ref ref;

  StoreManagementBasicInfoService(this.ref);

  Future<Response<dynamic>> storeInfo({required String storeId}) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.storeInfo.replaceAll('{storeId}', storeId),
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

  Future<Response<dynamic>> storePhone({required String phone}) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.storePhone,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'storePhone': phone,
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

  Future<Response<dynamic>> storeIntroduction({
    required String introduction,
  }) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.storeIntroduction,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'introduction': introduction,
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

  Future<Response<dynamic>> storeOriginInformation({
    required String originInformation,
  }) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.originInformation,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'originURL': originInformation,
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

final storeManagementBasicInfoServiceProvider =
    Provider<StoreManagementBasicInfoService>(
        (ref) => StoreManagementBasicInfoService(ref));
