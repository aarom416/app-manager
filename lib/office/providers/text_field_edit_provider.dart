import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'text_field_edit_provider.freezed.dart';
part 'text_field_edit_provider.g.dart';

@Riverpod(keepAlive: true)
class TextFieldEditNotifier extends _$TextFieldEditNotifier {
  @override
  TextFieldEditState build() {
    return const TextFieldEditState();
  }

  void clear() {
    state = build();
  }

  void onChangeButton(bool isButton) {
    state = state.copyWith(isButton: isButton);
  }
}

enum TextFieldEditStatus {
  init,
  success,
  error,
}

@freezed
abstract class TextFieldEditState with _$TextFieldEditState {
  const factory TextFieldEditState({
    @Default(TextFieldEditStatus.init) TextFieldEditStatus status,
    @Default(false) bool isButton,
  }) = _TextFieldEditState;

  factory TextFieldEditState.fromJson(Map<String, dynamic> json) =>
      _$TextFieldEditStateFromJson(json);
}
