import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/time_utils.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/model.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/provider.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  String currentDateRangeType = "월별";
  List<String> dateRangeType = ["월별", "기간 선택"];
  String filterValue = '처리 중';
  DateRange dateRange = DateRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(storeOrderHistoryNotifierProvider.notifier).onChangeStartDate(
          startDate: getFirstDayOfMonthWithDateTime(dateRange.start));
      ref.read(storeOrderHistoryNotifierProvider.notifier).onChangeEndDate(
          endDate: getLastDayOfMonthWithDateTime(dateRange.end));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeOrderHistoryNotifierProvider);
    final provider = ref.read(storeOrderHistoryNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "주문 내역"),
        body: SGContainer(
            borderWidth: 0,
            color: Color(0xFFFAFAFA),
            child: ListView(children: [
              SGContainer(
                  color: SGColors.white,
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SGTypography.body("기간 선택",
                                  weight: FontWeight.w700,
                                  size: FontSize.normal),
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
                                provider.onChangeStartDate(
                                    startDate: dateRange.start
                                        .toShortDateStringWithZeroPadding);
                              });
                            },
                            onEndDateChanged: (date) {
                              setState(() {
                                dateRange = dateRange.copyWith(end: date);
                                provider.onChangeEndDate(
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
                                dateRange = dateRange.copyWith(
                                    start: startDate, end: endDate);
                                provider.onChangeStartDate(
                                    startDate: getFirstDayOfMonthWithDateTime(
                                        dateRange.start));
                                provider.onChangeEndDate(
                                    endDate: getLastDayOfMonthWithDateTime(
                                        dateRange.start));
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
                              horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                          borderRadius: BorderRadius.circular(SGSpacing.p2),
                          child: InkWell(
                            onTap: () {
                              print('tab');
                              provider.getOrderHistoryByFilter();
                            },
                            child: Center(
                                child: SGTypography.body("조회",
                                    color: SGColors.white,
                                    weight: FontWeight.w700,
                                    size: FontSize.normal)),
                          ),
                        ),
                        SizedBox(height: SGSpacing.p6),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            ...["처리 중", "배달/픽업 완료", "주문 취소"]
                                .map((e) => [
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              filterValue = e;
                                              provider.onChangeFilter(
                                                  filter: filterValue == '처리 중'
                                                      ? '0'
                                                      : filterValue == '배달/픽업 완료'
                                                          ? '1'
                                                          : '2');
                                            });
                                          },
                                          child: SGContainer(
                                              borderRadius: BorderRadius.circular(
                                                  SGSpacing.p24),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: SGSpacing.p4,
                                                  vertical: SGSpacing.p3),
                                              borderColor: e == filterValue
                                                  ? Color(0xFF79DF70)
                                                      .withOpacity(0.2)
                                                  : SGColors.line2,
                                              color: e == filterValue
                                                  ? Color(0xFF79DF70)
                                                      .withOpacity(0.12)
                                                  : SGColors.white,
                                              child: SGTypography.body(e,
                                                  size: FontSize.small,
                                                  color: e == filterValue
                                                      ? SGColors.primary
                                                      : SGColors.gray5))),
                                      SizedBox(width: SGSpacing.p2)
                                    ])
                                .flattened
                          ]),
                        ),
                      ])),
              SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("누적",
                          size: FontSize.medium, weight: FontWeight.w700),
                      SizedBox(height: SGSpacing.p2),
                      Row(children: [
                        Expanded(
                            child: SGContainer(
                          color: SGColors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          boxShadow: SGBoxShadow.large,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SGTypography.body("주문 수",
                                    weight: FontWeight.w500,
                                    color: SGColors.gray4),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                SGTypography.body(
                                    state.storeOrderHistory.totalOrderCount
                                        .toKoreanCurrency,
                                    size: FontSize.large,
                                    weight: FontWeight.w700),
                              ]),
                        )),
                        SizedBox(width: SGSpacing.p2),
                        Expanded(
                            child: SGContainer(
                          color: SGColors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          boxShadow: SGBoxShadow.large,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SGTypography.body("결제 금액",
                                    weight: FontWeight.w500,
                                    color: SGColors.gray4),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                SGTypography.body(
                                    "${state.storeOrderHistory.totalOrderAmount.toInt().toKoreanCurrency}원",
                                    size: FontSize.large,
                                    weight: FontWeight.w700),
                              ]),
                        ))
                      ]),
                      SizedBox(height: SGSpacing.p8),
                      SGTypography.body("누적 주문 내역",
                          size: FontSize.medium, weight: FontWeight.w700),
                      SizedBox(height: SGSpacing.p1),
                      ...state.storeOrderHistory.orderHistoryDTOList.map((e) =>
                          Padding(
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p1),
                            child: _CollasipleOrderCard(
                                storeOrderHistory: e as OrderHistoryDTO),
                          )),
                      /*_CollasipleOrderCard(
                          storeOrderHistory: state.storeOrderHistory.),*/
                      SizedBox(height: SGSpacing.p2),
                    ]),
              ),
            ])));
  }
}

