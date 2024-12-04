import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/bottom/myinfo/operationstatus/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class MyInfoOperationNotifier extends _$MyInfoOperationNotifier {
  @override
  MyInfoOperationState build() {
    return const MyInfoOperationState();
  }

  void operationStatus(int status) async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(myInfoOperationServiceProvider)
        .operationStatus(storeId: storeId, status: status);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      state = state.copyWith(
        operationStatus: result.success == true ? 1 : 0,
      );
    }
  }

  void onChangeStatus(int status) {
    state = state.copyWith(operationStatus: status);
  }
}

enum MyInfoOperationStatus {
  init,
  success,
  error,
}

@freezed
abstract class MyInfoOperationState with _$MyInfoOperationState {
  const factory MyInfoOperationState({
    @Default(MyInfoOperationStatus.init) MyInfoOperationStatus status,
    @Default(0) int operationStatus,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MyInfoOperationState;

  factory MyInfoOperationState.fromJson(Map<String, dynamic> json) =>
      _$MyInfoOperationStateFromJson(json);
}
