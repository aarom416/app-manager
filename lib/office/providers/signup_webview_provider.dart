import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/signup_provider.dart';

part 'signup_webview_provider.freezed.dart';
part 'signup_webview_provider.g.dart';

@Riverpod(keepAlive: true)
class SignupWebViewNotifier extends _$SignupWebViewNotifier {
  @override
  SignupWebViewState build() {
    return const SignupWebViewState();
  }

  void onChangeHtml({required String html}) {
    state = state.copyWith(html: html);
  }

  void onChangeIdentityVerificationId(String identityVerificationId) {
    state = state.copyWith(identityVerificationId: identityVerificationId);
  }

  void reset() {
    state = const SignupWebViewState();
  }

  bool onClick() {
    if (state.status == SignupWebViewStatus.success) {
      ref
          .read(signupNotifierProvider.notifier)
          .onChangeStatus(SignupStatus.step2);
      return true;
    } else {
      return false;
    }
  }

  void onChangeStatus({required SignupWebViewStatus status}) {
    state = state.copyWith(status: status);
  }
}

enum SignupWebViewStatus {
  init,
  success,
  error,
}

@freezed
abstract class SignupWebViewState with _$SignupWebViewState {
  const factory SignupWebViewState({
    @Default(SignupWebViewStatus.init) SignupWebViewStatus status,
    @Default('') String html,
    @Default('') String identityVerificationId,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _SignupWebViewState;

  factory SignupWebViewState.fromJson(Map<String, dynamic> json) =>
      _$SignupWebViewStateFromJson(json);
}
