import 'package:flutter/material.dart';
import 'package:singleeat/accounting/models/settlement_model.dart';
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
import 'package:singleeat/screens/send_email_screen.dart';

class SettlementScreen extends StatefulWidget {
  const SettlementScreen({super.key});

  @override
  State<SettlementScreen> createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  String currentDateRangeType = "월별";
  List<String> dateRangeType = ["월별", "기간 선택"];

  DateRange dateRange = DateRange(start: DateTime.utc(2024, 1, 1), end: DateTime.utc(2024, 12, 31));

  List<SettlementModel> settlements = [
    SettlementModel(
        from: "싱그릿 식단 연구소",
        settlementType: "입금요청",
        createdAt: DateTime.utc(2024, 1, 2),
        settlementStartAt: DateTime.utc(2024, 1, 2),
        settlementEndAt: DateTime.utc(2024, 1, 31),
        amount: 100000,
        deliveryFee: 3000,
        settlementFee: 10000,
        commissionFee: 10000,
        tax: 10000),
    SettlementModel(
        from: "싱그릿 식단 연구소",
        settlementType: "입금요청",
        createdAt: DateTime.utc(2024, 2, 2),
        settlementStartAt: DateTime.utc(2024, 2, 2),
        settlementEndAt: DateTime.utc(2024, 2, 28),
        amount: 200000,
        deliveryFee: 3000,
        settlementFee: 30000,
        commissionFee: 20000,
        tax: 20000),
    SettlementModel(
        from: "싱그릿 식단 연구소",
        settlementType: "입금요청",
        createdAt: DateTime.utc(2024, 7, 2),
        settlementStartAt: DateTime.utc(2024, 7, 2),
        settlementEndAt: DateTime.utc(2024, 7, 31),
        amount: 40000,
        deliveryFee: 3000,
        settlementFee: 4000,
        commissionFee: 4000,
        tax: 4000),
    SettlementModel(
        from: "싱그릿 식단 연구소",
        settlementType: "입금완료",
        createdAt: DateTime.utc(2024, 8, 2),
        settlementStartAt: DateTime.utc(2024, 8, 2),
        settlementEndAt: DateTime.utc(2024, 8, 31),
        amount: 50000,
        deliveryFee: 3000,
        settlementFee: 5000,
        commissionFee: 5000,
        tax: 5000),
  ];

