import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/screens/bottom/myinfo/orderlist/service.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/model.dart';

import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class MyInfoOrderHistoryNotifier extends _$MyInfoOrderHistoryNotifier {
  @override
  MyInfoOrderHistoryState build() {
    return const MyInfoOrderHistoryState();
  }

  void clear() {
    state = build();
  }

  void getOrderHistory() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response =
        await ref.read(myInfoOrderHistoryServiceProvider).getOrderHistory(
              storeId: storeId,
              page: state.pageNumber.toString(),
              filter: state.filter,
            );

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);

      if (result.data.isEmpty) {
        onChangeHasMoreData(hasMoreData: false);
        return;
      }

      List<MyInfoOrderHistoryModel> orderHistoryList = [];
      for (var item in result.data) {
        MyInfoOrderHistoryModel myInfoOrderHistoryModel =
            MyInfoOrderHistoryModel.fromJson(item);
        orderHistoryList.add(myInfoOrderHistoryModel);
      }

      state = state.copyWith(
        orderHistory: state.pageNumber == 0
            ? orderHistoryList
            : [
                ...state.orderHistory,
                ...orderHistoryList,
              ],
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangePageNumber({required int pageNumber}) {
    state = state.copyWith(pageNumber: pageNumber);
  }

  Future<void> onChangeFilter({required String filter}) async {
    state = state.copyWith(filter: filter);
    clearFilter();
    getOrderHistory();
  }

  void onChangeHasMoreData({required bool hasMoreData}) {
    state = state.copyWith(hasMoreData: hasMoreData);
  }

  void clearFilter() {
    state = state.copyWith(pageNumber: 0, hasMoreData: true, orderHistory: []);
  }
}

enum MyInfoOrderHistoryStatus {
  init,
  success,
  error,
}

@freezed
abstract class MyInfoOrderHistoryState with _$MyInfoOrderHistoryState {
  const factory MyInfoOrderHistoryState({
    @Default(true) bool hasMoreData,
    @Default(MyInfoOrderHistoryStatus.init) MyInfoOrderHistoryStatus status,
    @Default([]) List<MyInfoOrderHistoryModel> orderHistory,
    @Default(0) int pageNumber,
    @Default('0') String filter,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MyInfoOrderHistoryState;

  factory MyInfoOrderHistoryState.fromJson(Map<String, dynamic> json) =>
      _$MyInfoOrderHistoryStateFromJson(json);
}
