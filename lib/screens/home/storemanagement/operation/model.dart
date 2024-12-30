import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../../core/components/date_range_picker.dart';

part 'model.freezed.dart';

part 'model.g.dart';

/// data retrieve model. api response 형상에 맞춤.
/*
    "deliveryStatus": 1,
    "takeOutStatus": 1,
    "operationTimeDetailDTOList": [
      {
        "day": "월",
        "startTime": "08:00",
        "endTime": "21:00"
      }
    ],
    "breakTimeDetailDTOList": [
      {
        "day": "월",
        "startTime": "08:00",
        "endTime": "21:00"
      }
    ],
    "holidayDetailDTOList": [
      {
        "holidayType": 0,
        "cycle": 7,
        "day": "월",
        "startDate": "2024.03.04",
        "endDate": "2024.03.05",
        "ment": "3월 4일부터 3월 5일까지 리모델링으로 인해 임시 휴업합니다."
      }
    ],
    "holidayStatus": 1
 */
@freezed
abstract class OperationDataModel with _$OperationDataModel {
  const factory OperationDataModel({
    @Default(0) int deliveryStatus,
    @Default(0) int takeOutStatus,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> operationTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> breakTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> holidayDetailDTOList,
    @Default(0) int holidayStatus,
  }) = _OperationDataModel;

  factory OperationDataModel.fromJson(Map<String, dynamic> json) =>
      _$OperationDataModelFromJson(json);
}

@freezed
abstract class OperationTimeDetailModel with _$OperationTimeDetailModel {
  const factory OperationTimeDetailModel({
    @Default(false) bool toggle,
    @Default(0) int holidayType,
    @Default(0) int cycle,
    @Default('') String day,
    @Default('') String startTime,
    @Default('') String endTime,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default('') String ment,
  }) = _OperationTimeDetailModel;

  factory OperationTimeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OperationTimeDetailModelFromJson(json);
}

/// OperationTimeDetailModel 확장함수
extension OperationTimeDetailModelExtensions on OperationTimeDetailModel {
  /// OperationTimeDetailModel 에서 DateRange 를 생성
  DateRange get toDateRange {
    final dateFormat = DateFormat("yyyy.MM.dd");
    int uniqueId = DateTime.now().millisecondsSinceEpoch;
    DateTime startDate = dateFormat.parse(this.startDate);
    DateTime endDate = dateFormat.parse(this.endDate);
    return DateRange(id: uniqueId, start: startDate, end: endDate);
  }

  /// 24시간 영업인지의 여부
  bool is24OperationHour() {
    return startTime == "00:00" && endTime == "24:00";
  }

  /// 24시간 영업으로 변경
  OperationTimeDetailModel get to24OperationHour {
    return copyWith(startTime: "00:00", endTime: "24:00");
  }

  /// 기본 영업시간으로 변경
  OperationTimeDetailModel get toDefaultOperationHour {
    return copyWith(startTime: "09:00", endTime: "21:00");
  }

  /// 휴게시간 없는지의 여부
  bool isNoBreak() {
    return startTime == "00:00" && endTime == "00:00";
  }

  /// 휴게시간 없음으로 변경
  OperationTimeDetailModel get toNoBreak {
    return copyWith(toggle: false, startTime: "00:00", endTime: "00:00");
  }

  /// 기본 휴게시간으로 변경
  OperationTimeDetailModel get toDefaultBreakHour {
    return copyWith(toggle: true, startTime: "15:00", endTime: "17:00");
  }

  /// 정기 휴무 인지의 여부
  bool isRegularHoliday() {
    return holidayType == 0;
  }

  /// 임시 휴무 인지의 여부
  bool isTemporaryHoliday() {
    return holidayType == 1;
  }

  /// 주간 정기 휴무인지의 여부
  bool isWeekCycleHoliday() {
    return isRegularHoliday() && cycle == 7;
  }
}
