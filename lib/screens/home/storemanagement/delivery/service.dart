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
}

final deliveryServiceProvider = Provider<DeliveryService>((ref) => DeliveryService(ref));
