import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    List<String> selectedUserMenuCategories,
    int price,
    Nutrition nutrition,
    int servingAmount,
    String servingAmountType,
    String imagePath,
    String menuBriefDescription,
    String menuDescription,
    String selectedMenuOptionCategories,
  ) async {

    logger.d("======= selectedMenuOptionCategories $selectedMenuOptionCategories");

    final response = await ref.read(menuOptionsServiceProvider).createMenu(
          storeId: UserHive.getBox(key: UserKey.storeId),
          menuName: menuName,
          selectedMenuCategory: selectedMenuCategory,
          selectedUserMenuCategories: selectedUserMenuCategories,
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
