import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

import '../../../../core/hives/user_hive.dart';
import 'model.dart';

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

  /// POST - 메뉴 카테고리 추가
  /*
    {
      "storeId": 1,
      "menuCategoryName": "1인 샐러드 세트",
      "description": "1인 샐러드 세트 입니다.",
      "menuIdList": [
        1,
        2
      ]
    }
   */
  Future<Response<dynamic>> createMenuCategory({required String storeId, required MenuCategoryModel newMenuCategoryModel}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.createMenuCategory,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuCategoryName': newMenuCategoryModel.menuCategoryName,
          'description': newMenuCategoryModel.menuDescription,
          'menuIdList': newMenuCategoryModel.menuList.map((menu) => menu.menuId).toList(),
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

final menuOptionsServiceProvider = Provider<MenuOptionsService>((ref) => MenuOptionsService(ref));
