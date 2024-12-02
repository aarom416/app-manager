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
    @Default('') String ownerPhoneNumber, // 휴대폰 번호
    @Default('') String ownerEmail, // 이메일
  }) = _StoreHistoryModel;

  factory StoreHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoreHistoryModelFromJson(json);
}
