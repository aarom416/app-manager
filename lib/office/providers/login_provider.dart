import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/services/login_service.dart';

part 'login_provider.freezed.dart';
part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return const LoginState();
  }

  void onChangeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  void directLogin() async {
    /* server log로 대체
    if (state.loginId.isEmpty) {
      state = state.copyWith(
          error: const ResultFailResponseModel(
              success: false, errorMessage: '아이디는 필수로 입력해야합니다.'));
    }
    
    if (state.password.length >= 8 && state.password.length <= 30) {
      state = state.copyWith(
          error: const ResultFailResponseModel(
              success: false, errorMessage: '비밀번호는 최소 8글자 최대 30글자입니다.'));
    }
     */

    final response = await ref
        .read(loginServiceProvider)
        .directLogin(loginId: state.loginId, password: state.password);

    if (response.statusCode == 200) {
      final data = ResultResponseModel.fromJson(response.data);
      if (data.success) {
        state = state.copyWith(
          status: LoginStatus.success,
          error: const ResultFailResponseModel(),
        );
      }
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum LoginStatus {
  init,
  success,
  error,
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String loginId,
    @Default('') String password,
    @Default(LoginStatus.init) LoginStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}
