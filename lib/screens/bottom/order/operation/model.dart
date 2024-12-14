import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/model.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class NewOrderModel with _$NewOrderModel {
  const factory NewOrderModel({
    @Default(0) int orderInformationId,
    @Default('') String orderStatus,
    @Default('') String pickUpNumber,
    @Default('') String receiveFoodType,
    @Default(0) int orderAmount,
    @Default('') String createdDate,
    @Default(0) int expectedTime,
    @Default([]) List<OrderMenuDTO> orderMenuDTOList,
    @Default([]) List<List<OrderMenuOptionDTO>> orderMenuOptionDTOList,
  }) = _NewOrderModel;

  factory NewOrderModel.fromJson(Map<String, dynamic> json) =>
      _$NewOrderModelFromJson(json);
}


/*
@freezed
abstract class AcceptOrderModel with _$AcceptOrderModel {
  const factory AcceptOrderModel({
    @Default(0) int orderInformationId,
    @Default('') String orderStatus,
    @Default('') String pickUpNumber,
    @Default('') String receiveFoodType,
    @Default(0) int orderAmount,
    @Default(0) int expectedTime,
    @Default('') String createdDate,
    @Default([]) List<OrderMenuDTO> orderMenuDTOList,
    @Default([]) List<List<OrderMenuOptionDTO>> orderMenuOptionDTOList,
  }) = _AcceptOrderModel;

  factory AcceptOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AcceptOrderModelFromJson(json);
}

@freezed
abstract class CompleteOrderModel with _$CompleteOrderModel {
  const factory CompleteOrderModel({
    @Default(0) int orderInformationId,
    @Default('') String pickUpNumber,
    @Default('') String receiveFoodType,
    @Default(0) int orderAmount,
    @Default('') String createdDate,
    @Default([]) List<OrderMenuDTO> orderMenuDTOList,
    @Default([]) List<List<OrderMenuOptionDTO>> orderMenuOptionDTOList,
  }) = _CompleteOrderModel;

  factory CompleteOrderModel.fromJson(Map<String, dynamic> json) =>
      _$CompleteOrderModelFromJson(json);
}
*/
