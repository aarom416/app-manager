import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreHistoryStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreHistoryModel with _$StoreHistoryModel {
  const factory StoreHistoryModel({
    @Default(0) int type,
    @Default('') String content,
    @Default('') String previousDate,
    @Default('') String createdDate,
  }) = _StoreHistoryModel;

  factory StoreHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryModelFromJson(json);
}