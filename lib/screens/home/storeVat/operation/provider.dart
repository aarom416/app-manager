import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storeVat/operation/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreVatNotifier extends _$StoreVatNotifier {
  @override
  StoreVatState build() {
    return const StoreVatState();
  }

  /// GET - 주간 통계 조회
  void getVatInfo() async {
    final response = await ref
        .read(storeVatServiceProvider)
        .getVatInfo(storeId: UserHive.getBox(key: UserKey.storeId));

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      state = state.copyWith(error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreVatStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StoreVatStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreVatState with _$StoreVatState {
  const factory StoreVatState({
    @Default(StoreVatStatus.init) StoreVatStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreVatState;

  factory StoreVatState.fromJson(Map<String, dynamic> json) =>
      _$StoreVatStateFromJson(json);
}
