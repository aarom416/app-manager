import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserStatus {
  init, // 0 - 로그인 전
  success, // 200 성공 - 자동 로그인 성공 - 메인 페이지로 이동
  wait, // 202 성공 - 자동 로그인 성공 - 현재 입점 신청 대기 중인 페이지로 이동
  notEntry, // 206 성공 - 자동 로그인 성공 - 아직 입점 신청을 하지 않은 페이지로 이동
}

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    @Default(UserStatus.init) UserStatus status,
    @Default('') String loginId,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String accessToken,
    @Default('') String refreshToken,
    @Default(0.5) double volume,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
