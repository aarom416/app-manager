import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/menu_tab_bar.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/extensions/string.dart';
import 'package:singleeat/screens/home/storeVat/operation/provider.dart';
import 'package:singleeat/screens/home/storesettlement/email/screen.dart';

class TaxesScreen extends ConsumerStatefulWidget {
  const TaxesScreen({super.key});

  @override
  ConsumerState<TaxesScreen> createState() => _TaxesScreenState();
}

class SaleHistoryModel {
  final String sellType;
  final String price;
  final String tax;
  //int get total => int.parse(price) + int.parse(tax);

  SaleHistoryModel(
      {required this.sellType, required this.price, required this.tax});
}

class PurchaseHistoryModel {
  final String code;
  final String serviceType;
  final int price;
  final int tax;
  int get total => price + tax;

  PurchaseHistoryModel(
      {required this.code,
      required this.serviceType,
      required this.price,
      required this.tax});
}

class _TaxesScreenState extends ConsumerState<TaxesScreen> {
  String currentTab = "매출";

  String currentDateRangeType = "월별";
  List<String> dateRangeType = ["월별", "기간 선택"];

  DateRange dateRange = DateRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    Future.microtask(() {
      ref.read(storeVatNotifierProvider.notifier).getVatSalesInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeVatNotifierProvider);
    final provider = ref.read(storeVatNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "부가세"),
        body: SGContainer(
            color: Color(0xFFFAFAFB),
            child: ListView(
              children: [
                SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    color: SGColors.white,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SGTypography.body("기간 선택",
                                    weight: FontWeight.w700,
                                    size: FontSize.normal),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SendEmailScreen(
                                                  callScreen: 2,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/download.png",
                                          width: 15, height: 15),
                                      SizedBox(width: SGSpacing.p1),
                                      SGTypography.body("부가세 내역 받기",
                                          weight: FontWeight.w400,
                                          color: SGColors.gray4,
                                          size: FontSize.small),
                                    ],
                                  ),
                                ),
                              ]),
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
                                        Image.asset(
                                            "assets/images/checkbox-on.png",
                                            width: 24,
                                            height: 24)
                                      else
                                        Image.asset(
                                            "assets/images/checkbox-off.png",
                                            width: 24,
                                            height: 24),
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
                                      .copyWith(
                                          month: datetime.month + 1, day: 1)
                                      .subtract(Duration(days: 1));
                                  dateRange = dateRange.copyWith(
                                      start: startDate, end: endDate);
                                }),
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                          SGTypography.body(
                              "·  최근 5년 동안 받은 주문을 볼 수 있어요.\n·  한번에 6개월까지 조회할 수 있어요.",
                              lineHeight: 1.25,
                              weight: FontWeight.w500,
                              color: SGColors.gray4),
                          SizedBox(height: SGSpacing.p4),
                          SGContainer(
                            width: double.infinity,
                            color: SGColors.primary,
                            padding: EdgeInsets.symmetric(
                                horizontal: SGSpacing.p4,
                                vertical: SGSpacing.p3),
                            borderRadius: BorderRadius.circular(SGSpacing.p2),
                            child: Center(
                                child: SGTypography.body("조회",
                                    color: SGColors.white,
                                    weight: FontWeight.w700,
                                    size: FontSize.normal)),
                          )
                        ])),
                SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuTabBar(
                          currentTab: currentTab,
                          tabs: ["매출", "매입"],
                          onTabChanged: (tab) {
                            setState(() {
                              currentTab = tab;
                            });
                            if (currentTab == '매출') {
                              provider.getVatSalesInfo();
                            } else {
                              provider.getVatPurchasesInfo();
                            }
                          }),
                      SizedBox(height: SGSpacing.p5),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (currentTab == "매출") ...[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SGTypography.body("매출",
                                      weight: FontWeight.w700,
                                      size: FontSize.normal),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SendEmailScreen(
                                                    callScreen: 2,
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            "assets/images/download.png",
                                            width: 15,
                                            height: 15),
                                        SizedBox(width: SGSpacing.p1),
                                        SGTypography.body("상세 내역 받기",
                                            weight: FontWeight.w400,
                                            color: SGColors.gray4,
                                            size: FontSize.small),
                                      ],
                                    ),
                                  ),
                                ]),
                            SizedBox(height: SGSpacing.p3),
                            ...[
                              SaleHistoryModel(
                                  sellType: "기타매출",
                                  price: state.storeVatSale
                                      .otherSalesSupplyAmount.toKoreanCurrency,
                                  tax: state.storeVatSale.otherSalesVatAmount
                                      .toKoreanCurrency),
                              SaleHistoryModel(
                                  sellType: "카드매출",
                                  price: state.storeVatSale
                                      .cardSalesSupplyAmount.toKoreanCurrency,
                                  tax: state.storeVatSale.cardSalesVatAmount
                                      .toKoreanCurrency),
                              SaleHistoryModel(
                                  sellType: "현금매출",
                                  price: state.storeVatSale
                                      .cashSalesSupplyAmount.toKoreanCurrency,
                                  tax: state.storeVatSale.cashSalesVatAmount
                                      .toKoreanCurrency),
                            ]
                                .map((e) => [
                                      SaleHistoryCard(
                                        saleHistory: e,
                                      ),
                                      SizedBox(
                                          height: SGSpacing.p2 + SGSpacing.p05),
                                    ])
                                .flattened
                          ] else ...[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SGTypography.body("매입",
                                      weight: FontWeight.w700,
                                      size: FontSize.normal),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SendEmailScreen(
                                                    callScreen: 2,
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            "assets/images/download.png",
                                            width: 15,
                                            height: 15),
                                        SizedBox(width: SGSpacing.p1),
                                        SGTypography.body("상세 내역 받기",
                                            weight: FontWeight.w400,
                                            color: SGColors.gray4,
                                            size: FontSize.small),
                                      ],
                                    ),
                                  ),
                                ]),
                            SizedBox(height: SGSpacing.p3),
                            ...[
                              PurchaseHistoryModel(
                                  code: "싱그릿",
                                  serviceType: "싱그릿 포장 주문 중개 수수료",
                                  price: state.storeVatPurchases
                                      .pickUpOrderPlatformFeeSupplyAmount,
                                  tax: state.storeVatPurchases
                                      .pickUpOrderPlatformFeeVatAmount),
                              PurchaseHistoryModel(
                                  code: "싱그릿",
                                  serviceType: "싱그릿 배달 주문 중개 수수료",
                                  price: state.storeVatPurchases
                                      .deliveryOrderPlatformFeeSupplyAmount,
                                  tax: state.storeVatPurchases
                                      .deliveryOrderPlatformFeeVatAmount),
                              PurchaseHistoryModel(
                                  code: "싱그릿",
                                  serviceType: "결제 수수료",
                                  price: state
                                      .storeVatPurchases.paymentFeeSupplyAmount,
                                  tax: state
                                      .storeVatPurchases.paymentFeeVatAmount),
                            ]
                                .map((e) => [
                                      PurchaseHistoryCard(
                                        purchaseHistory: e,
                                      ),
                                      SizedBox(
                                          height: SGSpacing.p2 + SGSpacing.p05),
                                    ])
                                .toList()
                                .flattened
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}

