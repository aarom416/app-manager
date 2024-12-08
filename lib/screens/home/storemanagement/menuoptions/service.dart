import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class MenuOptionsService {
  final Ref ref;

  MenuOptionsService(this.ref);

  /// GET - 메뉴/옵션 정보 조회
  Future<Response<dynamic>> getMenuOptionInfo({required String storeId}) async {
    try {
      return ref.read(requestApiProvider).get(path: RestApiUri.getMenuOptionInfo.replaceAll('{storeId}', storeId));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }


}

final menuOptionsServiceProvider = Provider<MenuOptionsService>((ref) => MenuOptionsService(ref));
