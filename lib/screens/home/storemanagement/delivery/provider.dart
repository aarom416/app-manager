import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/service.dart';

import '../../../common/emuns.dart';
import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

/// network provider
@Riverpod(keepAlive: true)
class DeliveryNotifier extends _$DeliveryNotifier {
  @override
  DeliveryState build() {
    return const DeliveryState();
  }

  /// GET - 배달/포장 정보 조회
  void getDeliveryTakeoutInfo() async {
    final response = await ref.read(deliveryServiceProvider).getDeliveryTakeoutInfo(storeId: UserHive.getBox(key: UserKey.storeId));
    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final deliveryDataModel = DeliveryDataModel.fromJson(result.data);
      state = state.copyWith(
          dataRetrieveStatus: DataRetrieveStatus.success,
          deliveryDataModel: deliveryDataModel,
          minDeliveryTime: deliveryDataModel.minDeliveryTime,
          maxDeliveryTime: deliveryDataModel.maxDeliveryTime,
          minTakeOutTime: deliveryDataModel.minTakeOutTime,
          maxTakeOutTime: deliveryDataModel.maxTakeOutTime,
          baseDeliveryTip: deliveryDataModel.baseDeliveryTip,
          // 기본 배달팁. figma 상 존재하나, api 규격에 존재하지 않음.
          deliveryTipMax: deliveryDataModel.deliveryTipMax,
          // 기본 배달팁. figma 상 존재하나, api 규격에 존재하지 않음.
          minimumOrderPrice: deliveryDataModel.minimumOrderPrice,
          // 최소 주문 금액. figma 상 존재하나, api 규격에 존재하지 않음.
          storeDeliveryTipDTOList: deliveryDataModel.storeDeliveryTipDTOList,
          deliveryAddress: deliveryDataModel.deliveryAddress,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(dataRetrieveStatus: DataRetrieveStatus.error, error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 배달 예상 시간 수정
  void updateDeliveryTime(int minDeliveryTime, int maxDeliveryTime) async {
    final response = await ref.read(deliveryServiceProvider).updateDeliveryTime(storeId: UserHive.getBox(key: UserKey.storeId), minDeliveryTime: minDeliveryTime, maxDeliveryTime: maxDeliveryTime);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), minDeliveryTime: minDeliveryTime, maxDeliveryTime: maxDeliveryTime);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 포장 예상 시간 수정
  void updatePickupTime(int minTakeOutTime, int maxTakeOutTime) async {
    final response = await ref.read(deliveryServiceProvider).updatePickupTime(storeId: UserHive.getBox(key: UserKey.storeId), minTakeOutTime: minTakeOutTime, maxTakeOutTime: maxTakeOutTime);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), minTakeOutTime: minTakeOutTime, maxTakeOutTime: maxTakeOutTime);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 배달팁 변경
  void updateDeliveryTip(int baseDeliveryTip, int minimumOrderPrice, List<DeliveryTipModel> storeDeliveryTipDTOList) async {
    final response = await ref
        .read(deliveryServiceProvider)
        .updateDeliveryTip(storeId: UserHive.getBox(key: UserKey.storeId), baseDeliveryTip: baseDeliveryTip, minimumOrderPrice: minimumOrderPrice, storeDeliveryTipDTOList: storeDeliveryTipDTOList);
    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel(), baseDeliveryTip: baseDeliveryTip, minimumOrderPrice: minimumOrderPrice, storeDeliveryTipDTOList: storeDeliveryTipDTOList);
    } else {
      state = state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

/// state provider
@freezed
abstract class DeliveryState with _$DeliveryState {
  const factory DeliveryState({
    @Default(DataRetrieveStatus.init) DataRetrieveStatus dataRetrieveStatus,
    @Default(DeliveryDataModel()) DeliveryDataModel deliveryDataModel,
    @Default(0) int minDeliveryTime,
    @Default(0) int maxDeliveryTime,
    @Default(0) int minTakeOutTime,
    @Default(0) int maxTakeOutTime,
    @Default(0) int baseDeliveryTip, // 기본 배달팁. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(0) int deliveryTipMax, // 기본 배달팁 최대금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(0) int minimumOrderPrice, // 최소 주문 금액. figma 상 존재하나, api 규격에 존재하지 않음.
    @Default(<DeliveryTipModel>[]) List<DeliveryTipModel> storeDeliveryTipDTOList,
    @Default('') String deliveryAddress,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _DeliveryState;

  factory DeliveryState.fromJson(Map<String, dynamic> json) => _$DeliveryStateFromJson(json);
}
