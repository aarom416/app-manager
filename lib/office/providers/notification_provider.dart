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

  void clear() {
    state = build();
  }

  void loadNotification() async {
    final response = await ref
        .read(notificationServiceProvider)
        .loadNotification(page: state.page.toString());

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);

      if (result.data.isEmpty) {
        onChangeHasMoreData(false);
        return;
      }

      final notifications = result.data
          .map((notification) => NotificationModel.fromJson(notification))
          .toList();

      state = state.copyWith(
        notification: state.page == 0
            ? notifications
            : [
                ...state.notification,
                ...notifications,
              ],
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeHasMoreData(bool hasMoreData) {
    state = state.copyWith(hasMoreData: hasMoreData);
  }

  void onChangePage(int page) {
    state = state.copyWith(page: page);
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
    @Default(true) bool hasMoreData,
    @Default(0) int page,
    @Default(NotificationStatus.init) NotificationStatus status,
    @Default(<NotificationModel>[]) List<NotificationModel> notification,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _NotificationState;

  factory NotificationState.fromJson(Map<String, dynamic> json) =>
      _$NotificationStateFromJson(json);
}
