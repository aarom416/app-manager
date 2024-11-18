import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'success_change_password_provider.freezed.dart';
part 'success_change_password_provider.g.dart';

@Riverpod(keepAlive: true)
class SuccessChangePasswordNotifier extends _$SuccessChangePasswordNotifier {
  @override
  SuccessChangePasswordState build() {
    return const SuccessChangePasswordState();
  }
}

enum SuccessChangePasswordStatus {
  init,
  success,
  error,
}

@freezed
abstract class SuccessChangePasswordState with _$SuccessChangePasswordState {
  const factory SuccessChangePasswordState({
    @Default(SuccessChangePasswordStatus.init)
    SuccessChangePasswordStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _SuccessChangePasswordState;

  factory SuccessChangePasswordState.fromJson(Map<String, dynamic> json) =>
      _$SuccessChangePasswordStateFromJson(json);
}