  List<SettlementModel> get filteredSettlements => settlements
      .where(
          (settlement) => settlement.createdAt.isAfter(dateRange.start) && settlement.createdAt.isBefore(dateRange.end))
      .toList();
  int get totalAmount => filteredSettlements.fold(0, (sum, settlement) => sum + settlement.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "정산"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          child: ListView(
            children: [
              SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4 + SGSpacing.p05, vertical: SGSpacing.p5),
                  color: SGColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SGTypography.body("입금 금액 (예정 포함)", size: FontSize.small, weight: FontWeight.w700),
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                      SGTypography.body("${totalAmount.toKoreanCurrency}원",
                          size: (FontSize.large + FontSize.xlarge) / 2, weight: FontWeight.w700),
                    ],
                  )),
              SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(top: SGSpacing.p6 + SGSpacing.p05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SGTypography.body("정산 내역",
                            color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SendEmailScreen()));
                          },
                          child: Row(children: [
                            Image.asset("assets/images/download.png", width: 15, height: 15),
                            SizedBox(width: (SGSpacing.p1 + SGSpacing.p2) / 2),
                            SGTypography.body("명세서 발급",
                                color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400),
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
                                  Image.asset("assets/images/checkbox-on.png", width: 24, height: 24)
                                else
                                  Image.asset("assets/images/checkbox-off.png", width: 24, height: 24),
                                SizedBox(width: SGSpacing.p1),
                                SGTypography.body(e, weight: FontWeight.w500, size: FontSize.normal),
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
                            final endDate =
                                datetime.copyWith(month: datetime.month + 1, day: 1).subtract(Duration(days: 1));
                            setState(() {
                              dateRange = dateRange.copyWith(start: startDate, end: endDate);
                            });
                          }),
                    ...filteredSettlements.map((settlement) => SettlementCard(settlement: settlement)).toList(),
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class SettlementCard extends StatelessWidget {
  final SettlementModel settlement;

  const SettlementCard({super.key, required this.settlement});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      margin: EdgeInsets.only(top: SGSpacing.p4),
      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      borderColor: SGColors.line2,
      width: double.infinity,
      color: SGColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SGTypography.body(settlement.createdAt.toShortDateStringWithoutZeroPadding,
              size: FontSize.small, weight: FontWeight.w500),
          SizedBox(height: SGSpacing.p4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body(settlement.from, color: SGColors.gray4, weight: FontWeight.w500, size: FontSize.small),
              SGContainer(
                  color: (settlement.settlementType == '입금요청' ? SGColors.primary : SGColors.success).withOpacity(0.08),
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p2, vertical: SGSpacing.p1),
                  borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                  child: SGTypography.body(settlement.settlementType,
                      weight: FontWeight.w500,
                      size: FontSize.small,
                      color: settlement.settlementType == '입금요청' ? SGColors.primary : SGColors.success))
            ],
          ),
          SizedBox(height: SGSpacing.p3),
          DataTableRow(
              left: "정산 기간",
              right:
                  "${settlement.settlementStartAt.toShortDateStringWithoutZeroPadding}(${settlement.settlementStartAt.weekDay}) ~ ${settlement.settlementEndAt.toShortDateStringWithoutZeroPadding}(${settlement.settlementEndAt.weekDay})"),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(left: "입금 금액", right: "${settlement.totalAmount.toKoreanCurrency}원"),
          SizedBox(height: SGSpacing.p5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SettlementDetailScreen(settlement: settlement)));
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p2),
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p3, horizontal: SGSpacing.p4),
                    child: Center(
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                      SGTypography.body("자세히", color: SGColors.primary, size: FontSize.small),
                    ]))),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SettlementDetailScreen extends StatelessWidget {
  final SettlementModel settlement;

  const SettlementDetailScreen({super.key, required this.settlement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "정산"),
      body: SGContainer(
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SGTypography.label("상세 내역"),
                SGTypography.body(settlement.createdAt.toShortDateTimeString,
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400),
              ],
            ),
            SizedBox(height: SGSpacing.p3),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                SGTypography.body("입금 금액", color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
                SizedBox(width: SGSpacing.p2),
                SGContainer(
                    color: (settlement.settlementType == '입금요청' ? SGColors.primary : SGColors.success).withOpacity(0.1),
                    padding: EdgeInsets.all(SGSpacing.p05),
                    borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                    child: SGTypography.body(settlement.settlementType.characters.toList().sublist(2).join(),
                        weight: FontWeight.w500,
                        size: FontSize.small,
                        color: settlement.settlementType == '입금요청' ? SGColors.primary : SGColors.success))
              ]),
              SGTypography.label("${settlement.totalAmount.toKoreanCurrency}원"),
            ]),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("1. 주문 중개(주문 금액)",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                SGTypography.body("${settlement.amount.toKoreanCurrency}원",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
              ]),
              SizedBox(height: SGSpacing.p4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("2. 배달 (가게 배달팁)",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                SGTypography.body("${settlement.deliveryFee.toKoreanCurrency}원",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
              ]),
              SizedBox(height: SGSpacing.p4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("3. 중개 이용료", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                SGTypography.body("${(-settlement.settlementFee).toKoreanCurrency}원",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
              ]),
              SizedBox(height: SGSpacing.p4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("4. 부가세", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                SGTypography.body("${(-settlement.commissionFee).toKoreanCurrency}원",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
              ]),
              SizedBox(height: SGSpacing.p4),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("5. 가게 할인 쿠폰", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                SGTypography.body("${(-settlement.tax).toKoreanCurrency}원",
                    color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
              ]),
              SizedBox(height: SGSpacing.p4),
              Divider(thickness: 1, color: SGColors.line1),
              SizedBox(height: SGSpacing.p4),
              Row(children: [
                Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGTypography.body(settlement.settlementType == '입금요청' ? "입금 예정 금액" : "입금 금액",
                      color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("(1+2+3+4+5)", color: SGColors.black, size: FontSize.tiny, weight: FontWeight.w700),
                ]),
                Spacer(),
                SGTypography.body("${settlement.totalAmount.toKoreanCurrency}원",
                    color: SGColors.black, size: FontSize.medium, weight: FontWeight.w700),
              ])
            ])
          ],
        ),
      ),
    );
  }
}
