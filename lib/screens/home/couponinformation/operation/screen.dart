import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/core/utils/throttle.dart';
import 'package:singleeat/screens/home/couponinformation/operation/model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/provider.dart';

class CouponInformationScreen extends ConsumerStatefulWidget {
  const CouponInformationScreen({super.key});

  @override
  ConsumerState<CouponInformationScreen> createState() =>
      _CouponInformationScreenState();
}

class _CouponInformationScreenState
    extends ConsumerState<CouponInformationScreen> {
  final ScrollController scrollController = ScrollController();

  final throttle = Throttle(
    delay: const Duration(milliseconds: 300),
  );

  List<String> dateRangeType = ["월별", "기간 선택"];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(loadMore);

    Future.microtask(() {
      final provider = ref.read(couponInformationNotifierProvider.notifier);
      provider.clear();
      provider.getCouponInformation();
    });
  }

  void loadMore() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final couponInformationState =
          ref.read(couponInformationNotifierProvider);
      // 마지막 조회한 페이지에서 데이터 없는 경우 더 조회하지 않음
      if (!couponInformationState.hasMoreData) {
        return;
      }

      final couponInformationProvider =
          ref.read(couponInformationNotifierProvider.notifier);
      final pageNumber = couponInformationState.page;

      couponInformationProvider.onChangePage(pageNumber + 1);
      throttle.run(() => couponInformationProvider.getCouponInformation());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(couponInformationNotifierProvider.notifier);
    final state = ref.watch(couponInformationNotifierProvider);

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "쿠폰 관리"),
        floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 36 + SGSpacing.p7),
          child: GestureDetector(
            onTap: () => ref.read(goRouterProvider).push(AppRoutes.couponIssue),
            child: SGContainer(
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p2),
              child: SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                width: double.infinity,
                borderColor: SGColors.primary,
                color: SGColors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                child: Center(
                    child: SGTypography.body("+   쿠폰 발급하기",
                        color: SGColors.primary,
                        size: FontSize.normal,
                        weight: FontWeight.w500)),
              ),
            ),
          ),
        ),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          child: Column(
            children: [
              SGContainer(
                  color: Colors.white,
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body("발행 내역",
                              weight: FontWeight.w600,
                              size: FontSize.small,
                              color: Color(0xFF5D5D5D)),
                        ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(
                      children: [
                        ...dateRangeType.map((selectedCurrentDateRangeType) =>
                            GestureDetector(
                              onTap: () {
                                provider.onChangeCurrentDateRangeType(
                                    selectedCurrentDateRangeType);

                                if (selectedCurrentDateRangeType == '월별') {
                                  provider.onChangeDateRange(
                                    DateRange(
                                      start: DateTime(DateTime.now().year,
                                          DateTime.now().month, 1),
                                      end: DateTime(DateTime.now().year,
                                          DateTime.now().month + 1, 0),
                                    ),
                                  );
                                } else {
                                  provider.onChangeDateRange(
                                    DateRange(
                                      start: DateTime.now().subtract(
                                        const Duration(days: 1),
                                      ),
                                      end: DateTime.now(),
                                    ),
                                  );
                                }
                              },
                              child: Row(children: [
                                if (state.currentDateRangeType ==
                                    selectedCurrentDateRangeType)
                                  Image.asset("assets/images/checkbox-on.png",
                                      width: 24, height: 24)
                                else
                                  Image.asset("assets/images/checkbox-off.png",
                                      width: 24, height: 24),
                                SizedBox(width: SGSpacing.p1),
                                SGTypography.body(selectedCurrentDateRangeType,
                                    weight: FontWeight.w500,
                                    size: FontSize.normal),
                                SizedBox(width: SGSpacing.p6),
                              ]),
                            ))
                      ],
                    ),
                    SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                    if (state.currentDateRangeType == "기간 선택")
                      DateRangePicker(
                        dateRange: state.dateRange!,
                        onStartDateChanged: (date) {
                          provider.onChangeDateRange(
                            state.dateRange!.copyWith(
                              start: date,
                            ),
                          );
                        },
                        onEndDateChanged: (date) {
                          provider.onChangeDateRange(
                            state.dateRange!.copyWith(
                              end: date,
                            ),
                          );
                        },
                      )
                    else
                      MonthlyRangePicker(
                          dateRange: state.dateRange!,
                          onDateChanged: (datetime) {
                            final startDate = datetime.copyWith(day: 1);
                            final endDate = datetime
                                .copyWith(month: datetime.month + 1, day: 1)
                                .subtract(const Duration(days: 1));

                            provider.onChangeDateRange(
                              state.dateRange!.copyWith(
                                start: startDate,
                                end: endDate,
                              ),
                            );
                          }),
                    SizedBox(height: SGSpacing.p4),
                    GestureDetector(
                      onTap: () {
                        provider.onChangePage(0);
                        provider.onChangeHasMoreData(true);
                        provider.getCouponInformation();
                      },
                      child: SGContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                        width: double.infinity,
                        color: SGColors.primary,
                        borderRadius: BorderRadius.circular(SGSpacing.p2),
                        child: Center(
                            child: SGTypography.body("조회",
                                color: Colors.white,
                                size: FontSize.normal,
                                weight: FontWeight.w700)),
                      ),
                    ),
                  ])),
              Expanded(
                  child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4)
                    .copyWith(top: SGSpacing.p4),
                    child: ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          ...state.couponInformationList
                              .map((coupon) => _CouponCard(coupon: coupon)),
                          Container(
                            height: 80,
                          )
                        ]),
                  )),
            ],
          ),
        ));
  }
}

