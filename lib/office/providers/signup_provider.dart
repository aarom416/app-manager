import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_provider.freezed.dart';

part 'signup_provider.g.dart';

@Riverpod(keepAlive: true)
class SignupNotifier extends _$SignupNotifier {
  @override
  SignupState build() {
    return const SignupState();
  }

  void onChangeStatus(SignupStatus status) {
    state = state.copyWith(status: status);
  }
}

enum SignupStatus {
  step1,
  step2,
  step3,
  step4,
  step5,
  error,
}

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(SignupStatus.step1) SignupStatus status,
  }) = _SignupState;

  factory SignupState.fromJson(Map<String, dynamic> json) =>
      _$SignupStateFromJson(json);
}