class DataTableRow extends StatelessWidget {
  const DataTableRow({Key? key, required this.left, required this.right, required this.overflow, required this.width}) : super(key: key);

  final String left;
  final String right;
  final bool overflow;
  final double width;

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
        overflow ? Container(
          alignment: Alignment.centerRight,
          width: width,
          child: SGTypography.body(
              right,
              color: SGColors.gray5,
              weight: FontWeight.w500,
              size: FontSize.small,
              align: TextAlign.end,
              overflow: TextOverflow.ellipsis
          ),
        )
        : Container(
          alignment: Alignment.centerRight,
          width: width,
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


class _CollasipleOrderCard extends StatefulWidget {
  final OrderHistoryDTO storeOrderHistory;
  _CollasipleOrderCard({super.key, required this.storeOrderHistory});

  @override
  State<_CollasipleOrderCard> createState() => _CollasipleOrderCardState();
}

class _CollasipleOrderCardState extends State<_CollasipleOrderCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        color: SGColors.white,
        borderColor: SGColors.line1,
        borderRadius: BorderRadius.circular(SGSpacing.p4),
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
        boxShadow: SGBoxShadow.large,
        child: Column(children: [
          DataTableRow(
              left: "주문 상태", right: widget.storeOrderHistory.orderStatus, overflow: true, width: 160),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "주문 번호", right: widget.storeOrderHistory.orderNumber, overflow: true, width: 160),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "주문 내역",
              right: widget.storeOrderHistory.orderMenuDTOList[0].menuName, overflow: true, width: 160),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "결제 유형", right: widget.storeOrderHistory.payMethodDetail, overflow: true, width: 160),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "수령 방법",
              right: widget.storeOrderHistory.receiveFoodType == 'DELIVERY'
                  ? '배달'
                  : '포장',
              overflow: true, width: 160
          ),
          SizedBox(height: SGSpacing.p4),
          DataTableRow(
              left: "결제 금액",
              right: widget.storeOrderHistory.totalOrderAmount.toKoreanCurrency,
              overflow: true, width: 160,
          ),
          SizedBox(height: SGSpacing.p4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p2),
                    width: isExpanded ? SGSpacing.p17 : SGSpacing.p20 + SGSpacing.p2,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                    child: Center(
                        child: isExpanded ? SGTypography.body(
                             "접기",
                            size: FontSize.small, color: SGColors.primary)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SGTypography.body(
                                "자세히",
                                size: FontSize.small,
                                weight: FontWeight.w600,
                                color: SGColors.primary
                            ),
                            SizedBox(
                              width: SGSpacing.p1,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: FontSize.normal,
                              color: SGColors.primary,
                            ),
                          ],
                        )
                    )),
              ),
            ],
          ),
          if (isExpanded) ...[
            SizedBox(height: SGSpacing.p4),
            SGContainer(
                width: double.infinity,
                borderColor: SGColors.line2,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body(
                        "주문 정보",
                        size: FontSize.small,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(height: SGSpacing.p5),
                      Row(children: [
                        SGFlexible(
                            flex: 2,
                            child: SGTypography.body("메뉴",
                                size: FontSize.small, color: SGColors.gray3)),
                        SGFlexible(
                            flex: 1,
                            child: Center(
                                child: SGTypography.body("수량",
                                    size: FontSize.small,
                                    color: SGColors.gray3))),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body("금액",
                                align: TextAlign.right,
                                size: FontSize.small,
                                color: SGColors.gray3)),
                      ]),
                      SizedBox(height: SGSpacing.p3),
                      Divider(height: 1, thickness: 1, color: SGColors.line1),
                      SizedBox(height: SGSpacing.p4),
                      Row(children: [
                        SGFlexible(
                            flex: 2,
                            child: SGTypography.body(
                              widget.storeOrderHistory.orderMenuDTOList[0]
                                  .menuName,
                              size: FontSize.small,
                            )),
                        SGFlexible(
                            flex: 1,
                            child: Center(
                                child: SGTypography.body(
                              widget.storeOrderHistory.orderMenuDTOList[0].count
                                  .toString(),
                              size: FontSize.small,
                            ))),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body(
                                widget.storeOrderHistory.orderMenuDTOList[0]
                                    .menuPrice.toKoreanCurrency,
                                align: TextAlign.right,
                                size: FontSize.small)),
                      ]),
                      SizedBox(height: SGSpacing.p3),
                      ...widget.storeOrderHistory.orderMenuOptionDTOList[0]
                          .map((e) => _OrderMenuOptionList(orderMenuOption: e)),
                      SizedBox(height: SGSpacing.p4),
                      Divider(height: 1, thickness: 1, color: SGColors.line1),
                      SizedBox(height: SGSpacing.p3),
                      Row(children: [
                        SGFlexible(
                            flex: 2,
                            child: SGTypography.body("메뉴 합계",
                                size: FontSize.small, color: SGColors.gray4)),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body(
                                widget.storeOrderHistory.totalOrderAmount
                                    .toKoreanCurrency,
                                align: TextAlign.right,
                                size: FontSize.small,
                                color: SGColors.gray4)),
                      ]),

                      if (widget.storeOrderHistory.couponDiscount != 0) ... [
                        SizedBox(height: SGSpacing.p3),
                        Row(children: [
                          SGFlexible(
                              flex: 2,
                              child: SGTypography.body("할인 쿠폰",
                                  size: FontSize.small, color: SGColors.gray4)),
                          SGFlexible(
                              flex: 1,
                              child: SGTypography.body(
                                  widget.storeOrderHistory.couponDiscount.toKoreanCurrency,
                                  align: TextAlign.right,
                                  size: FontSize.small,
                                  color: SGColors.gray4)),
                        ]),
                      ],
                      if (widget.storeOrderHistory.pointAmount != 0) ... [
                        SizedBox(height: SGSpacing.p3),
                        Row(children: [
                          SGFlexible(
                              flex: 2,
                              child: SGTypography.body("포인트",
                                  size: FontSize.small, color: SGColors.gray4)),
                          SGFlexible(
                              flex: 1,
                              child: SGTypography.body(
                                  widget.storeOrderHistory.pointAmount.toKoreanCurrency,
                                  align: TextAlign.right,
                                  size: FontSize.small,
                                  color: SGColors.gray4)),
                        ]),
                      ],
                      if (widget.storeOrderHistory.receiveFoodType != "DELIVERY") ... [
                        SizedBox(height: SGSpacing.p3),
                        Row(children: [
                          SGFlexible(
                              flex: 2,
                              child: SGTypography.body("배달팁",
                                  size: FontSize.small, color: SGColors.gray4)),
                          SGFlexible(
                              flex: 1,
                              child: SGTypography.body(
                                  widget.storeOrderHistory.deliveryTip.toKoreanCurrency,
                                  align: TextAlign.right,
                                  size: FontSize.small,
                                  color: SGColors.gray4)),
                        ]),
                      ],
                      SizedBox(height: SGSpacing.p3),
                      Divider(height: 1, thickness: 1, color: SGColors.line1),
                      SizedBox(height: SGSpacing.p5),
                      Row(children: [
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body("총 결제 금액",
                                size: FontSize.small)),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body(
                                '${widget.storeOrderHistory.totalOrderAmount.toKoreanCurrency}원',
                                align: TextAlign.right,
                                size: FontSize.normal,
                                weight: FontWeight.w700)),
                      ]),
                      // 총 결제 금액
                    ])),
            SizedBox(height: SGSpacing.p4),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => _OrderHistoryDetailScreen(
                        storeOrderHistory: widget.storeOrderHistory)));
              },
              child: SGContainer(
                  borderColor: SGColors.primary,
                  borderRadius: BorderRadius.circular(SGSpacing.p2),
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                  child: Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    SGTypography.body("상세 정보 보기",
                        size: FontSize.small, color: SGColors.primary),
                  ]))),
            ),
          ]
        ]));
  }
}

