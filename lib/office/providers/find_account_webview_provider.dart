import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'find_account_webview_provider.freezed.dart';
part 'find_account_webview_provider.g.dart';

@Riverpod(keepAlive: true)
class FindAccountWebViewNotifier extends _$FindAccountWebViewNotifier {
  @override
  FindAccountWebViewState build() {
    return const FindAccountWebViewState();
  }

  void onChangeHtml({required String html}) {
    state = state.copyWith(html: html);
  }

  void onChangeIdentityVerificationId(String identityVerificationId) {
    state = state.copyWith(identityVerificationId: identityVerificationId);
  }

  void reset() {
    state = const FindAccountWebViewState();
  }

  void onChangeStatus(FindAccountWebViewStatus status) {
    state = state.copyWith(status: status);
  }
}

enum FindAccountWebViewStatus {
  init,
  success,
  error,
}

@freezed
abstract class FindAccountWebViewState with _$FindAccountWebViewState {
  const factory FindAccountWebViewState({
    @Default(FindAccountWebViewStatus.init) FindAccountWebViewStatus status,
    @Default('') String html,
    @Default('') String identityVerificationId,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _FindAccountWebViewState;

  factory FindAccountWebViewState.fromJson(Map<String, dynamic> json) =>
      _$FindAccountWebViewStateFromJson(json);
}
