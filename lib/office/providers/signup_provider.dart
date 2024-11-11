import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/models/user_model.dart';
import 'package:singleeat/office/providers/webview_provider.dart';
import 'package:singleeat/office/services/signup_service.dart';

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

  void onChangeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId, loginIdValid: false);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  void onChangeAuthCode(String authCode) {
    state = state.copyWith(authCode: authCode);
  }

  void onChangePasswordConfirm(String passwordConfirm) {
    state = state.copyWith(passwordConfirm: passwordConfirm);
  }

  void onChangeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void onChangeDomain(String domain) {
    state = state.copyWith(domain: domain);
  }

  void onChangeIsSingleeatAgree(bool isSingleeatAgree) {
    state = state.copyWith(isSingleeatAgree: isSingleeatAgree);
  }

  void onChangeIsAdditionalAgree(bool isAdditionalAgree) {
    state = state.copyWith(isAdditionalAgree: isAdditionalAgree);
  }

  void loginIdValidation() {
    // 정규식: 8~16자의 영문, 숫자, 특수 문자 포함
    final regExp = RegExp(r'^[A-Za-z0-9]{6,12}$');
    if (state.loginId.isEmpty || !regExp.hasMatch(state.loginId)) {
      state = state.copyWith(
          loginIdError: const ResultFailResponseModel(
              errorMessage: '6~12자 이내, 영문, 숫자만 사용 가능합니다'));
    } else {
      state = state.copyWith(loginIdError: const ResultFailResponseModel());
    }
  }

  void passwordValidation() {
    final regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,16}$');
    if (!regExp.hasMatch(state.password)) {
      state = state.copyWith(
          passwordError: const ResultFailResponseModel(
              errorMessage: '8~16자의 영문, 숫자, 특수문자를 포함해주세요'));
    } else {
      state = state.copyWith(passwordError: const ResultFailResponseModel());
    }
  }

  void passwordConfirmValidation() {
    if (state.password == state.passwordConfirm) {
      state =
          state.copyWith(passwordValidError: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          passwordValidError:
              const ResultFailResponseModel(errorMessage: '비밀번호가 일치하지 않습니다.'));
    }
  }

  void checkLoginId() async {
    loginIdValidation();

    if (state.loginIdError.errorMessage.isNotEmpty) {
      return;
    }

    final response = await ref
        .read(signupServiceProvider)
        .checkLoginId(loginId: state.loginId);

    if (response.statusCode == 200) {
      state = state.copyWith(
        loginIdValid: true,
        loginIdError: const ResultFailResponseModel(),
      );
    } else {
      final error = ResultFailResponseModel.fromJson(response.data);
      state = state.copyWith(
        loginIdError: error.copyWith(errorMessage: '이미 존재하는 아이디입니다.'),
      );
    }
  }

  void sendCode() async {
    final response = await ref
        .read(signupServiceProvider)
        .sendCode(email: '${state.email}@${state.domain}');

    if (response.statusCode == 200) {
      state = state.copyWith(
        emailStatus: SignupEmailStatus.push,
        isSendCode: true,
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void verifyCode() async {
    final response = await ref.read(signupServiceProvider).verifyCode(
        email: '${state.email}@${state.domain}', authCode: state.authCode);

    if (response.statusCode == 200) {
      state = state.copyWith(emailStatus: SignupEmailStatus.success);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void signUp() async {
    final response = await ref.read(signupServiceProvider).signUp({
      'identityVerificationId':
          ref.read(webViewNotifierProvider).identityVerificationId,
      'loginId': state.loginId,
      'password': state.password,
      'email': '${state.email}@${state.domain}',
    });

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final user = UserModel.fromJson(result.data);
      UserHive.set(user: user.copyWith(status: UserStatus.notEntry));

      state = state.copyWith(status: SignupStatus.step3);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void changeStatus() async {
    Response response = await ref
        .read(signupServiceProvider)
        .singleatResearchStatus({'status': (state.isSingleeatAgree) ? 1 : 0});

    if (response.statusCode != 200) {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
      return;
    }

    response = await ref
        .read(signupServiceProvider)
        .additionalServiceStatus({'status': (state.isAdditionalAgree) ? 1 : 0});

    if (response.statusCode == 200) {
      state = state.copyWith(status: SignupStatus.step4);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum SignupStatus {
  step1,
  step2,
  step3,
  step4,
  error,
}

enum SignupEmailStatus {
  init,
  push,
  success,
  error,
}

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(SignupStatus.step1) SignupStatus status,
    @Default(SignupEmailStatus.init) SignupEmailStatus emailStatus,
    @Default('') String loginId,
    @Default('') String password,
    @Default('') String passwordConfirm,
    @Default('') String email,
    @Default('') String domain,
    @Default('') String authCode,
    @Default(false) bool isSendCode,
    @Default(false) bool loginIdValid,
    @Default(false) bool isSingleeatAgree,
    @Default(false) bool isAdditionalAgree,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
    @Default(ResultFailResponseModel()) ResultFailResponseModel loginIdError,
    @Default(ResultFailResponseModel()) ResultFailResponseModel passwordError,
    @Default(ResultFailResponseModel())
    ResultFailResponseModel passwordValidError,
  }) = _SignupState;
}
