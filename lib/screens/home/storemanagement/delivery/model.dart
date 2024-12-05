import 'package:freezed_annotation/freezed_annotation.dart';

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
    @Default(5000) int deliveryTipMax, // 배달팁 최대금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(16000) int minimumOrderPrice, // 최소 주문 금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(<DeliveryTipModel>[]) List<DeliveryTipModel> storeDeliveryTipDTOList,
    @Default('30,100원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는  동일한 배달팁이 적용돼요') String deliveryTipInfo, // 배달팁 안내. 필요해 보이나, api 규격에 존재하지 않음.
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

/// DeliveryTipModel 확장함수
extension DeliveryTipModelExtensions on DeliveryTipModel {
  /// 두 DeliveryTipModel 객체를 비교
  bool isEqualTo(DeliveryTipModel other) {
    return content == other.content && minPrice == other.minPrice && maxPrice == other.maxPrice && deliveryTip == other.deliveryTip;
  }
}

/// 두 List<DeliveryTipModel> 이 동일한지 비교하는 확장함수
extension DeliveryTipModelListExtensions on List<DeliveryTipModel> {
  bool isEqualTo(List<DeliveryTipModel> other) {
    if (length != other.length) {
      return false;
    }
    for (int i = 0; i < length; i++) {
      if (!this[i].isEqualTo(other[i])) {
        return false;
      }
    }
    return true;
  }
}
