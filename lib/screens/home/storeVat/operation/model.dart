import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreVatStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreVatSaleModel with _$StoreVatSaleModel {
  const factory StoreVatSaleModel({
    @Default(0) int otherSalesSupplyAmount, // 이메일
    @Default(0) int otherSalesVatAmount, // 대표자 구분
    @Default(0) int cardSalesSupplyAmount, // 사업자 이름
    @Default(0) int cardSalesVatAmount, // 사업자등록번호
    @Default(0) int cashSalesSupplyAmount, // 세금신고자료 발행정보
    @Default(0) int cashSalesVatAmount, // 매출 규모 분류
  }) = _StoreVatSaleModel;

  factory StoreVatSaleModel.fromJson(Map<String, dynamic> json) =>
      _$StoreVatSaleModelFromJson(json);
}

@freezed
abstract class StoreVatPurchasesModel with _$StoreVatPurchasesModel {
  const factory StoreVatPurchasesModel({
    @Default(0) int pickUpOrderPlatformFeeSupplyAmount, // 이메일
    @Default(0) int pickUpOrderPlatformFeeVatAmount, // 대표자 구분
    @Default(0) int deliveryOrderPlatformFeeSupplyAmount, // 사업자 이름
    @Default(0) int deliveryOrderPlatformFeeVatAmount, // 사업자등록번호
    @Default(0) int paymentFeeSupplyAmount, // 세금신고자료 발행정보
    @Default(0) int paymentFeeVatAmount, // 매출 규모 분류
  }) = _StoreVatPurchasesModel;

  factory StoreVatPurchasesModel.fromJson(Map<String, dynamic> json) =>
      _$StoreVatPurchasesModelFromJson(json);
}
