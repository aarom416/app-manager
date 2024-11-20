import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}

final storeManagementBasicInfoServiceProvider =
    Provider<StoreManagementBasicInfoService>(
        (ref) => StoreManagementBasicInfoService(ref));
