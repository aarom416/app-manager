import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/custom_tab_bar.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/order_model.dart';

class ReceiptListScreen extends StatefulWidget {
  ReceiptListScreen({super.key});

  @override
  State<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  DateRange dateRange = DateRange(start: DateTime.now(), end: DateTime.now());
  ScrollController scrollController = ScrollController();

  List<OrderModel> orders = [
    OrderModel(
        orderName: "연어 샐러드 외 1건",
        price: 16000,
        status: OrderStatus.newOrder,
        orderTime: DateTime.now().subtract(Duration(hours: 1)),
        orderType: "배달"),
    OrderModel(orderName: "연어 포케 외 2건", price: 13000, status: OrderStatus.newOrder, orderTime: DateTime.now()),
    OrderModel(orderName: "육회 포케 외 2건", price: 13000, status: OrderStatus.cancelled, orderTime: DateTime.now()),
    OrderModel(
        orderName: "육회 포케 외 2건",
        price: 13000,
        status: OrderStatus.cancelled,
        orderTime: DateTime.now(),
        orderType: "배달"),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBarWithLeftArrow(title: "지난 주문 내역"),
          floatingActionButton: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
              child: SGActionButton(onPressed: () {}, label: "조회")),
          body: NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (ctx, _) => [
                    SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(ctx),
                        sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: CustomTabBar(
                                tabBar: TabBar(
                              indicatorColor: SGColors.primary,
                              tabs: [
                                Tab(text: "오늘"),
                                Tab(text: "어제"),
                                Tab(text: "일주일"),
                              ],
                              labelStyle: TextStyle(
                                fontSize: FontSize.normal,
                                fontWeight: FontWeight.w600,
                                color: SGColors.primary,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: FontSize.normal,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFBEBEBE),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p6),
                              indicatorWeight: 3.0,
                              labelPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p2),
                            ))))
                  ],
              body: SGContainer(
                  color: Color(0xFFFAFAFA),
                  padding: EdgeInsets.only(top: SGSpacing.p18).copyWith(left: SGSpacing.p4, right: SGSpacing.p4),
                  borderWidth: 0,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      renderOrderList(),
                      renderOrderList(),
                      renderOrderList(),
                    ],
                  )))),
    );
  }

  ListView renderOrderList() {
    return ListView(children: [
      SGContainer(
          child: Column(children: [
        ...orders.map((order) => [_ReceiptCard(order: order), SizedBox(height: SGSpacing.p3)]).flattened,
        SizedBox(height: SGSpacing.p32),
      ]))
    ]);
  }
}

class _ReceiptCard extends StatelessWidget {
  final OrderModel order;

  _ReceiptCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => _ReceiptDetailScreen(order: order)));
      },
      child: SGContainer(
          color: SGColors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          borderColor: SGColors.line2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 시간대
              SGTypography.body(order.orderTime.toShortTimeString, size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
              Row(
                children: [
                  SGTypography.body(order.orderName, size: FontSize.small, weight: FontWeight.w700),
                  SizedBox(width: SGSpacing.p2),
                  SGContainer(
                      color:
                          order.status == OrderStatus.cancelled ? SGColors.warningRed.withOpacity(0.1) : SGColors.gray1,
                      padding: EdgeInsets.all(SGSpacing.p1),
                      borderRadius: BorderRadius.circular(SGSpacing.p2 + SGSpacing.p05),
                      child: SGTypography.body(order.status == OrderStatus.cancelled ? "주문 취소" : "결제 완료",
                          weight: FontWeight.w500,
                          color: order.status == OrderStatus.cancelled ? SGColors.warningRed : SGColors.gray4)),
                  SizedBox(width: SGSpacing.p2),
                  if (order.orderType == "포장")
                    SGContainer(
                        color: SGColors.primary.withOpacity(0.1),
                        padding: EdgeInsets.all(SGSpacing.p1),
                        borderRadius: BorderRadius.circular(SGSpacing.p2 + SGSpacing.p05),
                        child: SGTypography.body("포장 XSZ1", weight: FontWeight.w500, color: SGColors.primary)),
                ],
              ),
              // 제목
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGTypography.body("결제 금액", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                  SGTypography.body("${order.price.toKoreanCurrency}원",
                      size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray5),
                ],
              ),
            ],
          )),
    );
  }
}

class _ReceiptDetailScreen extends StatelessWidget {
  final OrderModel order;

