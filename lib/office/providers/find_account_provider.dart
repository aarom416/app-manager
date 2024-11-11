import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_account_provider.freezed.dart';
part 'find_account_provider.g.dart';

@Riverpod(keepAlive: true)
class FindAccountNotifier extends _$FindAccountNotifier {
  @override
  FindAccountState build() {
    return const FindAccountState();
  }

  void onChangeStatus(FindAccountStatus status) {
    state = state.copyWith(status: status);
  }
}

enum FindAccountStatus {
  step1,
  step2,
  step3,
  error,
}

@freezed
abstract class FindAccountState with _$FindAccountState {
  const factory FindAccountState({
    @Default(FindAccountStatus.step1) FindAccountStatus status,
  }) = _FindAccountState;

  factory FindAccountState.fromJson(Map<String, dynamic> json) =>
      _$FindAccountStateFromJson(json);
}
