import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/coupon_model.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/provider.dart';
import 'package:singleeat/screens/home/couponinformation/operation/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class CouponIssueNotifier extends _$CouponIssueNotifier {
  @override
  CouponIssueState build() {
    return const CouponIssueState();
  }

  void clear() {
    state = build();
  }

  /// POST - 쿠폰 발급
  Future<void> issueCoupon({
    Function? successCallback,
    Function? failCallback,
  }) async {
    if (!validateIssueCoupon()) {
      if (failCallback != null) {
        failCallback();
      }
      return;
    }

    final request = {
      "couponName": state.couponName,
      "discountType": state.discountType.name,
      "discountValue": state.discountValue,
      "discountLimit": state.discountType == DiscountType.percent
          ? state.discountLimit
          : state.discountValue,
      "minOrderAmount": state.minOrderAmount,
      "isDeliveryOrder": state.isDeliveryOrder,
      "isPickupOrder": state.isPickupOrder,
      "expiredYear": state.expiredYear,
      "expiredMonth": state.expiredMonth,
      "expiredDay": state.expiredDay,
    };

    final response = await ref
        .read(couponInformationServiceProvider)
        .issueCoupon(data: request);

    if (response.statusCode == 200) {
      final couponInformationProvider =
          ref.read(couponInformationNotifierProvider.notifier);

      couponInformationProvider.clear();
      couponInformationProvider.getCouponInformation();

      if (successCallback != null) {
        successCallback();
      }
    } else {
      state = state.copyWith(
        status: CouponIssueStatus.error,
        error: ResultFailResponseModel.fromJson(response.data),
      );

      if (failCallback != null) {
        failCallback();
      }
    }
  }

  bool validateIssueCoupon() {
    if (state.couponName.isEmpty) {
      return false;
    }

    if (state.discountValue == 0 || state.discountLimit == 0) {
      return false;
    }

    if (state.minOrderAmount < 5000 || state.minOrderAmount >= 50000) {
      return false;
    }

    if (state.isDeliveryOrder != 1 && state.isPickupOrder != 1) {
      return false;
    }

    if (state.expiredYear == 0 ||
        state.expiredMonth == 0 ||
        state.expiredDay == 0) {
      return false;
    }

    return true;
  }

  void onChangeCouponName(String couponName) {
    state = state.copyWith(couponName: couponName);
  }

  void onChangeDiscountType(DiscountType discountType) {
    state = state.copyWith(discountType: discountType);
  }

  void onChangeDiscountValue(int discountValue) {
    state = state.copyWith(discountValue: discountValue);
  }

  void onChangeDiscountLimit(int discountLimit) {
    state = state.copyWith(discountLimit: discountLimit);
  }

  void onChangeMinOrderAmount(int minOrderAmount) {
    state = state.copyWith(minOrderAmount: minOrderAmount);
  }

  void onChangeExpiredDate(DateTime date) {
    onChangeExpiredYear(date.year);
    onChangeExpiredMonth(date.month);
    onChangeExpiredDay(date.day);
  }

  void onChangeExpiredYear(int expiredYear) {
    state = state.copyWith(expiredYear: expiredYear);
  }

  void onChangeExpiredMonth(int expiredMonth) {
    state = state.copyWith(expiredMonth: expiredMonth);
  }

  void onChangeExpiredDay(int expiredDay) {
    state = state.copyWith(expiredDay: expiredDay);
  }

  void onChangeOrderType(OrderType orderType) {
    if (orderType == OrderType.all) {
      state = state.copyWith(
        isDeliveryOrder: 1,
        isPickupOrder: 1,
      );
    } else if (orderType == OrderType.delivery) {
      state = state.copyWith(
        isDeliveryOrder: 1,
        isPickupOrder: 0,
      );
    } else if (orderType == OrderType.takeout) {
      state = state.copyWith(
        isDeliveryOrder: 0,
        isPickupOrder: 1,
      );
    } else {
      throw ArgumentError('잘못된 OrderType 입니다.');
    }
  }
}

enum DiscountType {
  init('INIT'),
  percent('PERCENT'),
  amount('AMOUNT');

  final String name;

  const DiscountType(this.name);
}

enum CouponIssueStatus {
  init,
  success,
  error,
}

@freezed
abstract class CouponIssueState with _$CouponIssueState {
  const factory CouponIssueState({
    @Default('') String couponName,
    @Default(DiscountType.init) DiscountType discountType,
    @Default(0) int discountValue,
    @Default(0) int discountLimit,
    @Default(0) int minOrderAmount,
    @Default(0) int isDeliveryOrder,
    @Default(0) int isPickupOrder,
    @Default(0) int expiredYear,
    @Default(0) int expiredMonth,
    @Default(0) int expiredDay,
    @Default(CouponIssueStatus.init) CouponIssueStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _CouponIssueState;

  factory CouponIssueState.fromJson(Map<String, dynamic> json) =>
      _$CouponIssueStateFromJson(json);
}
