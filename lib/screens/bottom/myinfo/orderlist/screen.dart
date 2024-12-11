import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:singleeat/core/screens/order_menu_option_screen.dart';
import 'package:singleeat/office/models/order_model.dart';
import 'package:singleeat/screens/bottom/myinfo/orderlist/provider.dart';

import 'model.dart';

class ReceiptListScreen extends ConsumerStatefulWidget {
  ReceiptListScreen({super.key});

  @override
  ConsumerState<ReceiptListScreen> createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends ConsumerState<ReceiptListScreen>
    with SingleTickerProviderStateMixin {
  DateRange dateRange = DateRange(start: DateTime.now(), end: DateTime.now());

  ScrollController scrollController = ScrollController();

  String tab = "오늘";

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(myInfoOrderHistoryNotifierProvider.notifier).getOrderHistory();
    });

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              tab = "오늘";
              ref
                  .read(myInfoOrderHistoryNotifierProvider.notifier)
                  .onChangeFilter(filter: '0');
              break;
            case 1:
              tab = "어제";
              ref
                  .read(myInfoOrderHistoryNotifierProvider.notifier)
                  .onChangeFilter(filter: '1');
              break;
            case 2:
              tab = "일주일";
              ref
                  .read(myInfoOrderHistoryNotifierProvider.notifier)
                  .onChangeFilter(filter: '2');
              break;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadMoreData() async {
    final state = ref.read(myInfoOrderHistoryNotifierProvider);
    ref
        .read(myInfoOrderHistoryNotifierProvider.notifier)
        .onChangePageNumber(pageNumber: state.pageNumber + 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myInfoOrderHistoryNotifierProvider);

    final DateTime startDate = DateTime.now();
    final DateTime yesterdayOfOne =
        dateRange.start.subtract(const Duration(days: 1));
    final DateTime yesterdayOfTwo =
        dateRange.start.subtract(const Duration(days: 2));
    final DateTime week = dateRange.start.subtract(const Duration(days: 7));

    String tab = "오늘";

    DateTime start;
    DateTime end = startDate;

    // 탭에 따른 날짜 설정
    switch (tab) {
      case "오늘":
        start = yesterdayOfOne;
        break;
      case "어제":
        start = yesterdayOfTwo;
        end = yesterdayOfOne;
        break;
      case "일주일":
        start = week;
        break;
      default:
        start = startDate;
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBarWithLeftArrow(title: "지난 주문 내역"),
          body: Column(
            children: [
              SGContainer(
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SGContainer(
                      borderColor: SGColors.line3,
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p3, vertical: SGSpacing.p4),
                      color: Colors.white,
                      child: SGTypography.body(
                        _tabController.index == 0
                            ? "${yesterdayOfOne.year}년 ${yesterdayOfOne.month}월 ${yesterdayOfOne.day}일 (${yesterdayOfOne.weekDay.toString()})"
                            : _tabController.index == 1
                                ? "${yesterdayOfTwo.year}년 ${yesterdayOfTwo.month}월 ${yesterdayOfTwo.day}일 (${yesterdayOfTwo.weekDay.toString()})"
                                : "${week.year}년 ${week.month}월 ${week.day}일 (${week.weekDay.toString()})",
                        size: FontSize.small,
                        color: Colors.black,
                        weight: FontWeight.w400,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SGContainer(
                      borderWidth: 0,
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p2),
                      child: SGTypography.body("~"),
                    ),
                    SGContainer(
                      borderColor: SGColors.line3,
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p3, vertical: SGSpacing.p4),
                      color: Colors.white,
                      child: SGTypography.body(
                        _tabController.index == 0
                            ? "${startDate.year}년 ${startDate.month}월 ${startDate.day}일 (${startDate.weekDay.toString()})"
                            : _tabController.index == 1
                                ? "${yesterdayOfOne.year}년 ${yesterdayOfOne.month}월 ${yesterdayOfOne.day}일 (${yesterdayOfOne.weekDay.toString()})"
                                : "${startDate.year}년 ${startDate.month}월 ${startDate.day}일 (${startDate.weekDay.toString()})",
                        size: FontSize.small,
                        color: Colors.black,
                        weight: FontWeight.w400,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (ctx, _) => [
                          SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(ctx),
                              sliver: SliverPersistentHeader(
                                  pinned: true,
                                  delegate: CustomTabBar(
                                      tabBar: TabBar(
                                    controller: _tabController,
                                    indicatorColor: SGColors.primary,
                                    onTap: (index) {
                                      setState(() {
                                        switch (index) {
                                          case 0:
                                            tab = "오늘";
                                            break;
                                          case 1:
                                            tab = "어제";
                                            break;
                                          case 2:
                                            tab = "일주일";
                                            break;
                                        }
                                      });
                                    },
                                    tabs: const [
                                      Tab(text: "오늘"),
                                      Tab(text: "어제"),
                                      Tab(text: "일주일"),
                                    ],
                                    labelStyle: TextStyle(
                                      fontSize: FontSize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: SGColors.primary,
                                    ),
                                    unselectedLabelStyle: const TextStyle(
                                      fontSize: FontSize.normal,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFBEBEBE),
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorPadding: EdgeInsets.symmetric(
                                        horizontal: SGSpacing.p6),
                                    indicatorWeight: 3.0,
                                    labelPadding: EdgeInsets.symmetric(
                                        horizontal: SGSpacing.p2),
                                  ))))
                        ],
                    body: SGContainer(
                        color: Color(0xFFFAFAFA),
                        padding: EdgeInsets.only(top: SGSpacing.p18)
                            .copyWith(left: SGSpacing.p4, right: SGSpacing.p4),
                        borderWidth: 0,
                        child: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            renderOrderList(state.orderHistory),
                            renderOrderList(state.orderHistory),
                            renderOrderList(state.orderHistory),
                          ],
                        ))),
              ),
            ],
          )),
    );
  }

  ListView renderOrderList(List<MyInfoOrderHistoryModel> orders) {
    return ListView(children: [
      SGContainer(
          child: Column(children: [
        ...orders
            .map((order) =>
                [_ReceiptCard(order: order), SizedBox(height: SGSpacing.p3)])
            .flattened,
        SizedBox(height: SGSpacing.p32),
      ]))
    ]);
  }
}

