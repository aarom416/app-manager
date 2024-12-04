import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum MyInfoOrderHistoryStatus {
  init,
  success,
  error,
}

@freezed
class OrderMenuDTO with _$OrderMenuDTO {
  const factory OrderMenuDTO({
    @Default(0) int orderMenuId,
    @Default(0) int orderInformationId,
    @Default(0) int menuId,
    @Default('') String menuName,
    @Default(0) int menuPrice,
    @Default(0) int count,
  }) = _OrderMenuDTO;

  factory OrderMenuDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderMenuDTOFromJson(json);
}

@freezed
class OrderMenuOptionDTO with _$OrderMenuOptionDTO {
  const factory OrderMenuOptionDTO({
    @Default(0) int orderMenuOptionId,
    @Default(0) int orderMenuId,
    @Default(0) int menuOptionId,
    @Default('') String menuOptionName,
    @Default(0) int menuOptionPrice,
    @Default(0) int count,
  }) = _OrderMenuOptionDTO;

  factory OrderMenuOptionDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderMenuOptionDTOFromJson(json);
}

@freezed
abstract class MyInfoOrderHistoryModel with _$MyInfoOrderHistoryModel {
  const factory MyInfoOrderHistoryModel({
    @Default('') String orderStatus,
    @Default('') String receiveFoodType,
    @Default('') String pickUpNumber,
    @Default('') String toOwner,
    @Default('') String toRider,
    @Default([]) List<OrderMenuDTO> orderMenuDTOList,
    @Default([]) List<List<OrderMenuOptionDTO>> orderMenuOptionDTOList,
    @Default(0) int orderAmount,
    @Default(0) int deliveryTip,
    @Default(0) int couponDiscount,
    @Default(0) int pointAmount,
    @Default(0) int totalOrderAmount,
    @Default('') String payMethodDetail,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String createdDate,
    @Default('') String receiveDate,
    @Default('') String completedDate,
    @Default('') String storeName,
    @Default('') String orderNumber,
  }) = _MyInfoOrderHistoryModel;

  factory MyInfoOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$MyInfoOrderHistoryModelFromJson(json);
}
