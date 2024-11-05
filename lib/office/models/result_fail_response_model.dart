import 'package:freezed_annotation/freezed_annotation.dart';

part 'result_fail_response_model.freezed.dart';
part 'result_fail_response_model.g.dart';

@freezed
abstract class ResultFailResponseModel with _$ResultFailResponseModel {
  const factory ResultFailResponseModel({
    @Default(true) bool success,
    @Default('') String errorCode,
    @Default('') String errorMessage,
  }) = _ResultFailResponseModel;

  factory ResultFailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResultFailResponseModelFromJson(json);
}
