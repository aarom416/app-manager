import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/screens/home/storeHistory/operation/service.dart';

import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreHistoryNotifier extends _$StoreHistoryNotifier {
  @override
  StoreHistoryState build() {
    return const StoreHistoryState();
  }

  void clear() {
    state = build();
  }

  /// GET - 영업 정보 조회
  void getStoreHistory(
      String startDate,
      String endDate,
      ) async {
    final response = await ref
        .read(storeHistoryServiceProvider)
        .getStoreHistory(
        storeId: UserHive.getBox(key: UserKey.storeId),
        page: state.page.toString(),
        filter: state.filter == '가게' ? '0' : '1',
        startDate: startDate,
        endDate: endDate);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);
      List<StoreHistoryModel> storeHistoryList = [];

      if (result.data.isEmpty) {
        onChangeHasMoreData(false);
        return;
      }

      for (var item in result.data) {
        StoreHistoryModel storeHistoryModel = StoreHistoryModel.fromJson(item);
        storeHistoryList.add(storeHistoryModel);
      }

      state = state.copyWith(
        status: StoreHistoryStatus.success,
        storeHistoryList: state.page == 0
            ? storeHistoryList
            : [
          ...state.storeHistoryList,
          ...storeHistoryList,
        ],
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          status: StoreHistoryStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeHasMoreData(bool hasMoreData) {
    state = state.copyWith(hasMoreData: hasMoreData);
  }

  void onChangePage(int page) {
    state = state.copyWith(page: page);
  }

  void onChangeFilter(String filter) {
    state = state.copyWith(filter: filter);
  }

  void clearFilter() {
    state = state.copyWith(
      hasMoreData: true,
      page: 0,
      storeHistoryList: [],
    );
  }
}

enum StoreHistoryStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreHistoryState with _$StoreHistoryState {
  const factory StoreHistoryState({
    @Default(true) bool hasMoreData,
    @Default(0) int page,
    @Default('가게') String filter,
    @Default(StoreHistoryStatus.init) StoreHistoryStatus status,
    @Default([]) List<StoreHistoryModel> storeHistoryList,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreHistoryState;

  factory StoreHistoryState.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryStateFromJson(json);
}