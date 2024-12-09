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

  /// POST - 메뉴 카테고리 이름 및 설명 수정
  /*
      {
        "storeId": 1,
        "storeMenuCategoryId": 11,
        "menuCategoryName": "대표메뉴",
        "menuDescription": "대표메뉴입니다!"
      }
   */
  Future<Response<dynamic>> updateMenuCategoryName({required String storeId, required MenuCategoryModel menuCategoryModel}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuCategoryName,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'storeMenuCategoryId': menuCategoryModel.storeMenuCategoryId,
          'menuCategoryName': menuCategoryModel.menuCategoryName,
          'menuDescription': menuCategoryModel.menuDescription,
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

  /// POST - 메뉴 카테고리 삭제
  /*
      {
        "storeId": 1,
        "menuCategoryId": 1,
        "menuCategoryName": "1인 세트"
      }
   */
  Future<Response<dynamic>> deleteMenuCategory({required String storeId, required MenuCategoryModel menuCategoryModel}) async {
    try {
      return await ref.read(requestApiProvider).delete(
        RestApiUri.deleteMenuCategory,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuCategoryId': menuCategoryModel.storeMenuCategoryId,
          'menuCategoryName': menuCategoryModel.menuCategoryName,
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

  /// POST - 메뉴 추가
  /*
      메뉴를 추가합니다.
      ContentType 은 Multipart/form-data 형식입니다.
      같은 이름과 가격을 갖는 메뉴를 추가할 경우, 메뉴 중복으로 추가할 수 없습니다.
      욕설 및 비하 발언은 기입할 수 없습니다.
      메뉴 사진 파일은 [Optional] 입니다.
      메뉴 사진의 크기는 10MB 까지 전송가능하고 jpg, jpeg, png, gif, bmp, webp 형식만 가능합니다.
      가게 카테고리를 반드시 선택해야 하며, 가게 카테고리가 없을 시 추가하여 선택해야 합니다.
      해당 도메인이 진행 중 종료되면 처음부터 다시 기입해야 됩니다.
   */
  Future<Response<dynamic>> createMenu({
    required String storeId,
    required String menuName,
    required MenuCategoryModel selectedMenuCategory,
    required List<String> selectedUserMenuCategories,
    required int price,
    required Nutrition nutrition,
    required int servingAmount,
    required String servingAmountType,
    required String imagePath,
    required String menuBriefDescription,
    required String menuDescription,
    required String selectedMenuOptionCategories,
  }) async {
    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        'storeMenuCategoryId': selectedMenuCategory.storeMenuCategoryId,
        'menuName': menuName,
        'category': selectedUserMenuCategories.join(),
        'menuPrice': price,
        'servingAmount': servingAmount,
        'servingAmountType': servingAmountType,
        'calories': nutrition.calories,
        'carbohydrate': nutrition.carbohydrate,
        'protein': nutrition.protein,
        'fat': nutrition.fat,
        'sugar': nutrition.sugar,
        'saturatedFat': nutrition.saturatedFat,
        'natrium': nutrition.sugar,
        'menuIntroduction': menuDescription,
        'madeOf': menuBriefDescription,
        'menuOptionCategoryIdList': selectedMenuOptionCategories,
        'menuPicture': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      return await ref.read(requestApiProvider).post(
        RestApiUri.createMenu,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
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
