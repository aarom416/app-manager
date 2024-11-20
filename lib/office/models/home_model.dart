import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_model.freezed.dart';
part 'home_model.g.dart';

enum HomeStatus {
  init, // 0 - 로그인 전
  success, // 200 성공 - 자동 로그인 성공 - 메인 페이지로 이동
  wait, // 202 성공 - 자동 로그인 성공 - 현재 입점 신청 대기 중인 페이지로 이동
  notEntry, // 206 성공 - 자동 로그인 성공 - 아직 입점 신청을 하지 않은 페이지로 이동
}

@freezed
abstract class NewsModel with _$NewsModel {
  const factory NewsModel({
    @Default(0) int type,
    @Default('') String title,
    @Default('') String newsURL,
    @Default('') String createdDate,
  }) = _NewsModel;

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
}

@freezed
abstract class HomeModel with _$HomeModel {
  const factory HomeModel({
    @Default(0) int storeId,
    @Default(0) int operationStatus,
    @Default(<NewsModel>[]) List<NewsModel> newsDTOList,
  }) = _HomeModel;

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);
}
