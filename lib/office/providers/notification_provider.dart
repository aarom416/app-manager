import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/notification_model.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/office/services/notification_service.dart';

part 'notification_provider.freezed.dart';
part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationNotifier extends _$NotificationNotifier {
  @override
  NotificationState build() {
    return const NotificationState();
  }

  void loadNotification() async {
    final response =
        await ref.read(notificationServiceProvider).loadNotification();

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);

      state = state.copyWith(
        notification: [
          ...result.data.map((item) => NotificationModel.fromJson(item))
        ],
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum NotificationStatus {
  init,
  success,
  error,
}

@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default(NotificationStatus.init) NotificationStatus status,
    @Default(<NotificationModel>[]) List<NotificationModel> notification,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _NotificationState;

  factory NotificationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationStateFromJson(json);
}
