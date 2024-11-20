import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/store_info_model.dart';

part 'store_management_provider.freezed.dart';
part 'store_management_provider.g.dart';

@Riverpod(keepAlive: true)
class StoreManagementNotifier extends _$StoreManagementNotifier {
  @override
  StoreManagementState build() {
    return const StoreManagementState();
  }
}

enum StoreManagementStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreManagementState with _$StoreManagementState {
  const factory StoreManagementState({
    @Default(StoreManagementStatus.init) StoreManagementStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreManagementState;

  factory StoreManagementState.fromJson(Map<String, dynamic> json) =>
      _$StoreManagementStateFromJson(json);
}