class _ReceiptCard extends StatelessWidget {
  final MyInfoOrderHistoryModel order;

  _ReceiptCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => _ReceiptDetailScreen(order: order)));
      },
      child: SGContainer(
          color: SGColors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          borderColor: SGColors.line2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 시간대
              SGTypography.body(order.orderDate,
                  size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
              Row(
                children: [
                  SGTypography.body(order.orderMenuDTOList[0].menuName,
                      size: FontSize.small, weight: FontWeight.w700),
                  SizedBox(width: SGSpacing.p2),
                  SGContainer(
                      color: order.orderStatus == OrderStatus.cancelled
                          ? SGColors.warningRed.withOpacity(0.1)
                          : SGColors.gray1,
                      padding: EdgeInsets.all(SGSpacing.p1),
                      borderRadius:
                          BorderRadius.circular(SGSpacing.p2 + SGSpacing.p05),
                      child: SGTypography.body(order.orderStatus,
                          weight: FontWeight.w500,
                          color: order.orderStatus ==
                                  OrderStatus.cancelled.orderStatusName
                              ? SGColors.warningRed
                              : SGColors.gray4)),
                  SizedBox(width: SGSpacing.p2),
                  if (order.receiveFoodType == "TAKEOUT")
                    SGContainer(
                        color: SGColors.primary.withOpacity(0.1),
                        padding: EdgeInsets.all(SGSpacing.p1),
                        borderRadius:
                            BorderRadius.circular(SGSpacing.p2 + SGSpacing.p05),
                        child: SGTypography.body("포장 ${order.pickUpNumber}",
                            weight: FontWeight.w500, color: SGColors.primary)),
                ],
              ),
              // 제목
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGTypography.body("결제 금액",
                      size: FontSize.small,
                      weight: FontWeight.w500,
                      color: SGColors.gray4),
                  SGTypography.body("${order.orderAmount.toKoreanCurrency}원",
                      size: FontSize.small,
                      weight: FontWeight.w500,
                      color: SGColors.gray5),
                ],
              ),
            ],
          )),
    );
  }
}

