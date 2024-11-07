import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'webview_provider.freezed.dart';
part 'webview_provider.g.dart';

@Riverpod(keepAlive: true)
class WebViewNotifier extends _$WebViewNotifier {
  @override
  WebViewState build() {
    return const WebViewState();
  }

  void onChangeHtml(String html) {
    state = state.copyWith(status: WebViewStatus.load, html: html);
  }

  void onChangeStatus(WebViewStatus status) {
    state = state.copyWith(status: status);
  }
}

enum WebViewStatus {
  init,
  load,
  success,
  error,
}

@freezed
abstract class WebViewState with _$WebViewState {
  const factory WebViewState({
    @Default(WebViewStatus.init) WebViewStatus status,
    @Default('') String html,
  }) = _WebViewState;

  factory WebViewState.fromJson(Map<String, dynamic> json) =>
      _$WebViewStateFromJson(json);
}
