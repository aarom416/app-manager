import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/services/find_by_password_service.dart';

part 'find_by_password_provider.freezed.dart';
part 'find_by_password_provider.g.dart';

@Riverpod(keepAlive: true)
class FindByPasswordNotifier extends _$FindByPasswordNotifier {
  @override
  FindByPasswordState build() {
    return const FindByPasswordState();
  }

  void findPassword() async {
    final response = await ref
        .read(findByPasswordServiceProvider)
        .findPassword(loginId: state.loginId);

    switch (response.statusCode) {
      case 200:
        state = state.copyWith(status: FindByPasswordStatus.success);

        // 비밀번호 찾기
        ref
            .read(authenticateWithPhoneNumberNotifierProvider.notifier)
            .onChangeMethod(AuthenticateWithPhoneNumberMethod.PASSWORD);
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

  void onChangeStatus(FindByPasswordStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangeLoginId(String loginId) {
    state = state.copyWith(status: FindByPasswordStatus.init, loginId: loginId);
  }
}

enum FindByPasswordStatus {
  init,
  notFound,
  success,
  error,
}

@freezed
abstract class FindByPasswordState with _$FindByPasswordState {
  const factory FindByPasswordState({
    @Default(FindByPasswordStatus.init) FindByPasswordStatus status,
    @Default('') String loginId,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _FindByPasswordState;

  factory FindByPasswordState.fromJson(Map<String, dynamic> json) =>
      _$FindByPasswordStateFromJson(json);
}
