import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';

part 'model.g.dart';

enum StoreOperationInfoStatus {
  init,
  success,
  error,
}

@freezed
abstract class OperationTimeDetailModel with _$OperationTimeDetailModel {
  const factory OperationTimeDetailModel({
    /*
        "holidayType": 0,
        "cycle": 7,
        "day": "월",
        "startDate": "2024.03.04",
        "endDate": "2024.03.05",
        "ment": "3월 4일부터 3월 5일까지 리모델링으로 인해 임시 휴업합니다."
        "startTime": "08:00",
        "endTime": "21:00"
     */
    @Default(0) int holidayType,
    @Default(0) int cycle,
    @Default('') String day,
    @Default('') String startTime,
    @Default('') String endTime,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default('') String ment,
  }) = _OperationTimeDetailModel;

  factory OperationTimeDetailModel.fromJson(Map<String, dynamic> json) => _$OperationTimeDetailModelFromJson(json);
}

@freezed
abstract class StoreOperationInfoModel with _$StoreOperationInfoModel {
  const factory StoreOperationInfoModel({
    @Default(0) int deliveryStatus,
    @Default(0) int takeOutStatus,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> operationTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> breakTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> holidayDetailDTOList,
    @Default(0) int holidayStatus,
  }) = _StoreOperationInfoModel;

  factory StoreOperationInfoModel.fromJson(Map<String, dynamic> json) => _$StoreOperationInfoModelFromJson(json);
}
