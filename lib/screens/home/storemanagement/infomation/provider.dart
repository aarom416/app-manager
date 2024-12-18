import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/models/store_info_model.dart';
import 'package:singleeat/office/services/store_management_basic_info_service.dart';

import '../../../../main.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

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
      state = state.copyWith(
          storeInfo: storeInfo, error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  Future<bool> storePhone(String phone) async {
    StoreInfoModel storeInfo = state.storeInfo;
    storeInfo = storeInfo.copyWith(phone: phone);

    state = state.copyWith(storeInfo: storeInfo);

    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .storePhone(phone: state.storeInfo.phone);

    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  void onChangeStoreIntroduction(String introduction) async {
    StoreInfoModel storeInfo = state.storeInfo;
    storeInfo = storeInfo.copyWith(introduction: introduction);

    state = state.copyWith(storeInfo: storeInfo);
  }

  Future<void> storeIntroduction(
      {required Function successCallback,
      required Function errorCallback}) async {
    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .storeIntroduction(introduction: state.storeInfo.introduction);

    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel());

      successCallback();
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));

      await errorCallback(state.error.errorMessage);
    }
  }

  Future<bool> storeOriginInformation(String originInformation) async {
    StoreInfoModel storeInfo = state.storeInfo;
    storeInfo = storeInfo.copyWith(originInformation: originInformation);

    state = state.copyWith(storeInfo: storeInfo);

    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .storeOriginInformation(
            originInformation: state.storeInfo.originInformation);

    if (response.statusCode == 200) {
      state = state.copyWith(error: const ResultFailResponseModel());
      return true;
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
      return false;
    }
  }

  /// POST - 가게 로고 등록 및 변경
  void updateStoreThumbnail(String imagePath) async {
    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .updateStoreThumbnail(
          storeId: UserHive.getBox(key: UserKey.storeId),
          imagePath: imagePath,
        );

    // 응답을 받은 후 CDN 이미지 변경되는데 딜레이가 있어 state 변경 전 딜레이를 추가함
    // 필요 시 딜레이 시간 수정
    await Future.delayed(const Duration(milliseconds: 300));

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        logger.d("thumbnail: response.data ${response.data}");
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          String? thumbnail = responseData['data'] as String?;
          if (thumbnail != null) {
            state = state.copyWith(
              storeInfo: state.storeInfo.copyWith(
                thumbnail:
                    '$thumbnail?${DateTime.now().millisecondsSinceEpoch}',
              ),
              error: const ResultFailResponseModel(),
            );
            logger.d("new state ${state.toFormattedJson()}");
            return;
          }
        }
      }
    }

    state =
        state.copyWith(error: ResultFailResponseModel.fromJson(response.data));
  }

  /// POST - 가게 사진 등록 및 변경
  void updateStorePicture(List<String> imagePaths) async {
    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .updateStorePicture(
          storeId: UserHive.getBox(key: UserKey.storeId),
          imagePaths: imagePaths,
        );

    // 응답을 받은 후 CDN 이미지 변경되는데 딜레이가 있어 state 변경 전 딜레이를 추가함
    // 필요 시 딜레이 시간 수정
    await Future.delayed(const Duration(milliseconds: 300));

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        logger.d("storePictureURL1: response.data ${response.data}");
        final responseData = response.data as Map<String, dynamic>;
        var data = responseData['data'];
        if (data.isNotEmpty) {
          String? storePictureURL1 = data[data.keys.first] as String?;
          if (storePictureURL1 != null) {
            state = state.copyWith(
              storeInfo: state.storeInfo.copyWith(
                storePictureURL1:
                    '$storePictureURL1?${DateTime.now().millisecondsSinceEpoch}',
              ),
              error: const ResultFailResponseModel(),
            );
            logger.d("new state ${state.toFormattedJson()}");
            return;
          }
        }
      }
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  /// POST - 가게 소개 사진 등록 및 변경
  void updateIntroductionPicture(String imagePath) async {
    final response = await ref
        .read(storeManagementBasicInfoServiceProvider)
        .updateIntroductionPicture(
          storeId: UserHive.getBox(key: UserKey.storeId),
          imagePath: imagePath,
        );

    // 응답을 받은 후 CDN 이미지 변경되는데 딜레이가 있어 state 변경 전 딜레이를 추가함
    // 필요 시 딜레이 시간 수정
    await Future.delayed(const Duration(milliseconds: 300));

    if (response.statusCode == 200) {
      if (response.data is Map<String, dynamic>) {
        logger.d("storeInformationURL: response.data ${response.data}");
        final responseData = response.data as Map<String, dynamic>;
        if (responseData.containsKey('data')) {
          String? storeInformationURL = responseData['data'] as String?;
          if (storeInformationURL != null) {
            state = state.copyWith(
              storeInfo: state.storeInfo.copyWith(
                storeInformationURL:
                    '$storeInformationURL?${DateTime.now().millisecondsSinceEpoch}',
              ),
              error: const ResultFailResponseModel(),
            );
            logger.d("new state ${state.toFormattedJson()}");
            return;
          }
        }
      }
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
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
