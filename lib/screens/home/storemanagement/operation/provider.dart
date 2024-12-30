import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storemanagement/operation/service.dart';

import '../../../common/emuns.dart';
import 'model.dart';

part 'provider.freezed.dart';

part 'provider.g.dart';

/// network provider
@Riverpod(keepAlive: true)
class OperationNotifier extends _$OperationNotifier {
  @override
  OperationState build() {
    return const OperationState();
  }

  /// GET - 영업 정보 조회
  void getOperationInfo() async {
    final response = await ref
        .read(operationServiceProvider)
        .getOperationInfo(storeId: UserHive.getBox(key: UserKey.storeId));
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final operationDataModel = OperationDataModel.fromJson(result.data);
      var operationTimeDetailDTOList =
          operationDataModel.operationTimeDetailDTOList.toList();
      operationTimeDetailDTOList =
          operationTimeDetailDTOList.map((operationTime) {
        return operationTime.copyWith(toggle: true);
      }).toList();

      var breakTimeDetailDTOList =
      operationDataModel.breakTimeDetailDTOList.toList();
      breakTimeDetailDTOList = breakTimeDetailDTOList.map((breakTime) {
        final isToggleTrue = (breakTime.startTime == "00:00" && breakTime.endTime == "00:00");
        return breakTime.copyWith(toggle: !isToggleTrue);
      }).toList();

      state = state.copyWith(
          dataRetrieveStatus: DataRetrieveStatus.success,
          operationDataModel: operationDataModel,
          deliveryStatus: operationDataModel.deliveryStatus,
          takeOutStatus: operationDataModel.takeOutStatus,
          operationTimeDetailDTOList: operationTimeDetailDTOList,
          breakTimeDetailDTOList: breakTimeDetailDTOList,
          holidayDetailDTOList: operationDataModel.holidayDetailDTOList,
          holidayStatus: operationDataModel.holidayStatus,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          dataRetrieveStatus: DataRetrieveStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 배달 상태 수정
  void updateDeliveryStatus(int deliveryStatus) async {
    final response = await ref
        .read(operationServiceProvider)
        .updateDeliveryStatus(
            storeId: UserHive.getBox(key: UserKey.storeId),
            deliveryStatus: deliveryStatus);
    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(),
          deliveryStatus: deliveryStatus);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 포장 상태 수정
  void updatePickupStatus(int pickUpStatus) async {
    final response = await ref
        .read(operationServiceProvider)
        .updatePickupStatus(
            storeId: UserHive.getBox(key: UserKey.storeId),
            pickUpStatus: pickUpStatus);
    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(), takeOutStatus: pickUpStatus);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 영업 시간 변경
  void updateOperationTime(
      List<OperationTimeDetailModel> operationTimeDetails) async {
    final response = await ref
        .read(operationServiceProvider)
        .updateOperationTime(
            storeId: UserHive.getBox(key: UserKey.storeId),
            operationTimeDetails: operationTimeDetails);
    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(),
          operationTimeDetailDTOList: operationTimeDetails);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 휴게 시간 변경
  void updateBreakTime(List<OperationTimeDetailModel> breakTimeDetails) async {
    final response = await ref.read(operationServiceProvider).updateBreakTime(
        storeId: UserHive.getBox(key: UserKey.storeId),
        breakTimeDetails: breakTimeDetails);
    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(),
          breakTimeDetailDTOList: breakTimeDetails);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 휴무일 변경
  void updateHolidayDetail(
      int holidayStatus,
      List<OperationTimeDetailModel> regularHolidays,
      List<OperationTimeDetailModel> temporaryHolidays) async {
    final response = await ref
        .read(operationServiceProvider)
        .updateHolidayDetail(
            storeId: UserHive.getBox(key: UserKey.storeId),
            holidayStatus: holidayStatus,
            regularHolidays: regularHolidays,
            temporaryHolidays: temporaryHolidays);
    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(),
          holidayStatus: holidayStatus,
          holidayDetailDTOList: regularHolidays + temporaryHolidays);
      getOperationInfo();
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

/// state provider
@freezed
abstract class OperationState with _$OperationState {
  const factory OperationState({
    @Default(DataRetrieveStatus.init) DataRetrieveStatus dataRetrieveStatus,
    @Default(OperationDataModel()) OperationDataModel operationDataModel,
    @Default(0) int deliveryStatus,
    @Default(0) int takeOutStatus,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> operationTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> breakTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[])
    List<OperationTimeDetailModel> holidayDetailDTOList,
    @Default(0) int holidayStatus,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _OperationState;

  factory OperationState.fromJson(Map<String, dynamic> json) =>
      _$OperationStateFromJson(json);
}
