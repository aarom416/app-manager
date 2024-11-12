import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationStatus {
  init,
  success,
  error,
}

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @Default('') String title,
    @Default('') String body,
    @Default('') String createDate,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
