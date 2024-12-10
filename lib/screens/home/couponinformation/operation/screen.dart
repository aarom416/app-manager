import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/throttle.dart';
import 'package:singleeat/screens/coupon_issue_screen.dart';
import 'package:singleeat/screens/home/couponinformation/operation/model.dart';
import 'package:singleeat/screens/home/couponinformation/operation/provider.dart';

class CouponManagementScreen extends ConsumerStatefulWidget {
  const CouponManagementScreen({super.key});

  @override
  ConsumerState<CouponManagementScreen> createState() =>
      _CouponManagementScreenState();
}

class _CouponManagementScreenState
    extends ConsumerState<CouponManagementScreen> {
  final ScrollController scrollController = ScrollController();

  DateRange dateRange = DateRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  final throttle = Throttle(
    delay: const Duration(milliseconds: 300),
  );

  String currentDateRangeType = "월별";
  List<String> dateRangeType = ["월별", "기간 선택"];

  void initState() {
    super.initState();

    scrollController.addListener(loadMore);

    final state = ref.read(couponInformationNotifierProvider);
    Future.microtask(() {
      final provider = ref.read(couponInformationNotifierProvider.notifier);
      provider.clear();
      provider.getCouponInformation(
        startDate: dateRange.start.toShortDateStringWithZeroPadding,
        endDate: dateRange.end.toShortDateStringWithZeroPadding,
      );
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
      throttle.run(() => couponInformationProvider.getCouponInformation(
            startDate: dateRange.start.toShortDateStringWithZeroPadding,
            endDate: dateRange.end.toShortDateStringWithZeroPadding,
          ));
    }
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
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CouponIssueScreen()));
            },
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
                        ...dateRangeType.map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentDateRangeType = e;

                                  if (e == '월별') {
                                    dateRange = DateRange(
                                      start: DateTime(DateTime.now().year,
                                          DateTime.now().month, 1),
                                      end: DateTime(DateTime.now().year,
                                          DateTime.now().month + 1, 0),
                                    );
                                  } else {
                                    dateRange = DateRange(
                                      start: DateTime.now().subtract(
                                        const Duration(days: 1),
                                      ),
                                      end: DateTime.now(),
                                    );
                                  }
                                });
                              },
                              child: Row(children: [
                                if (e == currentDateRangeType)
                                  Image.asset("assets/images/checkbox-on.png",
                                      width: 24, height: 24)
                                else
                                  Image.asset("assets/images/checkbox-off.png",
                                      width: 24, height: 24),
                                SizedBox(width: SGSpacing.p1),
                                SGTypography.body(e,
                                    weight: FontWeight.w500,
                                    size: FontSize.normal),
                                SizedBox(width: SGSpacing.p6),
                              ]),
                            ))
                      ],
                    ),
                    SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                    if (currentDateRangeType == "기간 선택")
                      DateRangePicker(
                        dateRange: dateRange,
                        onStartDateChanged: (date) {
                          setState(() {
                            dateRange = dateRange.copyWith(start: date);
                          });
                        },
                        onEndDateChanged: (date) {
                          setState(() {
                            dateRange = dateRange.copyWith(end: date);
                          });
                        },
                      )
                    else
                      MonthlyRangePicker(
                          dateRange: dateRange,
                          onDateChanged: (datetime) {
                            final startDate = datetime.copyWith(day: 1);
                            final endDate = datetime
                                .copyWith(month: datetime.month + 1, day: 1)
                                .subtract(Duration(days: 1));
                            dateRange = dateRange.copyWith(
                                start: startDate, end: endDate);
                          }),
                    SizedBox(height: SGSpacing.p4),
                    GestureDetector(
                      onTap: () {
                        provider.onChangePage(0);
                        provider.onChangeHasMoreData(true);
                        provider.getCouponInformation(
                          startDate:
                              dateRange.start.toShortDateStringWithZeroPadding,
                          endDate:
                              dateRange.end.toShortDateStringWithZeroPadding,
                        );
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
                          .map((coupon) => _CouponCard(coupon: coupon))
                    ]),
              )),
            ],
          ),
        ));
  }
}

class _CouponCard extends StatelessWidget {
  final CouponInformationModel coupon;

  const _CouponCard({
    super.key,
    required this.coupon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => CouponDetailScreen(coupon: coupon)));
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
                SGTypography.body(coupon.couponName,
                    size: FontSize.small, weight: FontWeight.w700),
                SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p1),
                    color: SGColors.primary.withOpacity(0.1),
                    borderColor: Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                    child: SGTypography.body(createOrderTypeLabel(coupon),
                        color: SGColors.primary)),
              ],
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            if (coupon.discountType == 'AMOUNT')
              SGTypography.body("${coupon.discountValue.toKoreanCurrency}원 할인",
                  size: FontSize.large, weight: FontWeight.w700)
            else if (coupon.discountType == 'PERCENT')
              SGTypography.body("${coupon.discountValue}% 할인",
                  size: FontSize.large, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body(
              "최소 주문 금액 ${coupon.minOrderAmount.toKoreanCurrency}원 이상",
              size: FontSize.small,
              color: SGColors.gray4,
            ),
            if (coupon.discountType == 'PERCENT') ...[
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(
                "최대 할인 금액 ${coupon.discountLimit.toKoreanCurrency}원",
                size: FontSize.small,
                color: SGColors.gray4,
              ),
            ],
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
                "쿠폰 유효 기간 ${coupon.startDate} ~ ${coupon.expiredDate}",
                size: FontSize.small,
                color: Color(0xFFF26969),
                weight: FontWeight.w500),
          ],
        ),
      ),
    );
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
}
