import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/service.dart';

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

  /// GET - 배달/포장 정보 조회
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
    state = state.copyWith(
        dataRetrieveStatus: DataRetrieveStatus.success,
        menuOptionsDataModel: menuOptionsDataModel,
        menuCategoryList: createMenuCategoryModels(
            storeMenuCategoryDTOList: menuOptionsDataModel.storeMenuCategoryDTOList,
            storeMenuDTOList: menuOptionsDataModel.storeMenuDTOList,
            menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList,
            storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
            menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList),
        storeMenuCategoryDTOList: menuOptionsDataModel.storeMenuCategoryDTOList,
        storeMenuDTOList: menuOptionsDataModel.storeMenuDTOList,
        menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList,
        storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
        menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList);
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
      MenuOptionsDataModel updatedMenuOptionsDataModel = state.menuOptionsDataModel.copyWith(storeMenuCategoryDTOList: [...state.menuOptionsDataModel.storeMenuCategoryDTOList, newMenuCategoryModel]);
      setState(updatedMenuOptionsDataModel);
      state = state.copyWith(error: const ResultFailResponseModel());
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