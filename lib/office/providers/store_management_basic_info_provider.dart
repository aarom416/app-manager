import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/models/store_info_model.dart';
import 'package:singleeat/office/services/store_management_basic_info_service.dart';

part 'store_management_basic_info_provider.freezed.dart';
part 'store_management_basic_info_provider.g.dart';

@Riverpod(keepAlive: true)
class StoreManagementBasicInfoNotifier
    extends _$StoreManagementBasicInfoNotifier {
  @override
  StoreManagementBasicInfoState build() {
    return const StoreManagementBasicInfoState();
  }

  void storeInfo() async {
    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .storeInfo(storeId: UserHive.getBox(key: UserKey.storeId));

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final storeInfo = StoreInfoModel.fromJson(result.data);
      state = state.copyWith(storeInfo: storeInfo);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeStoreInfoByPhone(String phone) {
    StoreInfoModel storeInfo = state.storeInfo;
    storeInfo = storeInfo.copyWith(phone: phone);

    state = state.copyWith(storeInfo: storeInfo);
  }

  void onChangeStoreInfoByIntroduction(String introduction) {
    StoreInfoModel storeInfo = state.storeInfo;
    storeInfo = storeInfo.copyWith(introduction: introduction);

    state = state.copyWith(storeInfo: storeInfo);
  }
}

enum StoreManagementBasicInfoStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreManagementBasicInfoState
    with _$StoreManagementBasicInfoState {
  const factory StoreManagementBasicInfoState({
    @Default(StoreManagementBasicInfoStatus.init)
    StoreManagementBasicInfoStatus status,
    @Default(StoreInfoModel()) StoreInfoModel storeInfo,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreManagementBasicInfoState;

  factory StoreManagementBasicInfoState.fromJson(Map<String, dynamic> json) =>
      _$StoreManagementBasicInfoStateFromJson(json);
}
