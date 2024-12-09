import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreSettlementStatus {
  init,
  success,
  error,
}

@freezed
class ResponseSettlementDTO with _$ResponseSettlementDTO {
  const factory ResponseSettlementDTO({
    @Default('') String settlementStatus,
    @Default('') String settlementStartDate,
    @Default('') String settlementEndDate,
    @Default('') String settlementDate,
    @Default(0) int settlementAmount,
    @Default(0) int orderAmount,
    @Default(0) int deliveryTip,
    @Default(0) int agentFee,
    @Default(0) int agentFeeTax,
    @Default(0) int storeCouponDiscount,
  }) = _ResponseSettlementDTO;

  factory ResponseSettlementDTO.fromJson(Map<String, dynamic> json) =>
      _$ResponseSettlementDTOFromJson(json);
}

@freezed
abstract class StoreSettlementModel with _$StoreSettlementModel {
  const factory StoreSettlementModel({
    @Default(0) int totalSettlementAmount,
    @Default(<ResponseSettlementDTO>[])
    List<ResponseSettlementDTO> responseSettlementDTOList,
  }) = _StoreSettlementModel;

  factory StoreSettlementModel.fromJson(Map<String, dynamic> json) =>
      _$StoreSettlementModelFromJson(json);
}
