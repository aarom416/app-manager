import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreOrderHistoryStatus {
  init,
  success,
  error,
}

@freezed
class OrderHistoryDTO with _$OrderHistoryDTO {
  const factory OrderHistoryDTO({
    @Default(0) int orderInformationId,
    @Default('') String orderStatus,
    @Default('') String orderNumber,
    @Default('') String receiveFoodType,
    @Default(0) int totalOrderAmount,
    @Default(<OrderMenuDTO>[]) List<OrderMenuDTO> orderMenuDTOList,
    @Default([<OrderMenuOptionDTO>[]])
    List<List<OrderMenuOptionDTO>> orderMenuOptionDTOList,
    @Default('') String toOwner,
    @Default('') String toRider,
    @Default('') String address,
    @Default('') String payMethodDetail,
    @Default('') String secondPayMethod,
    @Default(0) int deliveryTip,
    @Default(0) int couponDiscount,
    @Default(0) int pointAmount,
    @Default('') String createdDate,
    @Default('') String receivedDate,
    @Default('') String completedDate,
  }) = _OrderHistoryDTO;

  factory OrderHistoryDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryDTOFromJson(json);
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
abstract class StoreOrderHistoryModel with _$StoreOrderHistoryModel {
  const factory StoreOrderHistoryModel({
    @Default(0) int totalOrderCount,
    @Default(0.0) double totalOrderAmount,
    @Default([]) List<OrderHistoryDTO> orderHistoryDTOList,
  }) = _StoreOrderHistoryModel;

  factory StoreOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoreOrderHistoryModelFromJson(json);
}
