import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storemanagement/operation/service.dart';

import 'model.dart';

part 'provider.freezed.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreOperationNotifier extends _$StoreOperationNotifier {
  @override
  StoreOperationState build() {
    return const StoreOperationState();
  }

  /// GET - 영업 정보 조회
  void getOperationInfo() async {
    final response = await ref.read(storeOperationServiceProvider).getOperationInfo(storeId: UserHive.getBox(key: UserKey.storeId));
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final storeOperationInfo = StoreOperationInfoModel.fromJson(result.data);
      state = state.copyWith(
          status: StoreOperationStatus.success,
          storeOperationInfo: storeOperationInfo,
          deliveryStatus: storeOperationInfo.deliveryStatus,
          takeOutStatus: storeOperationInfo.takeOutStatus,
          operationTimeDetailDTOList: storeOperationInfo.operationTimeDetailDTOList,
          breakTimeDetailDTOList: storeOperationInfo.breakTimeDetailDTOList,
          holidayDetailDTOList: storeOperationInfo.holidayDetailDTOList,
          holidayStatus: storeOperationInfo.holidayStatus,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(status: StoreOperationStatus.error, error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 배달 상태 수정
  void updateDeliveryStatus(int deliveryStatus) async {
    final response = await ref.read(storeOperationServiceProvider).updateDeliveryStatus(storeId: UserHive.getBox(key: UserKey.storeId), deliveryStatus: deliveryStatus);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), deliveryStatus: deliveryStatus);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 포장 상태 수정
  void updatePickupStatus(int pickUpStatus) async {
    final response = await ref.read(storeOperationServiceProvider).updatePickupStatus(storeId: UserHive.getBox(key: UserKey.storeId), pickUpStatus: pickUpStatus);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), takeOutStatus: pickUpStatus);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 영업 시간 변경
  void updateOperationTime(List<OperationTimeDetailModel> operationTimeDetails) async {
    final response = await ref.read(storeOperationServiceProvider).updateOperationTime(storeId: UserHive.getBox(key: UserKey.storeId), operationTimeDetails: operationTimeDetails);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), operationTimeDetailDTOList: operationTimeDetails);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 휴게 시간 변경
  void updateBreakTime(List<OperationTimeDetailModel> breakTimeDetails) async {
    final response = await ref.read(storeOperationServiceProvider).updateBreakTime(storeId: UserHive.getBox(key: UserKey.storeId), breakTimeDetails: breakTimeDetails);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), breakTimeDetailDTOList: breakTimeDetails);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StoreOperationStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreOperationState with _$StoreOperationState {
  const factory StoreOperationState({
    @Default(StoreOperationStatus.init) StoreOperationStatus status,
    @Default(StoreOperationInfoModel()) StoreOperationInfoModel storeOperationInfo,
    @Default(0) int deliveryStatus,
    @Default(0) int takeOutStatus,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> operationTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> breakTimeDetailDTOList,
    @Default(<OperationTimeDetailModel>[]) List<OperationTimeDetailModel> holidayDetailDTOList,
    @Default(0) int holidayStatus,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreOperationState;

  factory StoreOperationState.fromJson(Map<String, dynamic> json) => _$StoreOperationStateFromJson(json);
}
