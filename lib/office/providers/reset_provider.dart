import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/find_by_password_provider.dart';
import 'package:singleeat/office/providers/home_provider.dart';
import 'package:singleeat/office/providers/login_provider.dart';
import 'package:singleeat/office/providers/signup_provider.dart';

part 'reset_provider.freezed.dart';

part 'reset_provider.g.dart';

@Riverpod(keepAlive: true)
class ResetNotifier extends _$ResetNotifier {
  @override
  ResetState build() {
    return const ResetState();
  }
}

enum ResetStatus {
  init,
  success,
  error,
}

@freezed
abstract class ResetState with _$ResetState {
  const factory ResetState({
    @Default(ResetStatus.init) ResetStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _ResetState;

  factory ResetState.fromJson(Map<String, dynamic> json) =>
      _$ResetStateFromJson(json);
}
