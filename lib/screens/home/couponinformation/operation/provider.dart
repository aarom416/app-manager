import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class CouponInformationNotifier extends _$CouponInformationNotifier {
  @override
  CouponInformationState build() {
    return const CouponInformationState();
  }

  void clear() {
    state = build();
  }

  /// GET - 쿠폰 정보 조회
  void getCouponInformation({
    required String startDate,
    required String endDate,
  }) async {
    final queryParameter = {
      'startDate': startDate,
      'endDate': endDate,
    };
    final response = await ref
        .read(couponInformationServiceProvider)
        .getCouponInformation(
            storeId: UserHive.getBox(key: UserKey.storeId),
            page: state.page.toString(),
            queryParameters: queryParameter);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);
      final couponInformationList = result.data
          .map((coupon) => CouponInformationModel.fromJson(coupon))
          .toList();

      if (state.page == 0 && couponInformationList.isEmpty) {
        onChangeHasMoreData(false);
        state = state.copyWith(
          couponInformationList: couponInformationList,
          status: CouponInformationStatus.success,
          error: const ResultFailResponseModel(),
        );
      }

      if (result.data.isEmpty) {
        onChangeHasMoreData(false);
        return;
      }

      state = state.copyWith(
        couponInformationList: state.page == 0
            ? couponInformationList
            : [
                ...state.couponInformationList,
                ...couponInformationList,
              ],
        status: CouponInformationStatus.success,
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          status: CouponInformationStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeHasMoreData(bool hasMoreData) {
    state = state.copyWith(hasMoreData: hasMoreData);
  }

  void onChangeStoreId(String storeId) {
    state = state.copyWith(storeId: storeId);
  }

  void onChangePage(int page) {
    state = state.copyWith(page: page);
  }
}

enum CouponInformationStatus {
  init,
  success,
  error,
}

@freezed
abstract class CouponInformationState with _$CouponInformationState {
  const factory CouponInformationState({
    @Default(true) bool hasMoreData,
    @Default('') String storeId,
    @Default(0) int page,
    @Default(<CouponInformationModel>[])
    List<CouponInformationModel> couponInformationList,
    @Default(CouponInformationStatus.init) CouponInformationStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _CouponInformationState;

  factory CouponInformationState.fromJson(Map<String, dynamic> json) =>
      _$CouponInformationStateFromJson(json);
}
