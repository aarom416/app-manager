import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

@freezed
abstract class CouponInformationModel with _$CouponInformationModel {
  const factory CouponInformationModel({
    @Default(0) int couponId,
    @Default('') String couponName,
    @Default('') String discountType,
    @Default(0) int discountValue,
    @Default(0) int discountLimit,
    @Default(0) int minOrderAmount,
    @Default(0) int isFirstOrder,
    @Default(0) int isDeliveryOrder,
    @Default(0) int isPickupOrder,
    @Default('') String startDate,
    @Default('') String expiredDate,
  }) = _CouponInformationModel;

  factory CouponInformationModel.fromJson(Map<String, dynamic> json) =>
      _$CouponInformationModelFromJson(json);
}
