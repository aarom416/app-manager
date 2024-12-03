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

  List<int> processOrderDeliveryStatistics(List<dynamic> orderStatistics) {
    // 날짜별, 음식 유형별 총 카운트를 저장할 맵
    Map<String, dynamic> consolidatedStats = {};

    int index = 0;
    // 주어진 리스트를 순회하며 통계 계산
    for (var entry in orderStatistics) {
      String date = entry.date;
      String foodType = entry.receivedFoodType;
      int count = entry.count;

      // 날짜별 맵이 없으면 생성 (null 안전하게)
      consolidatedStats[date] ??= {'date': date, 'delivery': 0};

      // null 안전하게 카운트 업데이트
      if (foodType == 'DELIVERY') {
        consolidatedStats[date]['delivery'] += count;
      }
    }

    List<int> deliveryList = [];

    consolidatedStats.forEach((key, value) {
      deliveryList.add(value['delivery']);
    });

    return deliveryList;
  }

  List<int> processOrderTakeoutStatistics(List<dynamic> orderStatistics) {
    // 날짜별, 음식 유형별 총 카운트를 저장할 맵
    Map<String, dynamic> consolidatedStats = {};

    int index = 0;
    // 주어진 리스트를 순회하며 통계 계산
    for (var entry in orderStatistics) {
      String date = entry.date;
      String foodType = entry.receivedFoodType;
      int count = entry.count;

      // 날짜별 맵이 없으면 생성 (null 안전하게)
      consolidatedStats[date] ??= {'date': date, 'takeout': 0};

      // null 안전하게 카운트 업데이트
      if (foodType == 'TAKEOUT') {
        consolidatedStats[date]['takeout'] += count;
      }
    }

    List<int> takeoutList = [];

    consolidatedStats.forEach((key, value) {
      takeoutList.add(value['takeout']);
    });

    return takeoutList;
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
          deliveryDailyCount: processOrderDeliveryStatistics(
              storeStatistics.orderInformationStatisticsDTOList),
          takeoutDailyCount: processOrderTakeoutStatistics(
              storeStatistics.orderInformationStatisticsDTOList),
          takeoutCount: storeStatistics.orderInformationStatisticsDTOList
              .where((item) => item.receivedFoodType == 'TAKEOUT')
              .fold(
                  0, (previousValue, element) => previousValue + element.count),
          deliveryCount: storeStatistics.orderInformationStatisticsDTOList
              .where((item) => item.receivedFoodType == 'DELIVERY')
              .fold(
                  0, (previousValue, element) => previousValue + element.count),
          dailyOrderCount: storeStatistics.orderInformationStatisticsDTOList.fold(
              0, (previousValue, element) => previousValue + element.count),
          dailyTotalCount: storeStatistics.menuRecommendStatisticsDTOList.fold(
              0, (previousValue, element) => previousValue + element.count),
          totalCharLabelDaily: storeStatistics.menuRecommendStatisticsDTOList
              .map((element) => element.date.substring(element.date.length - 3, element.date.length))
              .toList(),
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
    @Default(0) int dailyTotalCount,
    @Default(0) int dailyOrderCount,
    @Default([]) List<int> deliveryDailyCount,
    @Default([]) List<int> takeoutDailyCount,
    @Default([]) List<String> totalCharLabelDaily,
    @Default([]) List<String> totalCharLabelMonthly,
    @Default([]) List<String> totalCharLabelWeekly,
  }) = _StoreStatisticsState;

  factory StoreStatisticsState.fromJson(Map<String, dynamic> json) =>
      _$StoreStatisticsStateFromJson(json);
}