  _ReceiptDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "${order.orderType} 123"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: ListView(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("주문 상태", size: FontSize.small, weight: FontWeight.w600),
                      SGTypography.body(order.orderTime.toShortDateTimeString,
                          size: FontSize.small, weight: FontWeight.w600, color: SGColors.gray4),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGContainer(
                          color: order.status == OrderStatus.cancelled
                              ? SGColors.warningRed.withOpacity(0.1)
                              : SGColors.primary.withOpacity(0.1),
                          padding: EdgeInsets.all(SGSpacing.p1),
                          borderRadius: BorderRadius.circular(SGSpacing.p2 + SGSpacing.p05),
                          child: SGTypography.body(
                              order.status == OrderStatus.cancelled ? "주문 취소" : "${order.orderType} 접수",
                              weight: FontWeight.w500,
                              color: order.status == OrderStatus.cancelled ? SGColors.warningRed : SGColors.primary)),
                      SGTypography.body(order.orderTime.toShortTimeString,
                          size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                    ])
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("요청 사항", size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "가게", right: "요청 사항 없음"),
                    if (order.orderType == "배달") ...[
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "배달", right: "문 앞에 두고 벨 눌러주세요."),
                    ]
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  // 주문 정보
                  MultipleInformationBox(children: [
                    SGTypography.body(
                      "주문 정보",
                      size: FontSize.normal,
                      weight: FontWeight.w600,
                    ),
                    SizedBox(height: SGSpacing.p5),
                    Row(children: [
                      SGFlexible(flex: 2, child: SGTypography.body("메뉴", size: FontSize.small, color: SGColors.gray3)),
                      SGFlexible(
                          flex: 1,
                          child: Center(child: SGTypography.body("수량", size: FontSize.small, color: SGColors.gray3))),
                      SGFlexible(
                          flex: 1,
                          child: SGTypography.body("금액",
                              align: TextAlign.right, size: FontSize.small, color: SGColors.gray3)),
                    ]),
                    SizedBox(height: SGSpacing.p3),
                    Divider(height: 1, thickness: 1, color: SGColors.line1),
                    SizedBox(height: SGSpacing.p4),
                    Row(children: [
                      SGFlexible(
                          flex: 2,
                          child: SGTypography.body(
                            "연어 샐러드",
                            size: FontSize.small,
                          )),
                      SGFlexible(
                          flex: 1,
                          child: Center(
                              child: SGTypography.body(
                            "1",
                            size: FontSize.small,
                          ))),
                      SGFlexible(
                          flex: 1, child: SGTypography.body("13,000", align: TextAlign.right, size: FontSize.small)),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(children: [
                      SGFlexible(
                          flex: 2,
                          child: SGTypography.body(
                            "ㄴ 오리 훈제 토핑",
                            size: FontSize.small,
                          )),
                      SGFlexible(
                          flex: 1,
                          child: Center(
                              child: SGTypography.body(
                            "1",
                            size: FontSize.small,
                          ))),
                      SGFlexible(
                          flex: 1, child: SGTypography.body("3,000", align: TextAlign.right, size: FontSize.small)),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Divider(height: 1, thickness: 1, color: SGColors.line1),
                    SizedBox(height: SGSpacing.p3),
                    Row(children: [
                      SGFlexible(
                          flex: 2, child: SGTypography.body("메뉴 합계", size: FontSize.small, color: SGColors.gray4)),
                      SGFlexible(
                          flex: 1,
                          child: SGTypography.body("16,000",
                              align: TextAlign.right, size: FontSize.small, color: SGColors.gray4)),
                    ]),
                    if (order.orderType == '배달') ...[
                      SizedBox(height: SGSpacing.p4),
                      Row(children: [
                        SGFlexible(
                            flex: 2, child: SGTypography.body("배달팁", size: FontSize.small, color: SGColors.gray4)),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body("3,000",
                                align: TextAlign.right, size: FontSize.small, color: SGColors.gray4)),
                      ]),
                    ],
                    SizedBox(height: SGSpacing.p3),
                    Divider(height: 1, thickness: 1, color: SGColors.line1),
                    SizedBox(height: SGSpacing.p5),
                    Row(children: [
                      SGFlexible(flex: 1, child: SGTypography.body("총 결제 금액", size: FontSize.normal)),
                      SGFlexible(
                          flex: 1,
                          child: SGTypography.body(order.orderType == '배달' ? "19,000원" : "16,000원",
                              align: TextAlign.right, size: FontSize.large, weight: FontWeight.w700)),
                    ]),
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("결제 방법", size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "카카오페이", right: order.orderType == '배달' ? "19,000원" : "16,000원"),
                  ]),
                  if (order.orderType == '배달') ...[
                    SizedBox(height: SGSpacing.p4),
                    MultipleInformationBox(children: [
                      SGTypography.body("배달 정보", size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "배달 주소", right: "강남구 역삼1동"),
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "연락처", right: "010-****-****"),
                    ])
                  ],
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("주문 이력", size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "주문일시", right: "00.00(일) 00:00"),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "접수일시", right: "00.00(일) 00:00"),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "전달 완료", right: "00.00(일) 00:00"),
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("가게 정보", size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "가게명", right: "샐러디 역삼점"),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "주문 번호", right: "ABCDEFGHIJ"),
                  ]),
                ]),
                SizedBox(height: SGSpacing.p4),
                if (order.orderType == "포장") ...[
                  MultipleInformationBox(children: [
                    SGTypography.body("주문자 정보", size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "연락처", right: "050-****-****"),
                  ]),
                ],
                SizedBox(height: SGSpacing.p4),
                SGActionButton(onPressed: () {}, label: "고객 센터"),
                SizedBox(height: SGSpacing.p14),
              ],
            )));
  }
}
