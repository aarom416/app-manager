import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_response_model.freezed.dart';
part 'result_response_model.g.dart';

@freezed
abstract class ResultResponseModel with _$ResultResponseModel {
  const factory ResultResponseModel({
    @Default(false) bool success,
    @Default('') String message,
    @Default({}) Map data,
  }) = _ResultResponseModel;

  factory ResultResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResultResponseModelFromJson(json);
}
