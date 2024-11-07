import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/providers/signup_provider.dart';

part 'webview_provider.freezed.dart';

part 'webview_provider.g.dart';

@Riverpod(keepAlive: true)
class WebViewNotifier extends _$WebViewNotifier {
  @override
  WebViewState build() {
    return const WebViewState();
  }

  void onChangeHtml({
    required String html,
    required AuthenticateWithPhoneNumberMethod method,
  }) {
    state = state.copyWith(html: html, method: method);
  }

  void onChangeIdentityVerificationId(String identityVerificationId) {
    state = state.copyWith(identityVerificationId: identityVerificationId);
  }

  void onChangeStatus(WebViewStatus status) {
    if (status == WebViewStatus.success) {
      switch (state.method) {
        case AuthenticateWithPhoneNumberMethod.SIGNUP:
          ref
              .read(signupNotifierProvider.notifier)
              .onChangeStatus(SignupStatus.step2);
          break;
        case AuthenticateWithPhoneNumberMethod.DIRECT:
          break;
        case AuthenticateWithPhoneNumberMethod.ACCOUNT:
          break;
        case AuthenticateWithPhoneNumberMethod.PASSWORD:
          break;
        case AuthenticateWithPhoneNumberMethod.PHONE:
          break;
      }
    } else {
      switch (state.method) {
        case AuthenticateWithPhoneNumberMethod.SIGNUP:
          ref
              .read(signupNotifierProvider.notifier)
              .onChangeStatus(SignupStatus.error);
          break;
        case AuthenticateWithPhoneNumberMethod.DIRECT:
          break;
        case AuthenticateWithPhoneNumberMethod.ACCOUNT:
          break;
        case AuthenticateWithPhoneNumberMethod.PASSWORD:
          break;
        case AuthenticateWithPhoneNumberMethod.PHONE:
          break;
      }
    }

    state = state.copyWith(status: status);
  }
}

enum WebViewStatus {
  init,
  success,
  error,
}

@freezed
abstract class WebViewState with _$WebViewState {
  const factory WebViewState({
    @Default(WebViewStatus.init) WebViewStatus status,
    @Default('') String html,
    @Default(AuthenticateWithPhoneNumberMethod.SIGNUP)
    AuthenticateWithPhoneNumberMethod method,
    @Default('') String identityVerificationId,
  }) = _WebViewState;

  factory WebViewState.fromJson(Map<String, dynamic> json) =>
      _$WebViewStateFromJson(json);
}
