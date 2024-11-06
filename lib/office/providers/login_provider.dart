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
        // 로그인 성공
        final data = ResultResponseModel.fromJson(response.data);
        if (data.success) {
          state = state.copyWith(
            status: LoginStatus.success,
            error: const ResultFailResponseModel(),
          );
        }
        break;

      case 202:
        // 로그인 횟수 제한 후 직접 로그인 성공
        final data = ResultResponseModel.fromJson(response.data);
        if (data.success) {
          state = state.copyWith(
            status: LoginStatus.password,
            error: const ResultFailResponseModel(),
          );
        }
        break;

      case 400:
        // 서버 message를 화면에서 처리
        final error = ResultFailResponseModel.fromJson(response.data);
        state = state.copyWith(
            error: error.copyWith(
          errorMessage: '아이디 또는 비밀번호가 잘못 되었습니다.\n아이디와 비밀번호를 정확히 입력해주세요.',
        ));
        break;

      case 404:
        // 서버 message를 화면에서 처리
        final error = ResultFailResponseModel.fromJson(response.data);
        state = state.copyWith(
            error: error.copyWith(
          errorMessage: '아이디 또는 비밀번호가 잘못 되었습니다.\n아이디와 비밀번호를 정확히 입력해주세요.',
        ));
        break;

      case 403:
        // DELETED_ACCOUNT - 탈퇴한 계정
        state = state.copyWith(
          showTitleMessage: '회원 탈퇴가 완료된 계정입니다',
          showSubMessage: '회원 탈퇴 후 21일 이내에는 로그인할 수 없습니다',
        );
        break;

      case 410:
        // ACCOUNT_LOCKED - 정지
        state = state.copyWith(
            showTitleMessage: '비정상적인 행동이 감지되었습니다.',
            showSubMessage: '고객센터(1600-6623)로 문의하시길 바랍니다.');
        break;

      case 423:
        // ACCOUNT_3DAYS_LOCKED - 3일 정지
        state = state.copyWith(
            showTitleMessage: '해당 계정이 3일간 정지되었습니다.',
            showSubMessage: '비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.');
        break;

      case 429:
        // REQUEST_EXCEED_EXCEPTION | LOGIN_ATTEMPT_EXCEEDED - 로그인 시도 횟수 초과
        state = state.copyWith(showTitleMessage: '5분간 로그인이 제한됩니다');
        break;

      case 451:
        // ACCOUNT_7DAYS_LOCKED - 7일 정지
        state = state.copyWith(
            showTitleMessage: '해당 계정이 7일간 정지되었습니다.',
            showSubMessage: '비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.');
        break;

      case 500:
        // INTERNAL_SERVER_ERROR - 관리자 문의
        state =
            state.copyWith(showTitleMessage: '고객센터(1600-6623)로 문의하시길 바랍니다.');
        break;
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
