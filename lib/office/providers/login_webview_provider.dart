import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/login_provider.dart';

part 'login_webview_provider.freezed.dart';
part 'login_webview_provider.g.dart';

@Riverpod(keepAlive: true)
class LoginWebViewNotifier extends _$LoginWebViewNotifier {
  @override
  LoginWebViewState build() {
    return const LoginWebViewState();
  }

  void onChangeHtml({required String html}) {
    state = state.copyWith(html: html);
  }

  void onChangeIdentityVerificationId(String identityVerificationId) {
    state = state.copyWith(identityVerificationId: identityVerificationId);
  }

  void reset() {
    state = const LoginWebViewState();
  }

  void onChangeStatus(LoginWebViewStatus status) {
    state = state.copyWith(status: status);
  }

  bool onClick() {
    if (state.status == LoginWebViewStatus.success) {
      ref.read(loginNotifierProvider.notifier).verifyPhone();
      return true;
    } else {
      return false;
    }
  }
}

enum LoginWebViewStatus {
  init,
  success,
  error,
}

@freezed
abstract class LoginWebViewState with _$LoginWebViewState {
  const factory LoginWebViewState({
    @Default(LoginWebViewStatus.init) LoginWebViewStatus status,
    @Default('') String html,
    @Default('') String identityVerificationId,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _LoginWebViewState;

  factory LoginWebViewState.fromJson(Map<String, dynamic> json) =>
      _$LoginWebViewStateFromJson(json);
}
