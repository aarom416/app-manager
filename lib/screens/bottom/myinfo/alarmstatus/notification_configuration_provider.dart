import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/services/notification_configuration_service.dart';

part 'notification_configuration_provider.freezed.dart';
part 'notification_configuration_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationConfigurationNotifier
    extends _$NotificationConfigurationNotifier {
  @override
  NotificationConfigurationState build() {
    return const NotificationConfigurationState();
  }

  void resetState() {
    state = const NotificationConfigurationState();
  }

  void onChangeIsSingleeatAgree(bool isSingleeatAgree) {
    state = state.copyWith(isSingleatResearchStatus: isSingleeatAgree);
  }

  void onChangeIsAdditionalAgree(bool isAdditionalAgree) {
    state = state.copyWith(isAdditionalServiceStatus: isAdditionalAgree);
  }

  void notificationStatus() async {
    resetState();

    final storeId = UserHive.getBox(key: UserKey.storeId);
    final fcmTokenId = UserHive.getBox(key: UserKey.fcmTokenId);

    final response = await ref
        .read(notificationConfigurationServiceProvider)
        .notificationStatus(storeId: storeId, fcmTokenId: fcmTokenId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      state = state.copyWith(
        // 주문 알림 설정
        isOrderNotificationStatus:
            (result.data['orderNotificationStatus'] ?? 0) as int == 1
                ? true
                : false,
        // 소식 알림
        isSingleatResearchStatus:
            (result.data['singleatResearchStatus'] ?? 0) as int == 1
                ? true
                : false,
        // 혜택 알림
        isAdditionalServiceStatus:
            (result.data['additionalServiceStatus'] ?? 0) as int == 1
                ? true
                : false,
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void orderNotificationStatus(bool orderNotificationStatus) async {
    final fcmTokenId = UserHive.getBox(key: UserKey.fcmTokenId);

    final response = await ref
        .read(notificationConfigurationServiceProvider)
        .orderNotificationStatus(
            orderNotificationStatus: orderNotificationStatus ? 0 : 1,
            fcmTokenId: fcmTokenId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      state =
          state.copyWith(isOrderNotificationStatus: !orderNotificationStatus);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  Future<void> onChangeVolume({required double volume}) async {
    state = state.copyWith(
      volume: volume,
    );

    UserHive.set(
      user: UserHive.get().copyWith(
        volume: volume,
      ),
    );
  }

  void updateVolume() {
    state = state.copyWith(
      volume: UserHive.get().volume,
    );
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
    @Default(false) bool isOrderNotificationStatus,
    @Default(false) bool isSingleatResearchStatus,
    @Default(false) bool isAdditionalServiceStatus,
    @Default(0.0) double volume,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _NotificationConfigurationState;

  factory NotificationConfigurationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationConfigurationStateFromJson(json);
}
