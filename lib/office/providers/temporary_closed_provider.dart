import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'temporary_closed_provider.freezed.dart';
part 'temporary_closed_provider.g.dart';

@Riverpod(keepAlive: true)
class TemporaryClosedNotifier extends _$TemporaryClosedNotifier {
  @override
  TemporaryClosedState build() {
    return const TemporaryClosedState();
  }
}

enum TemporaryClosedStatus {
  init,
  success,
  error,
}

@freezed
abstract class TemporaryClosedState with _$TemporaryClosedState {
  const factory TemporaryClosedState({
    @Default(TemporaryClosedStatus.init) TemporaryClosedStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _TemporaryClosedState;

  factory TemporaryClosedState.fromJson(Map<String, dynamic> json) =>
      _$TemporaryClosedStateFromJson(json);
}
