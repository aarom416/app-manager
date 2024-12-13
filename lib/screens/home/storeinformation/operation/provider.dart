import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storeinformation/operation/service.dart';

import '../../../../core/components/snackbar.dart';
import 'model.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreInformationNotifier extends _$StoreInformationNotifier {
  @override
  StoreInformationState build() {
    return const StoreInformationState();
  }

  /// GET - 영업 정보 조회
  void getBusinessInformation() async {
    final response = await ref
        .read(storeInformationServiceProvider)
        .getBusinessInformation(storeId: UserHive.getBox(key: UserKey.storeId));

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final storeInformation = StoreInformationModel.fromJson(result.data);
      state = state.copyWith(
          status: StoreInformationStatus.success,
          storeInformation: storeInformation,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreInformationStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 사업자 정보 업데이트
  void updateBusinessInformation(int businessType) async {
    final response = await ref
        .read(storeInformationServiceProvider)
        .updateBusinessInformation(
            storeId: UserHive.getBox(key: UserKey.storeId),
            businessType: businessType);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      print(result);
    }
  }

  /// POST - 이메일 인증 코드 발송
  void sendEmailCode(String email) async {
    final response = await ref
        .read(storeInformationServiceProvider)
        .sendEmailCode(email: email);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      state = state.copyWith(
          status: StoreInformationStatus.success,
          isSendCode: true,
          error: const ResultFailResponseModel());
    }
  }

  /// POST - 이메일 인증 코드 확인
  Future<void> verifyEmailCode(String email, String authCode) async {
    final response = await ref
        .read(storeInformationServiceProvider)
        .verifyEmailCode(email: email, authCode: authCode);

    if (response.statusCode == 200) {
      state = state.copyWith(
          status: StoreInformationStatus.success,
          isSendCode: true,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreInformationStatus.error,
          isSendCode: false,
          error: const ResultFailResponseModel());
    }
  }
}

enum StoreInformationStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreInformationState with _$StoreInformationState {
  const factory StoreInformationState({
    @Default(StoreInformationStatus.init) StoreInformationStatus status,
    @Default('') String email,
    @Default('') String verifyCode,
    @Default(false) bool isSendCode,
    @Default(StoreInformationModel()) StoreInformationModel storeInformation,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreInformationState;

  factory StoreInformationState.fromJson(Map<String, dynamic> json) =>
      _$StoreInformationStateFromJson(json);
}
