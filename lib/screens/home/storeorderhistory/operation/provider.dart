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
    return StoreOrderHistoryState();
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
    getOrderHistoryByFilter();
  }

  void onChangeStartDate({required String startDate}) async {
    state = state.copyWith(startDate: startDate);
  }

  void onChangeEndDate({required String endDate}) async {
    state = state.copyWith(endDate: endDate);
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
