import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../core/components/date_range_picker.dart';

part 'model.freezed.dart';

part 'model.g.dart';


/// data retrieve model. api response 형상에 맞춤.
/*
    "minDeliveryTime": 20,
    "maxDeliveryTime": 60,
    "minTakeOutTime": 20,
    "maxTakeOutTime": 60,
    "storeDeliveryTipDTOList": [
      {
        "content": "8,000원 이상",
        "minPrice": 8000,
        "maxPrice": 9999,
        "deliveryTip": 3900
      }
    ],
    "deliveryAddress": "역삼동"
 */
@freezed
abstract class DeliveryDataModel with _$DeliveryDataModel {
  const factory DeliveryDataModel({
    @Default(0) int minDeliveryTime,
    @Default(0) int maxDeliveryTime,
    @Default(0) int minTakeOutTime,
    @Default(0) int maxTakeOutTime,
    @Default(4000) int baseDeliveryTip, // 기본 배달팁. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(5000) int baseDeliveryTipMax, // 기본 배달팁 최대금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(16000) int minimumOrderPrice, // 최소 주문 금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(<DeliveryTipModel>[]) List<DeliveryTipModel> storeDeliveryTipDTOList,
    @Default('') String deliveryAddress,
  }) = _DeliveryDataModel;

  factory DeliveryDataModel.fromJson(Map<String, dynamic> json) => _$DeliveryDataModelFromJson(json);
}

@freezed
abstract class DeliveryTipModel with _$DeliveryTipModel {
  const factory DeliveryTipModel({
    @Default('') String content,
    @Default(0) int minPrice,
    @Default(0) int maxPrice,
    @Default(0) int deliveryTip,
  }) = _DeliveryTipModel;

  factory DeliveryTipModel.fromJson(Map<String, dynamic> json) => _$DeliveryTipModelFromJson(json);
}




