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
      state = state.copyWith(
          dataRetrieveStatus: DataRetrieveStatus.success,
          menuOptionsDataModel: menuOptionsDataModel,
          menuCategoryList: menuOptionsDataModel.storeMenuCategoryDTOList,




          // storeMenuDTOList: menuOptionsDataModel.storeMenuDTOList,
          // menuOptionCategoryDTOList: menuOptionsDataModel.menuOptionCategoryDTOList,
          // storeMenuOptionDTOList: menuOptionsDataModel.storeMenuOptionDTOList,
          // menuOptionRelationshipDTOList: menuOptionsDataModel.menuOptionRelationshipDTOList,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(dataRetrieveStatus: DataRetrieveStatus.error, error: ResultFailResponseModel.fromJson(response.data));
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

    // @Default(<MenuCategoryModel>[]) List<MenuCategoryModel> storeMenuCategoryDTOList,
    // @Default(<MenuModel>[]) List<MenuModel> storeMenuDTOList,
    // @Default(<MenuOptionCategoryModel>[]) List<MenuOptionCategoryModel> menuOptionCategoryDTOList,
    // @Default(<MenuOptionModel>[]) List<MenuOptionModel> storeMenuOptionDTOList,
    // @Default(<MenuOptionRelationshipModel>[]) List<MenuOptionRelationshipModel> menuOptionRelationshipDTOList,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MenuOptionsState;

  factory MenuOptionsState.fromJson(Map<String, dynamic> json) => _$MenuOptionsStateFromJson(json);
}
