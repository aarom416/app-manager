import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/providers/find_by_password_provider.dart';

part 'find_by_password_webview_provider.freezed.dart';
part 'find_by_password_webview_provider.g.dart';

@Riverpod(keepAlive: true)
class FindByPasswordWebViewNotifier extends _$FindByPasswordWebViewNotifier {
  @override
  FindByPasswordWebViewState build() {
    return const FindByPasswordWebViewState();
  }

  void onChangeHtml({required String html}) {
    state = state.copyWith(html: html);
  }

  void onChangeIdentityVerificationId(String identityVerificationId) {
    state = state.copyWith(identityVerificationId: identityVerificationId);
  }

  void reset() {
    state = const FindByPasswordWebViewState();
  }

  void onChangeStatus(FindByPasswordWebViewStatus status) {
    state = state.copyWith(status: status);
  }

  bool onClick() {
    if (state.status == FindByPasswordWebViewStatus.success) {
      ref
          .read(findByPasswordNotifierProvider.notifier)
          .onChangeStatus(FindByPasswordStatus.step3);
      return true;
    } else {
      return false;
    }
  }
}

enum FindByPasswordWebViewStatus {
  init,
  success,
  error,
}

@freezed
abstract class FindByPasswordWebViewState with _$FindByPasswordWebViewState {
  const factory FindByPasswordWebViewState({
    @Default(FindByPasswordWebViewStatus.init)
    FindByPasswordWebViewStatus status,
    @Default('') String html,
    @Default('') String identityVerificationId,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _FindByPasswordWebViewState;

  factory FindByPasswordWebViewState.fromJson(Map<String, dynamic> json) =>
      _$FindByPasswordWebViewStateFromJson(json);
}
