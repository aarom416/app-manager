import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/model.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum MyInfoOrderHistoryStatus {
  init,
  success,
  error,
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
    @Default('') String orderTime,
    @Default('') String orderDate,
    @Default('') String orderDateTime,
    @Default('') String receivedDate,
    @Default('') String completedDate,
    @Default('') String storeName,
    @Default('') String orderNumber,
  }) = _MyInfoOrderHistoryModel;

  factory MyInfoOrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$MyInfoOrderHistoryModelFromJson(json);
}
