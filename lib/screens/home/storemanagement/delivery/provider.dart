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
          storeDeliveryTipDTOList: deliveryDataModel.storeDeliveryTipDTOList,
          deliveryAddress: deliveryDataModel.deliveryAddress,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(dataRetrieveStatus: DataRetrieveStatus.error, error: ResultFailResponseModel.fromJson(response.data));
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
    @Default(<DeliveryTipModel>[]) List<DeliveryTipModel> storeDeliveryTipDTOList,
    @Default('') String deliveryAddress,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _DeliveryState;

  factory DeliveryState.fromJson(Map<String, dynamic> json) => _$DeliveryStateFromJson(json);
}
