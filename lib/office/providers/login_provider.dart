import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/models/user_model.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/providers/find_account_webview_provider.dart';
import 'package:singleeat/office/providers/find_by_password_provider.dart';
import 'package:singleeat/office/providers/find_by_password_webview_provider.dart';
import 'package:singleeat/office/providers/home_provider.dart';
import 'package:singleeat/office/providers/login_webview_provider.dart';
import 'package:singleeat/office/providers/signup_provider.dart';
import 'package:singleeat/office/providers/signup_webview_provider.dart';
import 'package:singleeat/office/services/login_service.dart';

part 'login_provider.freezed.dart';
part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    String loginId = UserHive.getBox(key: UserKey.loginId);
    if (loginId.isEmpty) {
      return const LoginState();
    } else {
      return LoginState(isRememberLoginId: true, loginId: loginId);
    }
  }

  void init() {
    state = const LoginState();
  }

  void onChangeStatus(LoginStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangeRememberLoginId() {
    state = state.copyWith(isRememberLoginId: !state.isRememberLoginId);
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

    // 아이디 저장
    if (state.isRememberLoginId) {
      UserHive.setBox(key: UserKey.loginId, value: state.loginId);
    } else {
      UserHive.setBox(key: UserKey.loginId, value: '');
    }

    // 본인 인증
    ref
        .read(authenticateWithPhoneNumberNotifierProvider.notifier)
        .onChangeMethod(AuthenticateWithPhoneNumberMethod.DIRECT);

    switch (response.statusCode) {
      case 200:
        // 로그인 성공
        final data = ResultResponseModel.fromJson(response.data);
        if (data.success) {
          state = state.copyWith(
            status: LoginStatus.direct,
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
        // 서버 message를 화면에서 처리며
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

      default:
        state = state.copyWith(
            error: ResultFailResponseModel.fromJson(response.data));
        break;
    }
  }

  void verifyPhoneBySuccess({
    required Response response,
    required UserStatus status,
  }) async {
    final result = ResultResponseModel.fromJson(response.data);
    Map<String, dynamic> modifiedData = Map.from(result.data);

    modifiedData['accessToken'] =
        modifiedData['accessToken'] ?? UserHive.get().accessToken;
    modifiedData['refreshToken'] =
        modifiedData['refreshToken'] ?? UserHive.get().refreshToken;

    final user = UserModel.fromJson(modifiedData);
    UserHive.set(user: user.copyWith(status: status));
    state = state.copyWith(status: LoginStatus.success);

    fcmToken();
  }

  void fcmToken() async {
    final response = await ref
        .read(loginServiceProvider)
        .fcmToken(fcmToken: UserHive.getBox(key: UserKey.fcm));

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      UserHive.setBox(
        key: UserKey.fcmTokenId,
        value: (result.data['fcmTokenId'] ?? '').toString(),
      );
    } else {
      // error
    }
  }

  Future<void> verifyPhone() async {
    final response = await ref
        .read(loginServiceProvider)
        .verifyPhone(loginId: state.loginId);

    switch (response.statusCode) {
      case 200:
        verifyPhoneBySuccess(response: response, status: UserStatus.success);
        // Future.delayed(const Duration(seconds: 2), () {
        //   ref.read(goRouterProvider).go(AppRoutes.home);
        // });
        break;
      case 202:
        verifyPhoneBySuccess(response: response, status: UserStatus.wait);
        // Future.delayed(const Duration(seconds: 2), () {
        //   ref.read(goRouterProvider).go(AppRoutes.home);
        // });
        break;
      case 206:
        verifyPhoneBySuccess(response: response, status: UserStatus.notEntry);
        // Future.delayed(const Duration(seconds: 2), () {
        //   ref.read(goRouterProvider).go(AppRoutes.home);
        // });
        break;
      default:
        // 종료
        break;
    }
  }

  // JSS 2024.12.05
  Future<void> logout() async {
    try {
      final response = await ref
          .read(loginServiceProvider)
          .logout(fcmTokenId: UserHive.getBox(key: UserKey.fcmTokenId));

      switch (response.statusCode) {
        case 200:
          verifyPhoneBySuccess(response: response, status: UserStatus.success);
          break;
        default:
          // 종료
          break;
      }
    } catch (e) {
      return;
    }

    UserHive.set(user: const UserModel());

    state = const LoginState();
    ref.invalidate(authenticateWithPhoneNumberNotifierProvider);
    ref.invalidate(loginWebViewNotifierProvider);
    ref.invalidate(findAccountWebViewNotifierProvider);
    ref.invalidate(findByPasswordWebViewNotifierProvider);
    ref.invalidate(signupWebViewNotifierProvider);
    ref.invalidate(signupNotifierProvider);
    ref.invalidate(findByPasswordNotifierProvider);
    ref.invalidate(homeNotifierProvider);

    ref.read(goRouterProvider).go(AppRoutes.login, extra: UniqueKey());
  }

  void autoLogin() async {
    // 로그아웃 상태
    UserModel user = UserHive.get();
    if (user.accessToken.isEmpty || user.refreshToken.isEmpty) return;

    final response = await ref.read(loginServiceProvider).autoLogin();

    switch (response.statusCode) {
      case 200:
        verifyPhoneBySuccess(response: response, status: UserStatus.success);
        break;
      case 202:
        verifyPhoneBySuccess(response: response, status: UserStatus.wait);
        break;
      case 206:
        verifyPhoneBySuccess(response: response, status: UserStatus.notEntry);
        break;
      default:
        // 종료
        break;
    }
  }
}

enum LoginStatus {
  init,
  password,
  direct,
  success,
  error,
}

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.init) LoginStatus status,
    @Default(false) bool isRememberLoginId,
    @Default('') String loginId,
    @Default('') String password,
    @Default('') String showTitleMessage,
    @Default('') String showSubMessage,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _LoginState;

  factory LoginState.fromJson(Map<String, dynamic> json) =>
      _$LoginStateFromJson(json);
}
