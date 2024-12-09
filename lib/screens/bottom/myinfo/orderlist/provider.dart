import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/screens/bottom/myinfo/orderlist/service.dart';

import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class MyInfoOrderHistoryNotifier extends _$MyInfoOrderHistoryNotifier {
  @override
  MyInfoOrderHistoryState build() {
    return const MyInfoOrderHistoryState();
  }

  void getOrderHistory() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(myInfoOrderHistoryServiceProvider)
        .getOrderHistory(
            storeId: storeId,
            page: state.pageNumber.toString(),
            filter: state.filter);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);
      List<MyInfoOrderHistoryModel> orderHistoryList = [];
      for (var item in result.data) {
        MyInfoOrderHistoryModel myInfoOrderHistoryModel =
            MyInfoOrderHistoryModel.fromJson(item);
        orderHistoryList.add(myInfoOrderHistoryModel);
      }
      state = state.copyWith(
        orderHistory: orderHistoryList,
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  Future<void> onChangePageNumber({required int pageNumber}) async {
    state = state.copyWith(pageNumber: pageNumber);
    getOrderHistory();
  }

  Future<void> onChangeFilter({required String filter}) async {
    state = state.copyWith(filter: filter);
    getOrderHistory();
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
    @Default(MyInfoOrderHistoryStatus.init) MyInfoOrderHistoryStatus status,
    @Default([]) List<MyInfoOrderHistoryModel> orderHistory,
    @Default(0) int pageNumber,
    @Default('0') String filter,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MyInfoOrderHistoryState;

  factory MyInfoOrderHistoryState.fromJson(Map<String, dynamic> json) =>
      _$MyInfoOrderHistoryStateFromJson(json);
}
