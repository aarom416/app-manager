import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/bottom/myinfo/profile_service.dart';

part 'profile_provider.freezed.dart';
part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  void totalOrderAmount() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(profileServiceProvider)
        .totalOrderAmount(storeId: storeId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      int deliveryTotalOrderAmount =
          (result.data['deliveryTotalOrderAmount'] ?? 0) as int;
      int pickupTotalOrderAmount =
          (result.data['pickupTotalOrderAmount'] ?? 0) as int;

      state = state.copyWith(
        totalAmount: deliveryTotalOrderAmount + pickupTotalOrderAmount,
        deliveryTotalOrderAmount: deliveryTotalOrderAmount,
        pickupTotalOrderAmount: pickupTotalOrderAmount,
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum ProfileStatus {
  init,
  success,
  error,
}

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileStatus.init) ProfileStatus status,
    @Default(0) int deliveryTotalOrderAmount,
    @Default(0) int pickupTotalOrderAmount,
    @Default(0) int totalAmount,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _ProfileState;

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);
}
