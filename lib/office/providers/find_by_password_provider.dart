import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/services/find_by_password_service.dart';

part 'find_by_password_provider.freezed.dart';

part 'find_by_password_provider.g.dart';

@Riverpod(keepAlive: true)
class FindByPasswordNotifier extends _$FindByPasswordNotifier {
  @override
  FindByPasswordState build() {
    return const FindByPasswordState();
  }

  void onChangeStatus(FindByPasswordStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  void onChangePasswordConfirm(String passwordConfirm) {
    state = state.copyWith(passwordConfirm: passwordConfirm);
  }

  void findPassword() async {
    final response = await ref
        .read(findByPasswordServiceProvider)
        .findPassword(loginId: state.loginId);

    switch (response.statusCode) {
      case 200:
        state = state.copyWith(status: FindByPasswordStatus.step2);
        break;
      case 404:
      default:
        final error = ResultFailResponseModel.fromJson(response.data);
        state = state.copyWith(
            status: FindByPasswordStatus.error,
            error: error.copyWith(errorMessage: '해당 아이디로 가입된\n사실이 없습니다'));
        break;
    }
  }

  void onChangeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId);
  }

  void updatePassword() async {
    final response =
        await ref.read(findByPasswordServiceProvider).updatePassword(
              loginId: state.loginId,
              password: state.password,
            );

    if (response.statusCode == 200) {
      state = state.copyWith(status: FindByPasswordStatus.step4);
    } else {
      state = state.copyWith(
          status: FindByPasswordStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum FindByPasswordStatus {
  step1,
  step2,
  step3,
  step4,
  error,
}

@freezed
abstract class FindByPasswordState with _$FindByPasswordState {
  const factory FindByPasswordState({
    @Default(FindByPasswordStatus.step1) FindByPasswordStatus status,
    @Default('') String loginId,
    @Default('') String password,
    @Default('') String passwordConfirm,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _FindByPasswordState;

  factory FindByPasswordState.fromJson(Map<String, dynamic> json) =>
      _$FindByPasswordStateFromJson(json);
}
