import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'check_password_provider.freezed.dart';
part 'check_password_provider.g.dart';

@Riverpod(keepAlive: true)
class CheckPasswordNotifier extends _$CheckPasswordNotifier {
  @override
  CheckPasswordState build() {
    return const CheckPasswordState();
  }
}

enum CheckPasswordStatus {
  init,
  success,
  error,
}

@freezed
abstract class CheckPasswordState with _$CheckPasswordState {
  const factory CheckPasswordState({
    @Default(CheckPasswordStatus.init) CheckPasswordStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _CheckPasswordState;

  factory CheckPasswordState.fromJson(Map<String, dynamic> json) =>
      _$CheckPasswordStateFromJson(json);
}
