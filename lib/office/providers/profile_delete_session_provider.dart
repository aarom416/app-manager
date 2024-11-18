import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'profile_delete_session_provider.freezed.dart';
part 'profile_delete_session_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileDeleteSessionNotifier extends _$ProfileDeleteSessionNotifier {
  @override
  ProfileDeleteSessionState build() {
    return const ProfileDeleteSessionState();
  }
}

enum ProfileDeleteSessionStatus {
  init,
  success,
  error,
}

@freezed
abstract class ProfileDeleteSessionState with _$ProfileDeleteSessionState {
  const factory ProfileDeleteSessionState({
    @Default(ProfileDeleteSessionStatus.init) ProfileDeleteSessionStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _ProfileDeleteSessionState;

  factory ProfileDeleteSessionState.fromJson(Map<String, dynamic> json) =>
      _$ProfileDeleteSessionStateFromJson(json);
}
