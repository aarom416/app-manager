import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storesettlement/email/screen.dart';
import 'package:singleeat/screens/home/storesettlement/operation/provider.dart';

import 'model.dart';

class SettlementScreen extends ConsumerStatefulWidget {
  const SettlementScreen({super.key});

  @override
  ConsumerState<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends ConsumerState<SettlementScreen> {
  String currentDateRangeType = "월별";
  List<String> dateRangeType = ["월별", "기간 선택"];

  DateRange dateRange = DateRange(
    start: DateTime(DateTime.now().year, DateTime.now().month, 1),
    end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
  );

  @override
  void initState() {
    dateRange = DateRange(
      start: DateTime(DateTime.now().year, DateTime.now().month, 1),
      end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    );
    Future.microtask(() {
      ref.read(storeSettlementNotifierProvider.notifier).onChangeMonth(
        context: context,
        startDate: dateRange.start.toShortDateStringWithZeroPadding,
        endDate: dateRange.end.toShortDateStringWithZeroPadding);
      ref.read(storeSettlementNotifierProvider.notifier).getSettlementInfo(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeSettlementNotifierProvider);
    final provider = ref.read(storeSettlementNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "정산"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          child: ListView(
            children: [
              SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4 + SGSpacing.p05,
                      vertical: SGSpacing.p5),
                  color: SGColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SGTypography.body("입금 금액 (예정 포함)",
                          size: FontSize.small, weight: FontWeight.w700),
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                      SGTypography.body(
                          "${state.storeSettlement.totalSettlementAmount.toKoreanCurrency}원",
                          size: (FontSize.large + FontSize.xlarge) / 2,
                          weight: FontWeight.w700),
                    ],
                  )),
              SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4)
                    .copyWith(top: SGSpacing.p6 + SGSpacing.p05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SGTypography.body("정산 내역",
                            color: SGColors.black,
                            weight: FontWeight.w700,
                            size: FontSize.normal),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SendEmailScreen(
                                      callScreen: 1,
                                    )));
                          },
                          child: Row(children: [
                            Image.asset("assets/images/download.png",
                                width: 15, height: 15),
                            SizedBox(width: (SGSpacing.p1 + SGSpacing.p2) / 2),
                            SGTypography.body("명세서 발급",
                                color: SGColors.gray4,
                                size: FontSize.small,
                                weight: FontWeight.w400),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(height: SGSpacing.p4),
                    Row(
                      children: [
                        ...dateRangeType.map((e) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentDateRangeType = e;
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
                            provider.onChangeStartDate(
                                startDate: dateRange
                                    .start.toShortDateStringWithZeroPadding);
                          });
                        },
                        onEndDateChanged: (date) {
                          setState(() {
                            dateRange = dateRange.copyWith(end: date);
                            provider.onChangeEndDate(
                              context: context,
                                endDate: dateRange
                                    .end.toShortDateStringWithZeroPadding);
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
                            setState(() {
                              dateRange = dateRange.copyWith(
                                  start: startDate, end: endDate);
                              provider.onChangeMonth(
                                context: context,
                                startDate: dateRange
                                    .start.toShortDateStringWithZeroPadding,
                                endDate: dateRange
                                    .end.toShortDateStringWithZeroPadding);
                            });
                          }),
                    ...state.storeSettlement.responseSettlementDTOList
                        .map((settlement) =>
                            SettlementCard(settlement: settlement))
                        .toList(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class SettlementCard extends StatelessWidget {
  final ResponseSettlementDTO settlement;
  const SettlementCard({super.key, required this.settlement});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      margin: EdgeInsets.only(top: SGSpacing.p4),
      padding: EdgeInsets.symmetric(
          horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      borderColor: SGColors.line2,
      width: double.infinity,
      color: SGColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SGTypography.body(settlement.settlementDate,
              size: FontSize.small, weight: FontWeight.w500),
          SizedBox(height: SGSpacing.p4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body("싱그릿 식단 연구소",
                  color: SGColors.gray4,
                  weight: FontWeight.w500,
                  size: FontSize.small),
              SGContainer(
                  color: (settlement.settlementStatus == '입금요청'
                          ? SGColors.primary
                          : SGColors.success)
                      .withOpacity(0.08),
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p2, vertical: SGSpacing.p1),
                  borderRadius:
                      BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                  child: SGTypography.body(settlement.settlementStatus,
                      weight: FontWeight.w500,
                      size: FontSize.small,
                      color: settlement.settlementStatus == '입금요청'
                          ? SGColors.primary
                          : SGColors.success))
            ],
          ),
          SizedBox(height: SGSpacing.p3),
          DataTableRow(
              left: "정산 기간",
              right:
                  "${settlement.settlementStartDate} ~ ${settlement.settlementEndDate})"),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "입금 금액",
              right: "${settlement.settlementAmount.toKoreanCurrency}원"),
          SizedBox(height: SGSpacing.p5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SettlementDetailScreen(settlement: settlement)));
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p2),
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p3, horizontal: SGSpacing.p4),
                    child: Center(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                      SGTypography.body("자세히",
                          color: SGColors.primary, size: FontSize.small),
                    ]))),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SettlementDetailScreen extends StatefulWidget {
  final ResponseSettlementDTO settlement;

  const SettlementDetailScreen({super.key, required this.settlement});

  @override
  State<SettlementDetailScreen> createState() => _SettlementDetailScreenState();
}

