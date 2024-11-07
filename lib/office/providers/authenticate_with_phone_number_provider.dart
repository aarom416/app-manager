import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/login_provider.dart';
import 'package:singleeat/office/providers/webview_provider.dart';
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

  void identityVerification() async {
    final login = ref.read(loginNotifierProvider);
    final response = await ref
        .read(authenticateWithPhoneNumberServiceProvider)
        .identityVerification(
          loginId: login.loginId,
          method: state.method.name,
        );

    if (response.statusCode == 200) {
      ref
          .read(webViewNotifierProvider.notifier)
          .onChangeHtml(html: response.data, method: state.method);
      state = state.copyWith(status: AuthenticateWithPhoneNumberStatus.success);
    }
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
