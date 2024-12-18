import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/components/loading.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/providers/bad_word_provider.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/service.dart';

import '../../../../main.dart';
import '../../../common/emuns.dart';
import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

/// network provider
@Riverpod(keepAlive: true)
class MenuOptionsNotifier extends _$MenuOptionsNotifier {
  @override
  MenuOptionsState build() {
    return const MenuOptionsState();
  }

  /// GET - 메뉴/옵션 정보 조회
  void getMenuOptionInfo() async {
    final response = await ref.read(menuOptionsServiceProvider).getMenuOptionInfo(storeId: UserHive.getBox(key: UserKey.storeId));
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final menuOptionsDataModel = MenuOptionsDataModel.fromJson(result.data);
      setState(menuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(dataRetrieveStatus: DataRetrieveStatus.error, error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void setState(MenuOptionsDataModel menuOptionsDataModel) {
    final storeMenuCategoryDTOList = List<MenuCategoryModel>.from(menuOptionsDataModel.storeMenuCategoryDTOList)..sort((a, b) => a.menuCategoryName.compareTo(b.menuCategoryName));
    final storeMenuDTOList = List<MenuModel>.from(menuOptionsDataModel.storeMenuDTOList)..sort((a, b) => a.menuName.compareTo(b.menuName));
    state = state.copyWith(
      dataRetrieveStatus: DataRetrieveStatus.success,
      menuOptionsDataModel: menuOptionsDataModel,
      // 조합된 데이타
      menuCategoryList: createMenuCategoryModels(
          storeMenuCategoryDTOList: storeMenuCategoryDTOList,
          storeMenuDTOList: storeMenuDTOList,
          menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList,
          storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
          menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList),
      // 조회 원본
      storeMenuCategoryDTOList: storeMenuCategoryDTOList,
      // 조회 원본
      storeMenuDTOList: storeMenuDTOList,
      // 조합된 데이타
      menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList.map((menuOptionCategory) {
        List<MenuOptionModel> matchingMenuOptionOptions = menuOptionsDataModel.storeMenuOptionDTOList.where((option) => option.menuOptionCategoryId == menuOptionCategory.menuOptionCategoryId).toList();
        return menuOptionCategory.copyWith(menuOptions: matchingMenuOptionOptions);
      }).toList(),
      // 조회 원본
      storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
      // 조회 원본
      menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList,
    );
  }

  /// api 데이타 구조화.
  /*
      menuOptionCategoryDTOList 의 각 MenuOptionCategoryModel 에서 menuOptions 는
      storeMenuOptionDTOList 에서 각 MenuOptionModel.menuOptionCategoryId 가 MenuOptionCategoryModel 의 menuOptionCategoryId 와 동일한 것들로 묶어서 데이타를 구성.

      storeMenuDTOList 의 각 MenuModel 에서 menuCategoryOptions 는
      MenuModel.menuId 가 menuOptionRelationshipDTOList 중에서 MenuOptionRelationshipModel.menuId 와 동일한 것의 menuOptionCategoryId 에 해당하는
      menuOptionCategoryDTOList 상 데이타를 묶어서 데이타를 구성.

      storeMenuCategoryDTOList 의 각 MenuCategoryModel 에서 menuList 는
      storeMenuDTOList 에서 각 MenuModel.storeMenuCategoryId 가 MenuCategoryModel 의 storeMenuCategoryId 와 동일한 것들로 묶어서 데이타를 구성.
   */
  List<MenuCategoryModel> createMenuCategoryModels({
    required List<MenuCategoryModel> storeMenuCategoryDTOList,
    required List<MenuModel> storeMenuDTOList,
    required List<MenuOptionCategoryModel> menuOptionCategoryDTOList,
    required List<MenuOptionModel> storeMenuOptionDTOList,
    required List<MenuOptionRelationshipModel> menuOptionRelationshipDTOList,
  }) {
    // Step 1: Map storeMenuOptionDTOList to MenuOptionCategoryModel
    final menuOptionCategoryMap = menuOptionCategoryDTOList.map((category) {
      final menuOptions = storeMenuOptionDTOList.where((option) => option.menuOptionCategoryId == category.menuOptionCategoryId).toList();
      return category.copyWith(menuOptions: menuOptions);
    }).toList();

    // Step 2: Map menuOptionRelationshipDTOList to MenuModel
    final menuModelMap = storeMenuDTOList.map((menu) {
      final relatedOptionCategories = menuOptionRelationshipDTOList
          .where((relationship) => relationship.menuId == menu.menuId)
          .map((relationship) => menuOptionCategoryMap.firstWhereOrNull(
            (category) =>
        category.menuOptionCategoryId ==
            relationship.menuOptionCategoryId,
      ))
          .where((category) => category != null) // null 값 제거
          .cast<MenuOptionCategoryModel>() // null-safe 타입으로 캐스팅
          .toList();
      return menu.copyWith(menuCategoryOptions: relatedOptionCategories);
    }).toList();

    // Step 3: Map storeMenuCategoryDTOList to MenuCategoryModel
    final menuCategoryModels = storeMenuCategoryDTOList.map((category) {
      final relatedMenus = menuModelMap.where((menu) => menu.storeMenuCategoryId == category.storeMenuCategoryId).toList();
      return category.copyWith(menuList: relatedMenus);
    }).toList();

    return menuCategoryModels;
  }

  /// POST - 메뉴 카테고리 추가
  Future<ResultFailResponseModel?> createMenuCategory(MenuCategoryModel newMenuCategoryModel) async {
    final response = await ref.read(menuOptionsServiceProvider).createMenuCategory(storeId: UserHive.getBox(key: UserKey.storeId), newMenuCategoryModel: newMenuCategoryModel);
    if (response.statusCode == 200) {
      // MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: [...state.menuOptionsDataModel.storeMenuCategoryDTOList, newMenuCategoryModel]);
      // setState(updatedMenuOptionsDataModel);
      // state = state.copyWith(error: const ResultFailResponseModel());
      getMenuOptionInfo();
      return null;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return state.error;
    }
  }


  /// POST - 옵션 추가
  Future<ResultFailResponseModel?> createOption(BuildContext context, MenuOptionModel newMenuOptionModel) async {
    try {
      Loading.show(context);
      final response = await ref.read(menuOptionsServiceProvider).createOption(storeId: UserHive.getBox(key: UserKey.storeId), newMenuOptionModel: newMenuOptionModel);
      if (response.statusCode == 200) {
        // MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: [...state.menuOptionsDataModel.storeMenuCategoryDTOList, newMenuCategoryModel]);
        // setState(updatedMenuOptionsDataModel);
        // state = state.copyWith(error: const ResultFailResponseModel());
        getMenuOptionInfo();
        return null;
      } else {
        state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
        return state.error;
      }
    } catch (e) {

    } finally {
      Loading.hide();
    }

  }

  /// POST - 메뉴 카테고리 이름 및 설명 수정
  void updateMenuCategoryName(MenuCategoryModel menuCategoryModel) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuCategoryName(storeId: UserHive.getBox(key: UserKey.storeId), menuCategoryModel: menuCategoryModel);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuCategoryDTOList: state.menuOptionsDataModel.storeMenuCategoryDTOList.map((menuCategory) {
            return menuCategory.storeMenuCategoryId == menuCategoryModel.storeMenuCategoryId ? menuCategoryModel : menuCategory;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// DELETE - 메뉴 카테고리 삭제
  void deleteMenuCategory(BuildContext context, MenuCategoryModel menuCategoryModel) async {
    try {
      Loading.show(context);
      final response = await ref.read(menuOptionsServiceProvider).deleteMenuCategory(storeId: UserHive.getBox(key: UserKey.storeId), menuCategoryModel: menuCategoryModel);
      if (response.statusCode == 200) {
        MenuOptionsDataModel updatedMenuOptionsDataModel =
        state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: state.menuOptionsDataModel.storeMenuCategoryDTOList.where((menuCategory) => menuCategory.storeMenuCategoryId != menuCategoryModel.storeMenuCategoryId).toList());
        setState(updatedMenuOptionsDataModel);
        state = state.copyWith(error: const ResultFailResponseModel());
      } else {
        state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      }
    } catch (e) {
    } finally {
      Loading.hide();
    }
  }

  /// POST - 메뉴 추가
  Future<ResultFailResponseModel> createMenu(
      BuildContext context,
      String menuName,
      MenuCategoryModel selectedMenuCategory,
      String selectedUserMenuCategoryIdsFlatString,
      int price,
      NutritionModel nutrition,
      String? imagePath, // Optional
      String? menuBriefDescription, // Optional
      String? menuIntroduction, // Optional
      List<MenuOptionCategoryModel>? selectedMenuOptionCategories, // Optional
      ) async {
    try {
      Loading.show(context);
      final response = await ref.read(menuOptionsServiceProvider).createMenu(
        storeId: UserHive.getBox(key: UserKey.storeId),
        menuName: menuName,
        selectedMenuCategory: selectedMenuCategory,
        selectedUserMenuCategoryIdsFlatString: selectedUserMenuCategoryIdsFlatString,
        price: price,
        nutrition: nutrition,
        servingAmount: nutrition.servingAmount,
        servingAmountType: nutrition.servingAmountType,
        imagePath: imagePath,
        menuBriefDescription: menuBriefDescription,
        menuIntroduction: menuIntroduction,
        selectedMenuOptionCategories: selectedMenuOptionCategories,
      );
      if (response.statusCode == 200) {
        return const ResultFailResponseModel(); // Success
      } else {
        return ResultFailResponseModel.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      return ResultFailResponseModel(
        success: false,
      );
    } finally {
      Loading.hide();
    }
  }


  /// GET - 메뉴 정보 조회
  /*
    {
      "success": true,
      "message": "메뉴 정보 조회 성공",
      "data": {
        "madeOf": "연어 500g+곡물밥 300g",
        "menuIntroduction": "1",
        "servingAmount": 100,
        "servingAmountType": "g",
        "calories": 100,
        "carbohydrate": 0,
        "protein": 0,
        "fat": 0,
        "sugar": 0,
        "saturatedFat": 0,
        "natrium": 0
      }
    }
   */
  void getMenu(int menuId) async {
    final response = await ref.read(menuOptionsServiceProvider).getMenu(menuId: menuId);
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final getMenuDataModel = GetMenuDataModel.fromJson(result.data);
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId
                ? menu.copyWith(
              madeOf: getMenuDataModel.madeOf,
              menuIntroduction: getMenuDataModel.menuIntroduction,
              nutrition: NutritionModel(
                servingAmount: getMenuDataModel.servingAmount,
                servingAmountType: getMenuDataModel.servingAmountType,
                calories: getMenuDataModel.calories,
                carbohydrate: getMenuDataModel.carbohydrate,
                protein: getMenuDataModel.protein,
                fat: getMenuDataModel.fat,
                sugar: getMenuDataModel.sugar,
                saturatedFat: getMenuDataModel.saturatedFat,
                natrium: getMenuDataModel.natrium,
              ),
            )
                : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 메뉴 이름 변경
  Future<bool> updateMenuName(int menuId, String menuName) async {
    if (ref.read(badWordNotifierProvider).hasBadWord) return false;

    final response = await ref.read(menuOptionsServiceProvider).updateMenuName(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, menuName: menuName);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(menuName: menuName) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 가격 변경
  Future<bool> updateMenuPrice(int menuId, int price) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuPrice(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, price: price);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(price: price) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 사진 변경 - 관리자 제한 API
  void adminUpdateMenuPicture(int menuId, String imagePath) async {
    final response = await ref.read(menuOptionsServiceProvider).adminUpdateMenuPicture(
      storeId: UserHive.getBox(key: UserKey.storeId),
      menuId: menuId,
      imagePath: imagePath,
    );
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 메뉴 품절 상태 변경
  Future<bool> updateMenuSoldOutStatus(int menuId, int soldOutStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuSoldOutStatus(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, soldOutStatus: soldOutStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(soldOutStatus: soldOutStatus) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 인기 상태 변경
  Future<bool> updateMenuPopularity(int menuId, int popularityStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuPopularity(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, popularityStatus: popularityStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(popularityStatus: popularityStatus) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 베스트 상태 변경
  Future<bool> updateMenuBestStatus(int menuId, int bestStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuBestStatus(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, bestStatus: bestStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(bestStatus: bestStatus) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 구성 변경
  Future<bool> updateMenuMadeOf(int menuId, String madeOf) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuMadeOf(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, madeOf: madeOf);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(madeOf: madeOf) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 설명 변경
  Future<bool> updateMenuIntroduction(int menuId, String menuIntroduction) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuIntroduction(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, menuIntroduction: menuIntroduction);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(menuIntroduction: menuIntroduction) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 정보 변경
  Future<bool> updateMenuInfo(int menuId, NutritionModel nutrition) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuInfo(
      storeId: UserHive.getBox(key: UserKey.storeId),
      menuId: menuId,
      nutrition: nutrition,
    );
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(nutrition: nutrition) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// DELETE - 메뉴 삭제
  Future<ResultFailResponseModel> deleteMenu(MenuModel menuModel) async {
    final response = await ref.read(menuOptionsServiceProvider).deleteMenu(storeId: UserHive.getBox(key: UserKey.storeId), menuModel: menuModel);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.where((menu) => menu.menuId != menuModel.menuId).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return const ResultFailResponseModel();
    } else {
      return ResultFailResponseModel.fromJson(response.data as Map<String, dynamic>);
    }
  }

  /// POST - 메뉴 옵션 카테고리 필수 여부 변경
  Future<bool> updateMenuOptionCategoryEssential(int menuOptionCategoryId, int essentialStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionCategoryEssential(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionCategoryId: menuOptionCategoryId, essentialStatus: essentialStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          menuOptionCategoryDTOList: state.menuOptionsDataModel.menuOptionCategoryDTOList.map((optionCategory) {
            return optionCategory.menuOptionCategoryId == menuOptionCategoryId ? optionCategory.copyWith(essentialStatus: essentialStatus) : optionCategory;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 카테고리 최대, 최소 개수 변경
  Future<bool> updateMenuOptionCategoryMaxChoice(int menuOptionCategoryId, int minChoice, int maxChoice) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionCategoryMaxChoice(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionCategoryId: menuOptionCategoryId, minChoice: minChoice, maxChoice: maxChoice);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          menuOptionCategoryDTOList: state.menuOptionsDataModel.menuOptionCategoryDTOList.map((optionCategory) {
            return optionCategory.menuOptionCategoryId == menuOptionCategoryId ? optionCategory.copyWith(minChoice: minChoice, maxChoice: maxChoice) : optionCategory;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 카테고리 품절 상태 변경
  Future<bool> updateMenuOptionCategorySoldOutStatus(int menuOptionCategoryId, int soldOutStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionCategorySoldOutStatus(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionCategoryId: menuOptionCategoryId, soldOutStatus: soldOutStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuOptionDTOList: state.menuOptionsDataModel.storeMenuOptionDTOList.map((option) {
            return option.menuOptionCategoryId == menuOptionCategoryId ? option.copyWith(soldOutStatus: soldOutStatus) : option;
          }).toList());
      // logger.i("updateMenuOptionCategorySoldOutStatus updatedMenuOptionsDataModel ${updatedMenuOptionsDataModel.toFormattedJson()}");
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 카테고리 이름 변경
  Future<bool> updateMenuOptionCategoryName(int menuOptionCategoryId, String menuOptionCategoryName) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionCategoryName(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionCategoryId: menuOptionCategoryId, menuOptionCategoryName: menuOptionCategoryName);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          menuOptionCategoryDTOList: state.menuOptionsDataModel.menuOptionCategoryDTOList.map((optionCategory) {
            return optionCategory.menuOptionCategoryId == menuOptionCategoryId ? optionCategory.copyWith(menuOptionCategoryName: menuOptionCategoryName) : optionCategory;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 카테고리 사용 메뉴 변경
  Future<bool> updateMenuOptionCategoryUseMenu(int menuOptionCategoryId, List<MenuModel> oldAppliedMenus, List<MenuModel> newAppliedMenus) async {
    Set<int> oldIds = oldAppliedMenus.map((menu) => menu.menuId).toSet();
    Set<int> newIds = newAppliedMenus.map((menu) => menu.menuId).toSet();
    List<int> addMenuIdList = newIds.difference(oldIds).toList();
    List<int> removeMenuIdList = oldIds.difference(newIds).toList();
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionCategoryUseMenu(
      storeId: UserHive.getBox(key: UserKey.storeId),
      menuOptionCategoryId: menuOptionCategoryId,
      addMenuIdList: addMenuIdList,
      removeMenuIdList: removeMenuIdList,
    );
    if (response.statusCode == 200) {
      getMenuOptionInfo();
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 옵션 카테고리 추가
  Future<bool> createOptionCategory(
      String menuOptionCategoryName,
      List<MenuOptionModel> selectedMenuOptions,
      int essentialStatus,
      int minChoice,
      int maxChoice,
      List<MenuModel> appliedMenus,
      ) async {
    final response = await ref.read(menuOptionsServiceProvider).createOptionCategory(
      storeId: UserHive.getBox(key: UserKey.storeId),
      menuOptionCategoryName: menuOptionCategoryName,
      selectedMenuOptions: selectedMenuOptions,
      essentialStatus: essentialStatus,
      minChoice: minChoice,
      maxChoice: maxChoice,
      appliedMenus: appliedMenus,
    );
    if (response.statusCode == 200) {
      getMenuOptionInfo();
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// DELETE - 메뉴 옵션 카테고리 삭제
  Future<bool> deleteMenuOptionCategory(MenuOptionCategoryModel optionCategoryModel) async {
    final response = await ref.read(menuOptionsServiceProvider).deleteMenuOptionCategory(storeId: UserHive.getBox(key: UserKey.storeId), optionCategoryModel: optionCategoryModel);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel =
      state.menuOptionsDataModel.copyWith(menuOptionCategoryDTOList: state.menuOptionsDataModel.menuOptionCategoryDTOList.where((optionCategory) => optionCategory.menuOptionCategoryId != optionCategoryModel.menuOptionCategoryId).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 이름 변경
  Future<bool> updateMenuOptionName(int menuOptionId, String optionContent) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionName(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionId: menuOptionId, optionContent: optionContent);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuOptionDTOList: state.menuOptionsDataModel.storeMenuOptionDTOList.map((option) {
            return option.menuOptionId == menuOptionId ? option.copyWith(optionContent: optionContent) : option;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 가격 변경
  Future<bool> updateMenuOptionPrice(int menuOptionId, int price) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionPrice(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionId: menuOptionId, price: price);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuOptionDTOList: state.menuOptionsDataModel.storeMenuOptionDTOList.map((option) {
            return option.menuOptionId == menuOptionId ? option.copyWith(price: price) : option;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 옵션 품절 상태 변경
  Future<bool> updateMenuOptionSoldOutStatus(int menuOptionId, int soldOutStatus) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionSoldOutStatus(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionId: menuOptionId, soldOutStatus: soldOutStatus);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuOptionDTOList: state.menuOptionsDataModel.storeMenuOptionDTOList.map((option) {
            return option.menuOptionId == menuOptionId ? option.copyWith(soldOutStatus: soldOutStatus) : option;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// GET - 메뉴 옵션 정보 조회
  Future<NutritionModel> getMenuInfo(int menuOptionId) async {
    final response = await ref.read(menuOptionsServiceProvider).getMenuInfo(menuOptionId: menuOptionId);
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      logger.i("getMenuInfo result ${result.toFormattedJson()}");
      return NutritionModel.fromJson(result.data);
    } else {
      return const NutritionModel();
    }
  }

  /// POST - 메뉴 옵션 정보 변경
  Future<bool> updateMenuOptionInfo(int menuOptionId, NutritionModel nutrition) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuOptionInfo(storeId: UserHive.getBox(key: UserKey.storeId), menuOptionId: menuOptionId, nutrition: nutrition);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// POST - 메뉴 옵션 삭제
  Future<int> deleteMenuOption(MenuOptionModel menuOptionModel) async {
    try {
      final response = await ref.read(menuOptionsServiceProvider).deleteMenuOption(
        storeId: UserHive.getBox(key: UserKey.storeId),
        menuOptionModel: menuOptionModel,
      );

      if (response.statusCode == 200) {
        // 삭제된 옵션을 상태에서 제거
        final updatedStoreMenuOptionDTOList = state.storeMenuOptionDTOList
            .where((option) => option.menuOptionId != menuOptionModel.menuOptionId)
            .toList();

        final updatedMenuOptionCategoryDTOList = state.menuOptionCategoryDTOList.map((category) {
          final updatedOptions = category.menuOptions
              .where((option) => option.menuOptionId != menuOptionModel.menuOptionId)
              .toList();
          return category.copyWith(menuOptions: updatedOptions);
        }).toList();

        // 상태 업데이트
        state = state.copyWith(
          storeMenuOptionDTOList: updatedStoreMenuOptionDTOList,
          menuOptionCategoryDTOList: updatedMenuOptionCategoryDTOList,
        );

        return response.statusCode!;
      } else {
        logger.e("Failed to delete menu option: ${response.data}");
        return response.statusCode ?? 500;
      }
    } catch (e) {
      logger.e("Error deleting menu option: $e");
      return 500;
    }
  }

}

/// state provider
@freezed
abstract class MenuOptionsState with _$MenuOptionsState {
  const factory MenuOptionsState({
    @Default(DataRetrieveStatus.init) DataRetrieveStatus dataRetrieveStatus,
    @Default(MenuOptionsDataModel()) MenuOptionsDataModel menuOptionsDataModel,
    @Default(<MenuCategoryModel>[]) List<MenuCategoryModel> menuCategoryList,
    @Default(<MenuCategoryModel>[]) List<MenuCategoryModel> storeMenuCategoryDTOList,
    @Default(<MenuModel>[]) List<MenuModel> storeMenuDTOList,
    @Default(<MenuOptionCategoryModel>[]) List<MenuOptionCategoryModel> menuOptionCategoryDTOList,
    @Default(<MenuOptionModel>[]) List<MenuOptionModel> storeMenuOptionDTOList,
    @Default(<MenuOptionRelationshipModel>[]) List<MenuOptionRelationshipModel> menuOptionRelationshipDTOList,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MenuOptionsState;

  factory MenuOptionsState.fromJson(Map<String, dynamic> json) => _$MenuOptionsStateFromJson(json);
}