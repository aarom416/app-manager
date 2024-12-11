import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/service.dart';

import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreOrderHistoryNotifier extends _$StoreOrderHistoryNotifier {
  @override
  StoreOrderHistoryState build() {
    return const StoreOrderHistoryState();
  }

  void clear() {
    state = build();
  }

  void getOrderHistoryByFilter() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(storeOrderHistoryServiceProvider)
        .getOrderHistoryByFilter(
            storeId: storeId,
            page: state.pageNumber.toString(),
            filter: state.filter,
            startDate: state.startDate,
            endDate: state.endDate);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      var storeOrderHistory = StoreOrderHistoryModel.fromJson(result.data);

      if (storeOrderHistory.orderHistoryDTOList.isEmpty) {
        onChangeHasMoreData(hasMoreData: false);
        return;
      }

      // 페이징의 경우 데이터 append
      if (state.pageNumber != 0) {
        final copiedOrderHistoryDTOList =
            state.storeOrderHistory.orderHistoryDTOList.toList();
        copiedOrderHistoryDTOList.addAll(storeOrderHistory.orderHistoryDTOList);

        storeOrderHistory = state.storeOrderHistory.copyWith(
          totalOrderCount: storeOrderHistory.totalOrderCount,
          totalOrderAmount: storeOrderHistory.totalOrderAmount,
          orderHistoryDTOList: copiedOrderHistoryDTOList,
        );
      }

      state = state.copyWith(
        storeOrderHistory: storeOrderHistory,
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  Future<void> onChangeFilter({required String filter}) async {
    state = state.copyWith(filter: filter);
    clearFilter();
    getOrderHistoryByFilter();
  }

  void onChangeStartDate({required String startDate}) async {
    state = state.copyWith(startDate: startDate);
  }

  void onChangeEndDate({required String endDate}) async {
    state = state.copyWith(endDate: endDate);
  }

  void onChangeHasMoreData({required bool hasMoreData}) {
    state = state.copyWith(hasMoreData: hasMoreData);
  }

  void onChangePageNumber({required int pageNumber}) {
    state = state.copyWith(pageNumber: pageNumber);
  }

  void clearFilter() {
    state = state.copyWith(
      pageNumber: 0,
      hasMoreData: true,
      storeOrderHistory: const StoreOrderHistoryModel(),
    );
  }
}

enum StoreOrderHistoryStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreOrderHistoryState with _$StoreOrderHistoryState {
  const factory StoreOrderHistoryState({
    @Default(true) bool hasMoreData,
    @Default(StoreOrderHistoryStatus.init) StoreOrderHistoryStatus status,
    @Default(StoreOrderHistoryModel()) StoreOrderHistoryModel storeOrderHistory,
    @Default(0) int pageNumber,
    @Default('0') String filter,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default(0) int totalOrderCount,
    @Default(0) int totalOrderAmount,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreOrderHistoryState;

  factory StoreOrderHistoryState.fromJson(Map<String, dynamic> json) =>
      _$StoreOrderHistoryStateFromJson(json);
}
