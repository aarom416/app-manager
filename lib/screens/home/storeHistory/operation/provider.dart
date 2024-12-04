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

  /// GET - 영업 정보 조회
  void getStoreHistory() async {
    final response = await ref
        .read(storeHistoryServiceProvider)
        .getStoreHistory(
            storeId: UserHive.getBox(key: UserKey.storeId),
            page: '0',
            filter: '0');

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);
      List<StoreHistoryModel> storeHistoryList = [];

      for (var item in result.data) {
        StoreHistoryModel storeHistoryModel = StoreHistoryModel.fromJson(item);
        storeHistoryList.add(storeHistoryModel);
      }
      //final storeHistory = StoreHistoryModel.fromJson(result.data);
      state = state.copyWith(
          status: StoreHistoryStatus.success,
          storeHistoryList: storeHistoryList,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreHistoryStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
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
    @Default(StoreHistoryStatus.init) StoreHistoryStatus status,
    @Default([]) List<StoreHistoryModel> storeHistoryList,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreHistoryState;

  factory StoreHistoryState.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryStateFromJson(json);
}
