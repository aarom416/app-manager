import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

part 'model.g.dart';

/// data retrieve model. api response 형상에 맞춤.
@freezed
abstract class MenuOptionsDataModel with _$MenuOptionsDataModel {
  const factory MenuOptionsDataModel({
    @Default(<MenuCategoryModel>[]) List<MenuCategoryModel> storeMenuCategoryDTOList,
    @Default(<MenuModel>[]) List<MenuModel> storeMenuDTOList,
    @Default(<MenuOptionCategoryModel>[]) List<MenuOptionCategoryModel> menuOptionCategoryDTOList,
    @Default(<MenuOptionModel>[]) List<MenuOptionModel> storeMenuOptionDTOList,
    @Default(<MenuOptionRelationshipModel>[]) List<MenuOptionRelationshipModel> menuOptionRelationshipDTOList,
  }) = _MenuOptionsDataModel;

  factory MenuOptionsDataModel.fromJson(Map<String, dynamic> json) => _$MenuOptionsDataModelFromJson(json);
}

@freezed
abstract class MenuCategoryModel with _$MenuCategoryModel {
  const factory MenuCategoryModel({
    @Default(-1) int storeId,
    @Default(-1) int storeMenuCategoryId,
    @Default('') String menuCategoryName,
    @Default('') String menuIntroduction, // categoryDescription 이어야 함.
    @Default(<MenuModel>[]) List<MenuModel> menuList,
  }) = _MenuCategoryModel;

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) => _$MenuCategoryModelFromJson(json);
}

@freezed
abstract class MenuModel with _$MenuModel {
  const factory MenuModel({
    @Default(-1) int menuId,
    @Default(-1) int storeMenuCategoryId,
    @Default(0) int popularityStatus,
    @Default(0) int bestStatus,
    @Default(0) int soldOutStatus,
    @Default('') String menuName,
    @Default('') String madeOf,
    @Default('') String menuIntroduction,
    @Default(0) int price,
    @Default('https://via.placeholder.com/150') String menuPictureURL,
    @Default(NutritionModel())
    NutritionModel nutrition,
    @Default(<MenuOptionCategoryModel>[]) List<MenuOptionCategoryModel> menuCategoryOptions,
  }) = _MenuModel;

  factory MenuModel.fromJson(Map<String, dynamic> json) => _$MenuModelFromJson(json);
}

@freezed
abstract class NutritionModel with _$NutritionModel {
  const factory NutritionModel({
    @Default(0) int servingAmount,
    @Default('g') String servingAmountType,
    @Default(0) int calories,
    @Default(0) int carbohydrate,
    @Default(0) int protein,
    @Default(0) int fat,
    @Default(0) int sugar,
    @Default(0) int saturatedFat,
    @Default(0) int natrium,
  }) = _NutritionModel;

  factory NutritionModel.fromJson(Map<String, dynamic> json) => _$NutritionModelFromJson(json);
}

@freezed
abstract class MenuOptionCategoryModel with _$MenuOptionCategoryModel {
  const factory MenuOptionCategoryModel({
    @Default(-1) int menuOptionCategoryId,
    @Default('') String menuOptionCategoryName,
    @Default(0) int essentialStatus,
    @Default(0) int minChoice,
    @Default(0) int maxChoice,
    @Default(<MenuOptionModel>[]) List<MenuOptionModel> menuOptions,
  }) = _MenuOptionCategoryModel;

  factory MenuOptionCategoryModel.fromJson(Map<String, dynamic> json) => _$MenuOptionCategoryModelFromJson(json);
}

@freezed
abstract class MenuOptionModel with _$MenuOptionModel {
  const factory MenuOptionModel({
    @Default(0) int menuOptionId,
    @Default(-1) int menuOptionCategoryId,
    @Default('') String optionContent,
    @Default(0) int price,
    @Default(0) int soldOutStatus,
    @Default(NutritionModel())
    NutritionModel nutrition, //Nutrition. 필요해 보이나, api 규격에 존재하지 않음.
  }) = _MenuOptionModel;

  factory MenuOptionModel.fromJson(Map<String, dynamic> json) => _$MenuOptionModelFromJson(json);
}

@freezed
abstract class MenuOptionRelationshipModel with _$MenuOptionRelationshipModel {
  const factory MenuOptionRelationshipModel({
    @Default(-1) int menuId,
    @Default(-1) int menuOptionCategoryId,
    @Default(-1) int menuOptionId,
  }) = _MenuOptionRelationshipModel;

  factory MenuOptionRelationshipModel.fromJson(Map<String, dynamic> json) => _$MenuOptionRelationshipModelFromJson(json);
}

@freezed
abstract class GetMenuDataModel with _$GetMenuDataModel {
  const factory GetMenuDataModel({
    @Default('') String madeOf,
    @Default('') String menuIntroduction,
    @Default(0) int servingAmount,
    @Default('g') String servingAmountType,
    @Default(0) int calories,
    @Default(0) int carbohydrate,
    @Default(0) int protein,
    @Default(0) int fat,
    @Default(0) int sugar,
    @Default(0) int saturatedFat,
    @Default(0) int natrium,
  }) = _GetMenuDataModel;

  factory GetMenuDataModel.fromJson(Map<String, dynamic> json) => _$GetMenuDataModelFromJson(json);
}
