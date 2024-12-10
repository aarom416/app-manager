import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
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
      logger.i("getMenuOptionInfo result ${result.toFormattedJson()}");
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
      menuCategoryList: createMenuCategoryModels(
          storeMenuCategoryDTOList: storeMenuCategoryDTOList,
          storeMenuDTOList: storeMenuDTOList,
          menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList,
          storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
          menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList),
      storeMenuCategoryDTOList: storeMenuCategoryDTOList,
      storeMenuDTOList: storeMenuDTOList,
      menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList.map((menuOptionCategory) {
        List<MenuOptionModel> matchingMenuOptionOptions = menuOptionsDataModel.storeMenuOptionDTOList.where((option) => option.menuOptionCategoryId == menuOptionCategory.menuOptionCategoryId).toList();
        return menuOptionCategory.copyWith(menuOptions: matchingMenuOptionOptions);
      }).toList(),
      storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
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
          .map((relationship) => menuOptionCategoryMap.firstWhere(
                (category) => category.menuOptionCategoryId == relationship.menuOptionCategoryId,
              ))
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
  void createMenuCategory(MenuCategoryModel newMenuCategoryModel) async {
    final response = await ref.read(menuOptionsServiceProvider).createMenuCategory(storeId: UserHive.getBox(key: UserKey.storeId), newMenuCategoryModel: newMenuCategoryModel);
    if (response.statusCode == 200) {
      // MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: [...state.menuOptionsDataModel.storeMenuCategoryDTOList, newMenuCategoryModel]);
      // setState(updatedMenuOptionsDataModel);
      // state = state.copyWith(error: const ResultFailResponseModel());
      getMenuOptionInfo();
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
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

  /// POST - 메뉴 카테고리 삭제
  void deleteMenuCategory(MenuCategoryModel menuCategoryModel) async {
    final response = await ref.read(menuOptionsServiceProvider).deleteMenuCategory(storeId: UserHive.getBox(key: UserKey.storeId), menuCategoryModel: menuCategoryModel);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel =
          state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: state.menuOptionsDataModel.storeMenuCategoryDTOList.where((menuCategory) => menuCategory.storeMenuCategoryId != menuCategoryModel.storeMenuCategoryId).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 메뉴 추가
  void createMenu(
    String menuName,
    MenuCategoryModel selectedMenuCategory,
    String selectedUserMenuCategoryIdsFlatString,
    int price,
    NutritionModel nutrition,
    int servingAmount,
    String servingAmountType,
    String imagePath,
    String menuBriefDescription,
    String menuDescription,
    List<MenuOptionCategoryModel> selectedMenuOptionCategories,
  ) async {
    final response = await ref.read(menuOptionsServiceProvider).createMenu(
          storeId: UserHive.getBox(key: UserKey.storeId),
          menuName: menuName,
          selectedMenuCategory: selectedMenuCategory,
          selectedUserMenuCategoryIdsFlatString: selectedUserMenuCategoryIdsFlatString,
          price: price,
          nutrition: nutrition,
          servingAmount: servingAmount,
          servingAmountType: servingAmountType,
          imagePath: imagePath,
          menuBriefDescription: menuBriefDescription,
          menuDescription: menuDescription,
          selectedMenuOptionCategories: selectedMenuOptionCategories,
        );
    if (response.statusCode == 200) {
      getMenuOptionInfo();
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 메뉴 이름 변경
  Future<bool> updateMenuName(int menuId, String menuName) async {
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
  Future<bool> updateMenuMadeOf(int menuId, String menuParts) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuMadeOf(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, menuParts: menuParts);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(menuParts: menuParts) : menu;
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
  Future<bool> updateMenuIntroduction(int menuId, String menuDescription) async {
    final response = await ref.read(menuOptionsServiceProvider).updateMenuIntroduction(storeId: UserHive.getBox(key: UserKey.storeId), menuId: menuId, menuDescription: menuDescription);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(
          storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.map((menu) {
            return menu.menuId == menuId ? menu.copyWith(menuParts: menuDescription) : menu;
          }).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 메뉴 삭제
  Future<bool> deleteMenu(MenuModel menuModel) async {
    final response = await ref.read(menuOptionsServiceProvider).deleteMenu(storeId: UserHive.getBox(key: UserKey.storeId), menuModel: menuModel);
    if (response.statusCode == 200) {
      MenuOptionsDataModel updatedMenuOptionsDataModel =
      state.menuOptionsDataModel.copyWith(storeMenuDTOList: state.menuOptionsDataModel.storeMenuDTOList.where((menu) => menu.menuId != menuModel.menuId).toList());
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
      return false;
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
