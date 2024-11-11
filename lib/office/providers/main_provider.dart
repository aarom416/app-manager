import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_provider.freezed.dart';

part 'main_provider.g.dart';

@Riverpod(keepAlive: true)
class MainNotifier extends _$MainNotifier {
  @override
  MainState build() {
    return const MainState();
  }
}

enum MainStatus {
  init,
  success,
  error,
}

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default(MainStatus.init) MainStatus status,
  }) = _MainState;

  factory MainState.fromJson(Map<String, dynamic> json) =>
      _$MainStateFromJson(json);
}
