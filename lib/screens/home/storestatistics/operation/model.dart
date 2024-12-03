import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreStatisticsStatus {
  init,
  success,
  error,
}

@freezed
class MenuRecommendStatisticsDTO with _$MenuRecommendStatisticsDTO {
  const factory MenuRecommendStatisticsDTO({
    @Default(0) int count,
    @Default('') String date, //": "2024년 11월 25일"
  }) = _MenuRecommendStatisticsDTO;

  factory MenuRecommendStatisticsDTO.fromJson(Map<String, dynamic> json) =>
      _$MenuRecommendStatisticsDTOFromJson(json);
}

@freezed
class OrderInformationStatisticsDTO with _$OrderInformationStatisticsDTO {
  const factory OrderInformationStatisticsDTO({
    @Default('') String receivedFoodType,
    @Default('') String date, //": "2024년 11월 25일"
    @Default(0) int count,
  }) = _OrderInformationStatisticsDTO;

  factory OrderInformationStatisticsDTO.fromJson(Map<String, dynamic> json) =>
      _$OrderInformationStatisticsDTOFromJson(json);
}

@freezed
abstract class StoreStatisticsModel with _$StoreStatisticsModel {
  const factory StoreStatisticsModel({
    @Default([])
    List<MenuRecommendStatisticsDTO> menuRecommendStatisticsDTOList, // 대표자 구분
    @Default([])
    List<OrderInformationStatisticsDTO>
        orderInformationStatisticsDTOList, // 사업자 이름
  }) = _StoreStatisticsModel;

  factory StoreStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsModelFromJson(json);
}