class SaleHistoryCard extends StatelessWidget {
  final SaleHistoryModel saleHistory;
  const SaleHistoryCard({super.key, required this.saleHistory});

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(
      children: [
        VatDataTableRow(left: "구분", right: saleHistory.sellType),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(left: "공급가액", right: saleHistory.price),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(left: "부가세", right: saleHistory.tax),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(
            left: "합계",
            right: (saleHistory.price.toIntFromCurrency +
                    saleHistory.tax.toIntFromCurrency)
                .toKoreanCurrency),
      ],
    );
  }
}

class PurchaseHistoryCard extends StatelessWidget {
  final PurchaseHistoryModel purchaseHistory;

  const PurchaseHistoryCard({super.key, required this.purchaseHistory});

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(
      children: [
        VatDataTableRow(left: "서비스", right: "싱그릿"),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(left: "발급구분코드", right: purchaseHistory.serviceType),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(
            left: "수수료(공급가액)", right: purchaseHistory.price.toKoreanCurrency),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(
            left: "수수료(부가세)", right: purchaseHistory.tax.toKoreanCurrency),
        SizedBox(height: SGSpacing.p4),
        VatDataTableRow(left: "합계", right: purchaseHistory.total.toKoreanCurrency),
      ],
    );
  }
}

class VatDataTableRow extends StatelessWidget {
  const VatDataTableRow({Key? key, required this.left, required this.right}) : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SGTypography.body(
          left,
          color: SGColors.gray4,
          weight: FontWeight.w500,
          size: FontSize.small,
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 156,
          child: SGTypography.body(
            right,
            color: SGColors.gray5,
            weight: FontWeight.w500,
            size: FontSize.small,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }
}