class _OrderMenuOptionList extends StatefulWidget {
  _OrderMenuOptionList({super.key, required this.orderMenuOption});
  final OrderMenuOptionDTO orderMenuOption;

  @override
  State<_OrderMenuOptionList> createState() => _OrderMenuOptionListState();
}

class _OrderMenuOptionListState extends State<_OrderMenuOptionList> {
  @override
  Widget build(BuildContext context) {
    return SGContainer(
      child: Row(children: [
        SGFlexible(
            flex: 2,
            child: SGTypography.body(
              "ㄴ ${widget.orderMenuOption.menuOptionName}",
              size: FontSize.small,
              color: SGColors.gray3,
            )),
        SGFlexible(
            flex: 1,
            child: Center(
                child: SGTypography.body(
              widget.orderMenuOption.count.toString(),
              size: FontSize.small,
            ))),
        SGFlexible(
            flex: 1,
            child: SGTypography.body(
                widget.orderMenuOption.menuOptionPrice.toKoreanCurrency,
                align: TextAlign.right,
                size: FontSize.small)),
      ]),
    );
  }
}

class _OrderHistoryDetailScreen extends StatelessWidget {
  final OrderHistoryDTO storeOrderHistory;
  _OrderHistoryDetailScreen({required this.storeOrderHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "상세 정보"),
      body: SGContainer(
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          color: Color(0xFFFAFAFA),
          child: ListView(children: [
            SGTypography.body(
              "주문 상세 정보",
              size: FontSize.medium,
              weight: FontWeight.w700,
            ),
            SizedBox(height: SGSpacing.p2),
            MultipleInformationBox(
              children: [
                DataTableRow(
                    left: "주 결제 방법", right: storeOrderHistory.payMethodDetail, overflow: true, width: 168),
                SizedBox(height: SGSpacing.p4),
                DataTableRow(
                    left: "보조 결제 방법", right: storeOrderHistory.secondPayMethod, overflow: true, width: 168),
                if (storeOrderHistory.receiveFoodType == "DELIVERY") ... [
                  SizedBox(height: SGSpacing.p4),
                  DataTableRow(
                      left: "픽업 주소", right: storeOrderHistory.address, overflow: false, width: 168),
                ],
                SizedBox(height: SGSpacing.p4),
                DataTableRow(
                    left: "가게 요청 사항", right: storeOrderHistory.toOwner, overflow: false, width: 168),
                if (storeOrderHistory.receiveFoodType == "DELIVERY") ... [
                  SizedBox(height: SGSpacing.p4),
                  DataTableRow(
                      left: "배달 요청 사항", right: storeOrderHistory.toRider, overflow: false, width: 168),
                ],
                SizedBox(height: SGSpacing.p4),
                DataTableRow(
                    left: "주문 시각", right: storeOrderHistory.createdDate, overflow: false, width: 201),
                SizedBox(height: SGSpacing.p4),
                DataTableRow(
                    left: "접수 시각", right: storeOrderHistory.receivedDate, overflow: false, width: 201),
                SizedBox(height: SGSpacing.p4),
                DataTableRow(
                    left: "완료 시각", right: storeOrderHistory.completedDate, overflow: false, width: 201),
              ],
            )
          ])),
    );
  }
}
