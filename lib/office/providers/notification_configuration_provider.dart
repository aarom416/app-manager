import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'notification_configuration_provider.freezed.dart';
part 'notification_configuration_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationConfigurationNotifier
    extends _$NotificationConfigurationNotifier {
  @override
  NotificationConfigurationState build() {
    return const NotificationConfigurationState();
  }
}

enum NotificationConfigurationStatus {
  init,
  success,
  error,
}

@freezed
abstract class NotificationConfigurationState
    with _$NotificationConfigurationState {
  const factory NotificationConfigurationState({
    @Default(NotificationConfigurationStatus.init)
    NotificationConfigurationStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _NotificationConfigurationState;

  factory NotificationConfigurationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationConfigurationStateFromJson(json);
}