class _CouponCard extends ConsumerStatefulWidget {
  final CouponInformationModel coupon;

  const _CouponCard({
    super.key,
    required this.coupon,
  });

  @override
  ConsumerState<_CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends ConsumerState<_CouponCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref
            .read(couponInformationNotifierProvider.notifier)
            .onChangeSelectedCoupon(widget.coupon);
        ref.read(goRouterProvider).push(AppRoutes.couponInformationDetail);
      },
      child: SGContainer(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SGSpacing.p4),
        padding: EdgeInsets.all(SGSpacing.p4),
        margin: EdgeInsets.only(bottom: SGSpacing.p4),
        boxShadow: SGBoxShadow.large,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SGTypography.body(widget.coupon.couponName,
                    size: FontSize.small, weight: FontWeight.w700),
                SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p1),
                    color: SGColors.primary.withOpacity(0.1),
                    borderColor: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                    child: SGTypography.body(
                        createOrderTypeLabel(widget.coupon),
                        color: SGColors.primary)),
              ],
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            if (widget.coupon.discountType == 'AMOUNT')
              SGTypography.body(
                  "${widget.coupon.discountValue.toKoreanCurrency}원 할인",
                  size: FontSize.large,
                  weight: FontWeight.w700)
            else if (widget.coupon.discountType == 'PERCENT')
              SGTypography.body("${widget.coupon.discountValue}% 할인",
                  size: FontSize.large, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body(
              "최소 주문 금액 ${widget.coupon.minOrderAmount.toKoreanCurrency}원 이상",
              size: FontSize.small,
              color: SGColors.gray4,
            ),
            if (widget.coupon.discountType == 'PERCENT') ...[
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(
                "최대 할인 금액 ${widget.coupon.discountLimit.toKoreanCurrency}원",
                size: FontSize.small,
                color: SGColors.gray4,
              ),
            ],
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
                "쿠폰 유효 기간 ${widget.coupon.startDate} ~ ${widget.coupon.expiredDate}",
                size: FontSize.small,
                color: Color(0xFFF26969),
                weight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}

String createOrderTypeLabel(CouponInformationModel coupon) {
  if (coupon.isDeliveryOrder == 1 && coupon.isPickupOrder == 1) {
    return '전부';
  } else if (coupon.isDeliveryOrder == 1) {
    return '배달';
  } else if (coupon.isPickupOrder == 1) {
    return '포장';
  } else {
    throw ArgumentError('isDeliverOrder 또는 isPickupOrder 파라미터가 유효하지 않습니다.');
  }
}
