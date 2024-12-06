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
    List<MenuRecommendStatisticsDTO> menuRecommendStatisticsDTOList,
    @Default([])
    List<OrderInformationStatisticsDTO> orderInformationStatisticsDTOList,
  }) = _StoreStatisticsModel;

  factory StoreStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsModelFromJson(json);
}

@freezed
abstract class StoreStatisticsWeekModel with _$StoreStatisticsWeekModel {
  const factory StoreStatisticsWeekModel({
    @Default('') String weekName,
    @Default(0) int count,
  }) = _StoreStatisticsWeekModel;

  factory StoreStatisticsWeekModel.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsWeekModelFromJson(json);
}

@freezed
abstract class StoreStatisticsMonthModel with _$StoreStatisticsMonthModel {
  const factory StoreStatisticsMonthModel({
    @Default('') String monthName,
    @Default(0) int count,
  }) = _StoreStatisticsMonthModel;

  factory StoreStatisticsMonthModel.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsMonthModelFromJson(json);
}
