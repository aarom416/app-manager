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

  void init() {
    state = const LoginState();
  }

  void onChangeStatus(LoginStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  void directLogin() async {
    final response = await ref
        .read(loginServiceProvider)
        .directLogin(loginId: state.loginId, password: state.password);

    switch (response.statusCode) {
      case 200:
        final data = ResultResponseModel.fromJson(response.data);
        if (data.success) {
          state = state.copyWith(
            status: LoginStatus.success,
            error: const ResultFailResponseModel(),
          );
        }
        break;

      case 202:
        final data = ResultResponseModel.fromJson(response.data);
        if (data.success) {
          state = state.copyWith(
            status: LoginStatus.password,
            error: const ResultFailResponseModel(),
          );
        }
        break;

      case 403:
        // DELETED_ACCOUNT - 탈퇴한 계정
        break;
      case 423:
        // ACCOUNT_3DAYS_LOCKED - 3일 정지
        break;
      case 451:
        // ACCOUNT_7DAYS_LOCKED - 7일 정지
        break;
      case 429:
        // REQUEST_EXCEED_EXCEPTION | LOGIN_ATTEMPT_EXCEEDED - 로그인 시도 횟수 초과
        state = state.copyWith(showTitleMessage: '5분간 로그인이 제한됩니다');
        break;
      case 500:
        // INTERNAL_SERVER_ERROR - 관리자 문의
        break;
      default:
        final error = ResultFailResponseModel.fromJson(response.data);
        state = state.copyWith(error: error);
        break;
    }
  }
}

enum LoginStatus {
  init,
  password,
  success,
  error,
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String loginId,
    @Default('') String password,
    @Default(LoginStatus.init) LoginStatus status,
    @Default('') String showTitleMessage,
    @Default('') String showSubMessage,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}
