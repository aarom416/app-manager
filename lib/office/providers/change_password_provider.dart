import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'change_password_provider.freezed.dart';
part 'change_password_provider.g.dart';

@Riverpod(keepAlive: true)
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  @override
  ChangePasswordState build() {
    return const ChangePasswordState();
  }
}

enum ChangePasswordStatus {
  init,
  success,
  error,
}

@freezed
abstract class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default(ChangePasswordStatus.init) ChangePasswordStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _ChangePasswordState;

  factory ChangePasswordState.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordStateFromJson(json);
}
