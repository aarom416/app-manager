import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/services/statistics_service.dart';

part 'statistics_provider.freezed.dart';
part 'statistics_provider.g.dart';

@Riverpod(keepAlive: true)
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  StatisticsState build() {
    return const StatisticsState();
  }

  void loadStatisticsByStoreId() async {
    final response =
        await ref.read(statisticsServiceProvider).loadStatisticsByStoreId(
              storeId: UserHive.getBox(key: UserKey.storeId),
            );

    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StatisticsStatus {
  init,
  success,
  error,
}

@freezed
abstract class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    @Default(StatisticsStatus.init) StatisticsStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StatisticsState;

  factory StatisticsState.fromJson(Map<String, dynamic> json) =>
      _$StatisticsStateFromJson(json);
}
