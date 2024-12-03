import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storestatistics/operation/service.dart';

import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreStatisticsNotifier extends _$StoreStatisticsNotifier {
  @override
  StoreStatisticsState build() {
    return const StoreStatisticsState();
  }

  /// GET - 영업 정보 조회
  void loadStatisticsByStoreId() async {
    final response = await ref
        .read(storeStatisticsServiceProvider)
        .loadStatisticsByStoreId(
            storeId: UserHive.getBox(key: UserKey.storeId));

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final storeStatistics = StoreStatisticsModel.fromJson(result.data);

      state = state.copyWith(
          status: StoreStatisticsStatus.success,
          storeStatistics: storeStatistics,
          takeoutCount: storeStatistics.orderInformationStatisticsDTOList
              .where((item) => item.receivedFoodType == 'DELIVERY')
              .length,
          deliveryCount: storeStatistics.orderInformationStatisticsDTOList
              .where((item) => item.receivedFoodType == 'TAKEOUT')
              .length,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreStatisticsStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StoreStatisticsStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreStatisticsState with _$StoreStatisticsState {
  const factory StoreStatisticsState({
    @Default(StoreStatisticsStatus.init) StoreStatisticsStatus status,
    @Default(StoreStatisticsModel()) StoreStatisticsModel storeStatistics,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
    @Default(0) int deliveryCount,
    @Default(0) int takeoutCount,
  }) = _StoreStatisticsState;

  factory StoreStatisticsState.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsStateFromJson(json);
}
