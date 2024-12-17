import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/services/bad_word_service.dart';

part 'bad_word_provider.freezed.dart';
part 'bad_word_provider.g.dart';

@Riverpod(keepAlive: true)
class BadWordNotifier extends _$BadWordNotifier {
  @override
  BadWordState build() {
    return const BadWordState();
  }

  void clear() {
    state = build();
  }

  void onChangeText(String text) {
    state = state.copyWith(text: text);
  }

  Future<void> checkBadWord(String text) async {
    final response = await ref.read(badWordServiceProvider).checkBadWord(text);
    state = state.copyWith(hasBadWord: response.data['data']);
  }
}

enum BadWordStatus {
  init,
  success,
  error,
}

@freezed
abstract class BadWordState with _$BadWordState {
  const factory BadWordState({
    @Default(BadWordStatus.init) BadWordStatus status,
    @Default('') String text,
    @Default(false) bool hasBadWord,
  }) = _BadWordState;

  factory BadWordState.fromJson(Map<String, dynamic> json) =>
      _$BadWordStateFromJson(json);
}