class _ReceiptDetailScreen extends StatelessWidget {
  final MyInfoOrderHistoryModel order;

  _ReceiptDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: order.receiveFoodType == 'DELIVERY' ? '배달' : '포장'),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: ListView(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body("주문 상태",
                              size: FontSize.small, weight: FontWeight.w600),
                          SGTypography.body(order.orderDate,
                              size: FontSize.small,
                              weight: FontWeight.w600,
                              color: SGColors.gray4),
                        ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGContainer(
                              color: order.orderStatus == OrderStatus.cancelled
                                  ? SGColors.warningRed.withOpacity(0.1)
                                  : SGColors.primary.withOpacity(0.1),
                              padding: EdgeInsets.all(SGSpacing.p1),
                              borderRadius: BorderRadius.circular(
                                  SGSpacing.p2 + SGSpacing.p05),
                              child: SGTypography.body(order.orderStatus,
                                  weight: FontWeight.w500,
                                  color: order.orderStatus ==
                                          OrderStatus.cancelled.orderStatusName
                                      ? SGColors.warningRed
                                      : SGColors.primary)),
                          SGTypography.body(order.orderStatus,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                              color: SGColors.gray4),
                        ])
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("요청 사항",
                        size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "가게", right: order.toOwner),
                    if (order.receiveFoodType == "DELIVERY") ...[
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "배달", right: order.toRider),
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
                    ...order.orderMenuDTOList.map((e) => OrderMenuList(
                          orderMenuOptionDTOList:
                              order.orderMenuOptionDTOList[0],
                          orderMenu: e,
                          colorType: SGColors.whiteForDarkMode,
                        )),
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
                              order.orderAmount.toKoreanCurrency,
                              align: TextAlign.right,
                              size: FontSize.small,
                              color: SGColors.gray4)),
                    ]),
                    if (order.receiveFoodType == 'DELIVERY') ...[
                      SizedBox(height: SGSpacing.p4),
                      Row(children: [
                        SGFlexible(
                            flex: 2,
                            child: SGTypography.body("배달팁",
                                size: FontSize.small, color: SGColors.gray4)),
                        SGFlexible(
                            flex: 1,
                            child: SGTypography.body(
                                order.deliveryTip.toKoreanCurrency,
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
                              size: FontSize.normal)),
                      SGFlexible(
                          flex: 1,
                          child: SGTypography.body(
                              order.totalOrderAmount.toKoreanCurrency,
                              align: TextAlign.right,
                              size: FontSize.large,
                              weight: FontWeight.w700)),
                    ]),
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("결제 방법",
                        size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(
                        left: order.payMethodDetail,
                        right: order.totalOrderAmount.toKoreanCurrency),
                  ]),
                  if (order.receiveFoodType == 'DELIVERY') ...[
                    SizedBox(height: SGSpacing.p4),
                    MultipleInformationBox(children: [
                      SGTypography.body("배달 정보",
                          size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(
                          left: "배달 주소", right: order.address.substring(0, 30)),
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "연락처", right: order.phone),
                    ])
                  ],
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("주문 이력",
                        size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "주문일시", right: order.createdDate),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "접수일시", right: order.receiveDate),
                    if (order.orderStatus != OrderStatus.cancelled) ...[
                      SizedBox(height: SGSpacing.p4),
                      DataTableRow(left: "전달 완료", right: order.completedDate),
                    ],
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  MultipleInformationBox(children: [
                    SGTypography.body("가게 정보",
                        size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "가게명", right: order.storeName),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "주문 번호", right: order.orderNumber),
                  ]),
                ]),
                SizedBox(height: SGSpacing.p4),
                if (order.receiveFoodType == "TAKEOUT") ...[
                  MultipleInformationBox(children: [
                    SGTypography.body("주문자 정보",
                        size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p4),
                    DataTableRow(left: "연락처", right: order.phone),
                  ]),
                ],
                SizedBox(height: SGSpacing.p24),
                Container(
                    constraints: BoxConstraints(
                        maxWidth:
                            MediaQuery.of(context).size.width - SGSpacing.p8,
                        maxHeight: 58),
                    child: SGActionButton(onPressed: () {}, label: "고객 센터")),
              ],
            )));
  }
}
