import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/find_account_webview_provider.dart';
import 'package:singleeat/office/providers/find_by_password_provider.dart';
import 'package:singleeat/office/providers/find_by_password_webview_provider.dart';
import 'package:singleeat/office/providers/login_provider.dart';
import 'package:singleeat/office/providers/login_webview_provider.dart';
import 'package:singleeat/office/providers/signup_webview_provider.dart';
import 'package:singleeat/office/services/authenticate_with_phone_number_service.dart';

part 'authenticate_with_phone_number_provider.freezed.dart';
part 'authenticate_with_phone_number_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthenticateWithPhoneNumberNotifier
    extends _$AuthenticateWithPhoneNumberNotifier {
  @override
  AuthenticateWithPhoneNumberState build() {
    return const AuthenticateWithPhoneNumberState();
  }

  void onChangeStatus(AuthenticateWithPhoneNumberStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangeMethod(AuthenticateWithPhoneNumberMethod method) {
    state = state.copyWith(method: method);
  }

  String getLoginId() {
    if (state.method == AuthenticateWithPhoneNumberMethod.DIRECT) {
      return ref.read(loginNotifierProvider).loginId ?? '';
    } else if (state.method == AuthenticateWithPhoneNumberMethod.PASSWORD) {
      return ref.read(findByPasswordNotifierProvider).loginId ?? '';
    }

    return '';
  }

  void identityVerification() async {
    final response = await ref
        .read(authenticateWithPhoneNumberServiceProvider)
        .identityVerification(
          loginId: getLoginId(),
          method: state.method.name,
        );

    if (response.statusCode == 200) {
      switch (state.method) {
        case AuthenticateWithPhoneNumberMethod.SIGNUP:
          ref
              .read(signupWebViewNotifierProvider.notifier)
              .onChangeHtml(html: response.data);
          break;
        case AuthenticateWithPhoneNumberMethod.DIRECT:
          ref
              .read(loginWebViewNotifierProvider.notifier)
              .onChangeHtml(html: response.data);
          break;
        case AuthenticateWithPhoneNumberMethod.ACCOUNT:
          ref
              .read(findAccountWebViewNotifierProvider.notifier)
              .onChangeHtml(html: response.data);
          break;
        case AuthenticateWithPhoneNumberMethod.PASSWORD:
          ref
              .read(findByPasswordWebViewNotifierProvider.notifier)
              .onChangeHtml(html: response.data);
          break;
        case AuthenticateWithPhoneNumberMethod.PHONE:
          break;
      }

      state = state.copyWith(status: AuthenticateWithPhoneNumberStatus.success);
    }
  }

  void reset() {
    state = AuthenticateWithPhoneNumberState(method: state.method);
  }
}

enum AuthenticateWithPhoneNumberStatus {
  init,
  success,
  error,
}

enum AuthenticateWithPhoneNumberMethod {
  SIGNUP,
  DIRECT,
  ACCOUNT,
  PASSWORD,
  PHONE,
}

@freezed
abstract class AuthenticateWithPhoneNumberState
    with _$AuthenticateWithPhoneNumberState {
  const factory AuthenticateWithPhoneNumberState({
    @Default(AuthenticateWithPhoneNumberStatus.init)
    AuthenticateWithPhoneNumberStatus status,
    @Default(AuthenticateWithPhoneNumberMethod.DIRECT)
    AuthenticateWithPhoneNumberMethod method,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _AuthenticateWithPhoneNumberState;

  factory AuthenticateWithPhoneNumberState.fromJson(
          Map<String, dynamic> json) =>
      _$AuthenticateWithPhoneNumberStateFromJson(json);
}
