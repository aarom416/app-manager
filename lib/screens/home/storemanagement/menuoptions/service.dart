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

  /// DELETE - 메뉴 카테고리 삭제
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
    required String selectedUserMenuCategoryIdsFlatString,
    required int price,
    required NutritionModel nutrition,
    required int servingAmount,
    required String servingAmountType,
    required String imagePath,
    required String menuBriefDescription,
    required String menuDescription,
    required List<MenuOptionCategoryModel> selectedMenuOptionCategories,
  }) async {
    logger.d(
      "storeId: ${storeId}\r\n" +
          "storeMenuCategoryId: ${selectedMenuCategory.storeMenuCategoryId}\r\n" +
          "menuName: ${menuName}\r\n" +
          "category: ${selectedUserMenuCategoryIdsFlatString}\r\n" +
          // "menuPrice: ${price}\r\n" +
          // "servingAmount: ${servingAmount}\r\n" +
          // "servingAmountType: ${servingAmountType}\r\n" +
          // "calories: ${nutrition.calories}\r\n" +
          // "carbohydrate: ${nutrition.carbohydrate}\r\n" +
          // "protein: ${nutrition.protein}\r\n" +
          // "fat: ${nutrition.fat}\r\n" +
          // "sugar: ${nutrition.sugar}\r\n" +
          // "saturatedFat: ${nutrition.saturatedFat}\r\n" +
          // "natrium: ${nutrition.natrium}\r\n" +
          "menuIntroduction: ${menuDescription}\r\n" +
          "madeOf: ${menuBriefDescription}\r\n" +
          "menuOptionCategoryIdList: ${selectedMenuOptionCategories.map((optionCategory) => optionCategory.menuOptionCategoryId).toList()}\r\n" +
          "menuPicture: ${imagePath}\r\n",
    );

    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        'storeMenuCategoryId': selectedMenuCategory.storeMenuCategoryId,
        'menuName': menuName,
        'category': selectedUserMenuCategoryIdsFlatString,
        'menuPrice': price,
        'servingAmount': servingAmount,
        'servingAmountType': servingAmountType,
        'calories': nutrition.calories,
        'carbohydrate': nutrition.carbohydrate,
        'protein': nutrition.protein,
        'fat': nutrition.fat,
        'sugar': nutrition.sugar,
        'saturatedFat': nutrition.saturatedFat,
        'natrium': nutrition.natrium,
        'menuIntroduction': menuDescription,
        'madeOf': menuBriefDescription,
        'menuOptionCategoryIdList': selectedMenuOptionCategories.map((optionCategory) => optionCategory.menuOptionCategoryId).toList(),
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

  /// POST - 메뉴 이름 변경
  Future<Response<dynamic>> updateMenuName({required String storeId, required int menuId, required String menuName}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuName,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'menuName': menuName,
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

  /// POST - 메뉴 가격 변경
  Future<Response<dynamic>> updateMenuPrice({required String storeId, required int menuId, required int price}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuPrice,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'price': price,
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

  /// POST - 메뉴 사진 변경 - 관리자 제한 API
  Future<Response<dynamic>> adminUpdateMenuPicture({
    required String storeId,
    required int menuId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        'menuId': menuId,
        'menuPicture': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      return await ref.read(requestApiProvider).post(
            RestApiUri.adminUpdateMenuPicture,
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

  /// POST - 메뉴 품절 상태 변경
  Future<Response<dynamic>> updateMenuSoldOutStatus({required String storeId, required int menuId, required int soldOutStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuSoldOutStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'menuSoldOutStatus': soldOutStatus,
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

  /// POST - 메뉴 인기 상태 변경
  Future<Response<dynamic>> updateMenuPopularity({required String storeId, required int menuId, required int popularityStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuPopularity,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'menuPopularityStatus': popularityStatus,
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

  /// POST - 메뉴 베스트 상태 변경
  Future<Response<dynamic>> updateMenuBestStatus({required String storeId, required int menuId, required int bestStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuBestStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'menuBestStatus': bestStatus,
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

  /// POST - 메뉴 구성 변경
  Future<Response<dynamic>> updateMenuMadeOf({required String storeId, required int menuId, required String menuParts}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuMadeOf,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'madeOf': menuParts,
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

  /// POST - 메뉴 설명 변경
  Future<Response<dynamic>> updateMenuIntroduction({required String storeId, required int menuId, required String menuDescription}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuIntroduction,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuId,
          'menuIntroduction': menuDescription,
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

  /// DELETE - 메뉴 삭제
  Future<Response<dynamic>> deleteMenu({required String storeId, required MenuModel menuModel}) async {
    try {
      return await ref.read(requestApiProvider).delete(
        RestApiUri.deleteMenu,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuId': menuModel.menuId,
          'menuName': menuModel.menuName,
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

  /// POST - 메뉴 옵션 카테고리 필수 여부 변경
  Future<Response<dynamic>> updateMenuOptionCategoryEssential({required String storeId, required int menuOptionCategoryId, required int essentialStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionCategoryEssential,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionCategoryId': menuOptionCategoryId,
          'essentialStatus': essentialStatus,
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

  /// POST - 메뉴 옵션 카테고리 최대, 최소 개수 변경
  Future<Response<dynamic>> updateMenuOptionCategoryMaxChoice({required String storeId, required int menuOptionCategoryId, required int minChoice, required int maxChoice}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionCategoryMaxChoice,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'minChoice': minChoice,
          'maxChoice': maxChoice,
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

  /// POST - 메뉴 옵션 카테고리 품절 상태 변경
  Future<Response<dynamic>> updateMenuOptionCategorySoldOutStatus({required String storeId, required int menuOptionCategoryId, required int soldOutStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionCategorySoldOutStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionCategoryId': menuOptionCategoryId,
          'menuOptionCategorySoldOutStatus': soldOutStatus,
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

  /// POST - 메뉴 옵션 카테고리 이름 변경
  Future<Response<dynamic>> updateMenuOptionCategoryName({required String storeId, required int menuOptionCategoryId, required String menuOptionCategoryName}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionCategoryName,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionCategoryId': menuOptionCategoryId,
          'menuOptionCategoryName': menuOptionCategoryName,
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

  /// POST - 메뉴 옵션 카테고리 사용 메뉴 변경
  /*
    {
      "storeId": 1,
      "menuOptionCategoryId": 1,
      "addMenuIdList": [
        1,
        2
      ],
      "removeMenuIdList": [
        3,
        4
      ]
    }
   */
  Future<Response<dynamic>> updateMenuOptionCategoryUseMenu({required String storeId, required int menuOptionCategoryId, required List<int> addMenuIdList , required List<int> removeMenuIdList}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionCategoryUseMenu,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'addMenuIdList': addMenuIdList,
          'removeMenuIdList': removeMenuIdList,
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

  /// DELETE - 메뉴 옵션 카테고리 삭제
  Future<Response<dynamic>> deleteMenuOptionCategory({required String storeId, required MenuOptionCategoryModel optionCategoryModel}) async {
    try {
      return await ref.read(requestApiProvider).delete(
        RestApiUri.deleteMenuOptionCategory,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'optionCategoryId': optionCategoryModel.menuOptionCategoryId,
          'optionCategoryName': optionCategoryModel.menuOptionCategoryName,
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

  /// POST - 메뉴 옵션 이름 변경
  Future<Response<dynamic>> updateMenuOptionName({required String storeId, required int menuOptionId, required String optionContent}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionName,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionId': menuOptionId,
          'menuOptionName': optionContent,
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

  /// POST - 메뉴 옵션 가격 변경
  Future<Response<dynamic>> updateMenuOptionPrice({required String storeId, required int menuOptionId, required int price}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionPrice,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionId': menuOptionId,
          'menuOptionPrice': price,
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

  /// POST - 메뉴 옵션 품절 상태 변경
  Future<Response<dynamic>> updateMenuOptionSoldOutStatus({required String storeId, required int menuOptionId, required int soldOutStatus}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionSoldOutStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionId': menuOptionId,
          'menuOptionSoldOutStatus': soldOutStatus,
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

  /// GET - 메뉴 옵션 정보 조회
  Future<Response<dynamic>> getMenuInfo({required int menuOptionId}) async {
    try {
      return ref.read(requestApiProvider).get(path: RestApiUri.getMenuInfo.replaceAll('{menuOptionId}', "$menuOptionId"));
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 메뉴 옵션 정보 변경
  Future<Response<dynamic>> updateMenuOptionInfo({required String storeId, required int menuOptionId, required NutritionModel nutrition}) async {
    try {
      return await ref.read(requestApiProvider).post(
        RestApiUri.updateMenuOptionSoldOutStatus,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'menuOptionId': menuOptionId,
          'servingAmount': nutrition.servingAmount,
          'servingAmountType': nutrition.servingAmountType,
          'calories': nutrition.calories,
          'carbohydrate': nutrition.carbohydrate,
          'protein': nutrition.protein,
          'fat': nutrition.fat,
          'sugar': nutrition.sugar,
          'saturatedFat': nutrition.saturatedFat,
          'natrium': nutrition.natrium,
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

  /// DELETE - 메뉴 옵션 삭제
  Future<Response<dynamic>> deleteMenuOption({required String storeId, required MenuOptionModel menuOptionModel}) async {
    try {
      return await ref.read(requestApiProvider).delete(
        RestApiUri.deleteMenuOption,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'optionId': menuOptionModel.menuOptionId,
          'optionName': menuOptionModel.optionContent,
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
