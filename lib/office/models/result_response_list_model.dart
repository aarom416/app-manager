import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_response_list_model.freezed.dart';
part 'result_response_list_model.g.dart';

@freezed
abstract class ResultResponseListModel with _$ResultResponseListModel {
  const factory ResultResponseListModel({
    @Default(false) bool success,
    @Default('') String message,
    @Default([]) List data,
  }) = _ResultResponseListModel;

  factory ResultResponseListModel.fromJson(Map<String, dynamic> json) =>
      _$ResultResponseListModelFromJson(json);
}
