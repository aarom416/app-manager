import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/service.dart';

import '../../../../core/components/snackbar.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class CouponInformationNotifier extends _$CouponInformationNotifier {
  @override
  CouponInformationState build() {
    return CouponInformationState(
      dateRange: DateRange(
        start: DateTime(DateTime.now().year, DateTime.now().month, 1),
        end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      ),
    );
  }

  void clear() {
    state = build();
  }

  /// GET - 쿠폰 정보 조회
  void getCouponInformation() async {
    final queryParameter = {
      'startDate': state.dateRange!.start.toShortDateStringWithZeroPadding,
      'endDate': state.dateRange!.end.toShortDateStringWithZeroPadding,
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

  /// DELETE - 쿠폰 정보 삭제
  Future<void> deleteIssuedCoupon({
    Function? successCallback,
    Function? failCallback,
  }) async {
    final response = await ref
        .read(couponInformationServiceProvider)
        .deleteIssuedCoupon(couponId: state.selectedCoupon.couponId.toString());

    if (response.statusCode == 200) {
      state = state.copyWith(
        couponInformationList: state.couponInformationList
            .where(
              (coupon) => coupon.couponId != state.selectedCoupon.couponId,
            )
            .toList(),
        selectedCoupon: const CouponInformationModel(),
        status: CouponInformationStatus.success,
        error: const ResultFailResponseModel(),
      );

      if (successCallback != null) {
        successCallback();
      }

    } else {
      state = state.copyWith(
        status: CouponInformationStatus.error,
        error: ResultFailResponseModel.fromJson(response.data),
      );

      if (failCallback != null) {
        failCallback();
      }
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

  void onChangeSelectedCoupon(CouponInformationModel selectedCoupon) {
    state = state.copyWith(selectedCoupon: selectedCoupon);
  }

  void prependIssuedCoupon(CouponInformationModel couponIssue) {
    final copiedCouponInformationList = state.couponInformationList.toList();
    copiedCouponInformationList.insert(0, couponIssue);
    state = state.copyWith(couponInformationList: copiedCouponInformationList);
  }

  void onChangeDateRange(DateRange dateRange) {
    state = state.copyWith(dateRange: dateRange);
  }

  void onChangeCurrentDateRangeType(String currentDateRangeType) {
    state = state.copyWith(currentDateRangeType: currentDateRangeType);
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
    DateRange? dateRange,
    @Default('월별') String currentDateRangeType,
    @Default(true) bool hasMoreData,
    @Default('') String storeId,
    @Default(0) int page,
    @Default(CouponInformationModel()) CouponInformationModel selectedCoupon,
    @Default(<CouponInformationModel>[])
    List<CouponInformationModel> couponInformationList,
    @Default(CouponInformationStatus.init) CouponInformationStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _CouponInformationState;
}