class _SettlementDetailScreenState extends State<SettlementDetailScreen> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVisible = false;
        });
      },
      child: Scaffold(
        appBar: AppBarWithLeftArrow(title: "정산"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: Stack(
            children: [
              ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SGTypography.label("상세 내역"),
                      SGTypography.body(widget.settlement.settlementDate,
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w400),
                    ],
                  ),
                  SizedBox(height: SGSpacing.p3),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      SGTypography.body("입금 금액",
                          color: SGColors.gray4,
                          size: FontSize.normal,
                          weight: FontWeight.w400),
                      SizedBox(width: SGSpacing.p2),
                      SGContainer(
                          color: (widget.settlement.settlementStatus == '입금요청'
                              ? SGColors.primary
                              : SGColors.success)
                              .withOpacity(0.1),
                          padding: EdgeInsets.all(SGSpacing.p05),
                          borderRadius:
                          BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                          child: SGTypography.body(
                              widget.settlement.settlementStatus.characters
                                  .toList()
                                  .sublist(2)
                                  .join(),
                              weight: FontWeight.w500,
                              size: FontSize.small,
                              color: widget.settlement.settlementStatus == '입금요청'
                                  ? SGColors.primary
                                  : SGColors.success))
                    ]),
                    SGTypography.label(
                        "${widget.settlement.settlementAmount.toKoreanCurrency}원"),
                  ]),
                  SizedBox(height: SGSpacing.p3),
                  MultipleInformationBox(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("1. 주문 중개(주문 금액)",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                      SGTypography.body("${widget.settlement.orderAmount.toKoreanCurrency}원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("2. 배달 (가게 배달팁)",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                      SGTypography.body("${widget.settlement.deliveryTip.toKoreanCurrency}원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(
                        children: [
                          SGTypography.body("3. 중개 이용료",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500),
                          SizedBox(
                            width: SGSpacing.p05,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                              child: Icon(Icons.help_outline, size: SGSpacing.p4, color: SGColors.gray4)),
                        ],
                      ),
                      SGTypography.body("${(-widget.settlement.agentFee).toKoreanCurrency}원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("4. 부가세",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                      SGTypography.body(
                          "${(-widget.settlement.agentFeeTax).toKoreanCurrency}원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("5. 가게 할인 쿠폰",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                      SGTypography.body(
                          "${(-widget.settlement.storeCouponDiscount).toKoreanCurrency}원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Divider(thickness: 1, color: SGColors.line1),
                    SizedBox(height: SGSpacing.p4),
                    Row(children: [
                      Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SGTypography.body(
                                widget.settlement.settlementStatus == '입금요청'
                                    ? "입금 예정 금액"
                                    : "입금 금액",
                                color: SGColors.black,
                                size: FontSize.normal,
                                weight: FontWeight.w700),
                            SizedBox(height: SGSpacing.p2),
                            SGTypography.body("(1+2+3+4+5)",
                                color: SGColors.black,
                                size: FontSize.tiny,
                                weight: FontWeight.w700),
                          ]),
                      Spacer(),
                      SGTypography.body(
                          "${widget.settlement.settlementAmount.toKoreanCurrency}원",
                          color: SGColors.black,
                          size: FontSize.medium,
                          weight: FontWeight.w700),
                    ])
                  ])
                ],
              ),
              Positioned(
                top: SGSpacing.p32 + SGSpacing.p9,
                left: SGSpacing.p2,
                child: AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _isVisible
                      ? Container(
                        padding: EdgeInsets.all(SGSpacing.p3),
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SGTypography.body(
                              "중개 이용료는 결제 대행 수수료(PG사)와 중개 수수료(싱그릿)를 더한 금액입니다.",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(height: SGSpacing.p2),
                            SGTypography.body(
                              "[결제 대행 수수료(PG) 안내]\n\n"
                                  " - 신용/체크카드 : 결제금액의 3.2%\n\n"
                                  " - 카카오페이 : 결제금액의 3.2%\n\n"
                                  " - 토스페이 : 결제금액의 3.2%\n\n"
                                  " - 네이버페이 : 결제금액의 3.3%\n",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(height: SGSpacing.p2),
                            SGTypography.body(
                              "[중개 수수료(싱그릿) 안내]\n\n"
                                  " - 중개 수수료 : 중개 금액의 5.5%",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                            ),
                          ],
                        ),
                      )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}









