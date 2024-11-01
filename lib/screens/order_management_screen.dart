import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/custom_tab_bar.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/step_counter.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/order_model.dart';
import 'package:singleeat/screens/order_detail_screen.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _NoOrderScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("assets/images/no-order.png", width: SGSpacing.p16, height: SGSpacing.p16),
        SizedBox(height: SGSpacing.p4),
        SGTypography.body("들어온 주문이 없어요..", size: FontSize.medium, weight: FontWeight.w600, color: SGColors.gray3),
        SizedBox(height: SGSpacing.p16),
      ],
    ));
  }
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  List<OrderModel> orders = [
    // new orders
    OrderModel(id: 128, orderName: "김치찌개", price: 7000, status: OrderStatus.newOrder, orderTime: DateTime.now()),
    OrderModel(
        orderName: "된장찌개", price: 7000, status: OrderStatus.newOrder, orderTime: DateTime.now(), orderType: "배달"),
    OrderModel(
        orderName: "부대찌개", price: 7000, status: OrderStatus.newOrder, orderTime: DateTime.now(), orderType: "배달"),
    OrderModel(id: 256, orderName: "부대찌개", price: 7000, status: OrderStatus.newOrder, orderTime: DateTime.now()),

    // in progress
    OrderModel(
        id: 100,
        orderName: "된장찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now().subtract(Duration(hours: 10)),
        estimationTime: 40,
        elapsedTime: 40),
    OrderModel(
        id: 101,
        orderName: "부대찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now(),
        elapsedTime: 42,
        estimationTime: 50),
    OrderModel(
        id: 102,
        orderName: "김치찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now(),
        estimationTime: 60,
        elapsedTime: 55),
    OrderModel(
        id: 103,
        orderName: "된장찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now(),
        estimationTime: 40,
        elapsedTime: 40),
    OrderModel(
        id: 1002,
        orderName: "부대찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now(),
        elapsedTime: 42,
        estimationTime: 50,
        orderType: "배달"),
    OrderModel(
        id: 1004,
        orderName: "김치찌개",
        price: 7000,
        status: OrderStatus.inProgress,
        orderTime: DateTime.now(),
        estimationTime: 60,
        elapsedTime: 55),
    // done
    OrderModel(orderName: "된장찌개", price: 7000, status: OrderStatus.completed, orderTime: DateTime.now()),
    OrderModel(orderName: "부대찌개", price: 7000, status: OrderStatus.completed, orderTime: DateTime.now()),
    OrderModel(
        orderName: "김치찌개", price: 7000, status: OrderStatus.completed, orderTime: DateTime.now(), orderType: "배달"),
    OrderModel(
        orderName: "김치찌개", price: 7000, status: OrderStatus.cancelled, orderTime: DateTime.now(), orderType: "배달"),
  ];

  List<OrderModel> get ordersNew => orders.where((element) => element.status == OrderStatus.newOrder).toList();
  List<OrderModel> get ordersInProgress => orders.where((element) => element.status == OrderStatus.inProgress).toList();
  List<OrderModel> get ordersCompleted => orders
      .where((element) => element.status == OrderStatus.completed || element.status == OrderStatus.cancelled)
      .toList();

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    const toolbarHeight = 64.0;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: SGColors.black,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                leading: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGContainer(
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                          child: SGTypography.body("주문 접수",
                              size: (FontSize.large + FontSize.xlarge) / 2,
                              weight: FontWeight.w700,
                              color: SGColors.white)),
                    ])),
                toolbarHeight: toolbarHeight,
                leadingWidth: 200,
                actions: [
                  GestureDetector(
                    onTap: () {
                      showSGDialogWithCloseButton(
                          context: context,
                          childrenBuilder: (ctx) => [
                                Center(
                                    child: SGTypography.body("사장님 신규 주문이 도착했습니다.",
                                        size: FontSize.medium, weight: FontWeight.w700)),
                                SizedBox(height: SGSpacing.p4),
                                SGContainer(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                                    color: SGColors.gray1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SGTypography.body("연어 샐러드 외 1개",
                                            size: FontSize.normal, weight: FontWeight.w700, lineHeight: 1.5),
                                        SizedBox(height: SGSpacing.p1),
                                        SGTypography.body("${16000.toKoreanCurrency}원",
                                            size: FontSize.normal, weight: FontWeight.w500, lineHeight: 1.5),
                                      ],
                                    )),
                                // 연어 외 1개
                                SizedBox(height: SGSpacing.p4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: SGContainer(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                                    color: SGColors.primary,
                                    child: Center(
                                      child: SGTypography.body("확인",
                                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                    ),
                                  ),
                                )
                                // 확인
                              ]);
                    },
                    child: SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: Image.asset("assets/images/alarm-dark.png", width: 24, height: 24)),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: Size(MediaQuery.of(context).size.width, SGSpacing.p8),
                  child: TabBar(
                    dividerColor: SGColors.lineDark,
                    indicatorColor: SGColors.primary,
                    tabs: [
                      Tab(text: "신규", height: FontSize.xxlarge),
                      Tab(text: "접수", height: FontSize.xxlarge),
                      Tab(text: "완료", height: FontSize.xxlarge),
                    ],
                    labelStyle: TextStyle(
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600,
                      color: SGColors.primary,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600,
                      color: SGColors.gray4,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p6),
                    indicatorWeight: 3.0,
                    labelPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p2),
                  ),
                )),
            body: SGContainer(
                borderWidth: 0,
                color: SGColors.black,
                child: SGContainer(
                    borderWidth: 0,
                    child: TabBarView(physics: const NeverScrollableScrollPhysics(), children: [
                      _NewOrderListView(orders: ordersNew),
                      // 접수
                      _InProgressOrderListView(orders: ordersInProgress),
                      // 완료
                      _CompleteOrderListView(orders: ordersCompleted),
                    ])))));
  }
}

class _NewOrderListView extends StatelessWidget {
  List<OrderModel> orders;
  _NewOrderListView({
    super.key,
    required this.orders,
  });

  void showRejectDialog({required BuildContext context, required OrderModel order}) {
    showSGDialogWithCloseButton(
        context: context,
        childrenBuilder: (ctx) => [
              _RejectDialogBody(
                  order: order,
                  onReject: () {
                    showSGDialog(
                        context: context,
                        childrenBuilder: (ctx) => [
                              Center(
                                child: Image.asset("assets/images/emoticon-cry.png", width: 40, height: 40),
                              ),
                              SizedBox(height: SGSpacing.p4),
                              SGTypography.body("주문을 거절하셨어요.", size: FontSize.medium, weight: FontWeight.w700),
                              SizedBox(height: SGSpacing.p5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.primary,
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ]);
                  })
            ]);
  }

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return _NoOrderScreeen();
    return ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        separatorBuilder: (ctx, index) => Divider(
              color: SGColors.lineDark,
              thickness: 0.5,
            ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              showSGDialog(
                  context: context,
                  childrenBuilder: (ctx) => [
                        Center(
                            child: SGTypography.body("${orders[index].orderType}",
                                size: FontSize.medium, weight: FontWeight.w700)),
                        SizedBox(height: SGSpacing.p4),
                        SGContainer(
                            width: double.infinity,
                            padding: EdgeInsets.all(SGSpacing.p4),
                            borderColor: SGColors.primary,
                            borderRadius: BorderRadius.circular(SGSpacing.p3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SGTypography.body("주문 번호 : ",
                                        size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.5),
                                    SGTypography.body("1398",
                                        size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("메뉴 개수 : ",
                                        size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.5),
                                    SGTypography.body("2개",
                                        size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("메뉴 : ",
                                        size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.5),
                                    SGTypography.body("연어 샐러드 외 1개",
                                        size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("가격 : ",
                                        size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.5),
                                    SGTypography.body("${16000.toKoreanCurrency}원",
                                        size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (ctx) => NewOrderDetailScreen(order: orders[index])));
                                    },
                                    child: SGContainer(
                                        borderColor: SGColors.primary,
                                        borderRadius: BorderRadius.circular(SGSpacing.p2),
                                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                                        child: Row(children: [
                                          SGTypography.body("자세히", size: FontSize.small, color: SGColors.primary),
                                        ])),
                                  )
                                ])
                              ],
                            )),
                        SizedBox(height: SGSpacing.p5),
                        SGTypography.body("예상 소요시간", size: FontSize.small, weight: FontWeight.w700),
                        SizedBox(height: SGSpacing.p2),
                        StepCounter(
                          defaultValue: orders[index].orderType == "포장" ? 20 : 60,
                          step: 5,
                          maxValue: orders[index].orderType == "포장" ? 60 : 100,
                          minValue: orders[index].orderType == "포장" ? 5 : 20,
                        ),
                        SizedBox(height: SGSpacing.p4),
                        Row(
                          children: [
                            SGFlexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  showRejectDialog(order: orders[index], context: context);
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.gray3,
                                  child: Center(
                                    child: SGTypography.body("거절",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: SGSpacing.p2),
                            SGFlexible(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.primary,
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        // 확인
                      ]);
            },
            child: _OrderCard(
                order: orders[index],
                tailing: CircleAvatar(
                    radius: 25,
                    backgroundColor: orders[index].orderType == "포장" ? SGColors.success : SGColors.warningOrange,
                    child: SGTypography.body(orders[index].orderType,
                        size: FontSize.large, weight: FontWeight.w700, color: SGColors.white))),
          );
        });
  }
}

class _RejectDialogBody extends StatefulWidget {
  _RejectDialogBody({
    super.key,
    required this.order,
    required this.onReject,
  });

  OrderModel order;
  VoidCallback onReject;

  @override
  State<_RejectDialogBody> createState() => _RejectDialogBodyState();
}

class _RejectDialogBodyState extends State<_RejectDialogBody> {
  String rejectReason = "";

  @override
  Widget build(BuildContext context) {
    List<String> reasons = [
      if (widget.order.orderType == '배달') "배달 지역 초과",
      "재료 소진",
      "가게 사정",
      if (widget.order.orderType == '배달') "배달 지연",
      "주문 폭주",
      "기타",
      "영업시간 외",
    ];
    return Column(children: [
      Center(child: SGTypography.body("거절 사유", size: FontSize.medium, weight: FontWeight.w700)),
      SizedBox(height: SGSpacing.p4),
      Wrap(
          spacing: SGSpacing.p2,
          runSpacing: SGSpacing.p2,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [...reasons.map((e) => _renderRejectButton(e)).toList()]),
      SizedBox(height: SGSpacing.p4),
      Center(
          child: SGTypography.body("최대 1개 선택", size: FontSize.small, weight: FontWeight.w700, color: SGColors.gray4)),
      SizedBox(height: SGSpacing.p4),
      GestureDetector(
        onTap: () {
          if (rejectReason.isEmpty) return;
          Navigator.of(context).pop();
          widget.onReject();
        },
        child: SGContainer(
            padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            color: rejectReason.isEmpty ? SGColors.gray3 : SGColors.primary,
            child: Center(
              child: SGTypography.body("거절", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
            )),
      )
    ]);
  }

  Widget _renderRejectButton(String reason) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (rejectReason == reason) {
            rejectReason = "";
          } else {
            rejectReason = reason;
          }
        });
      },
      child: SGContainer(
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p5, vertical: SGSpacing.p3 + SGSpacing.p05),
        borderRadius: BorderRadius.circular(SGSpacing.p3),
        borderColor: rejectReason == reason ? SGColors.primary : SGColors.line3,
        color: SGColors.white,
        child: SGTypography.body(reason,
            size: FontSize.normal,
            weight: FontWeight.w700,
            color: rejectReason == reason ? SGColors.primary : SGColors.black),
      ),
    );
  }
}

class _CompleteOrderListView extends StatelessWidget {
  List<OrderModel> orders;
  _CompleteOrderListView({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return _NoOrderScreeen();

    return ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        separatorBuilder: (ctx, index) => Divider(
              color: SGColors.lineDark,
              thickness: 0.5,
            ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => CompletedOrderDetailScreen(order: orders[index])));
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _OrderCard(
                    order: orders[index],
                    tailing: PercentageIndicator(
                        percentage: orders[index].elapsedTime / orders[index].estimationTime,
                        radius: 25,
                        strokeWidth: 3,
                        strokeColor: strokeColor(orders[index]),
                        color: Colors.transparent,
                        label: orders[index].status != OrderStatus.cancelled ? "완료" : "취소")),
                Positioned(
                    top: SGSpacing.p4,
                    right: SGSpacing.p2,
                    child: CircleAvatar(
                        radius: SGSpacing.p3 + SGSpacing.p05,
                        backgroundColor: strokeColor(orders[index]),
                        child: Center(
                            child: SGTypography.body(orders[index].orderType,
                                color: SGColors.white, weight: FontWeight.w700))))
              ],
            ),
          );
        });
  }

  Color strokeColor(OrderModel order) {
    if (order.status == OrderStatus.cancelled) return SGColors.warningRed;
    if (order.orderType == "포장") return SGColors.success;
    if (order.orderType == "배달") return SGColors.warningOrange;
    return SGColors.primary;
  }
}

class _InProgressOrderListView extends StatelessWidget {
  List<OrderModel> orders;
  _InProgressOrderListView({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return _NoOrderScreeen();
    return ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        separatorBuilder: (ctx, index) => Divider(
              thickness: 0.5,
              color: SGColors.lineDark,
            ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => InProgressOrderDetailScreen(order: orders[index])));
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _OrderCard(
                    order: orders[index],
                    tailing: PercentageIndicator(
                        percentage: orders[index].elapsedTime / orders[index].estimationTime,
                        radius: 25,
                        strokeWidth: 3,
                        strokeColor: strokeColor(orders[index]),
                        color: Colors.transparent,
                        label: "${orders[index].estimationTime}분")),
                Positioned(
                    top: SGSpacing.p4,
                    right: SGSpacing.p2,
                    child: CircleAvatar(
                        radius: SGSpacing.p3 + SGSpacing.p05,
                        backgroundColor: strokeColor(orders[index]),
                        child: Center(
                            child: SGTypography.body(orders[index].orderType,
                                color: SGColors.white, weight: FontWeight.w700))))
              ],
            ),
          );
        });
  }

  Color strokeColor(OrderModel order) {
    if (order.orderType == "포장") return SGColors.success;
    if (order.orderType == "배달") return SGColors.warningOrange;
    return SGColors.primary;
  }
}

class PercentageIndicator extends StatelessWidget {
  final double percentage;
  final double radius;
  final double strokeWidth;
  final Color strokeColor;
  final Color color;
  final String label;

  PercentageIndicator(
      {super.key,
      required this.percentage,
      required this.strokeColor,
      required this.label,
      this.color = Colors.transparent,
      this.radius = 10,
      this.strokeWidth = 2});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      width: radius * 2 + strokeWidth,
      borderWidth: 0,
      height: radius * 2,
      child: CustomPaint(
          painter: _PercentageIndicatorPainter(percentage, strokeColor, color, radius, strokeWidth),
          child: Center(
              child: SGTypography.body(label, color: SGColors.white, size: FontSize.medium, weight: FontWeight.w700))),
    );
  }
}

class _PercentageIndicatorPainter extends CustomPainter {
  final double percentage;
  final double radius;
  final double strokeWidth;
  final Color strokeColor;
  final Color color;

  _PercentageIndicatorPainter(this.percentage, this.strokeColor, this.color, this.radius, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;

    final paintStroke = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(center, radius, paint);
    canvas.drawArc(rect, -0.5 * 3.14, 2 * percentage * 3.14, false, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final Widget? tailing;

  const _OrderCard({super.key, required this.order, this.tailing});

  String get timestamp =>
      "${order.orderTime.hour ~/ 10}${order.orderTime.hour % 10}:${order.orderTime.minute ~/ 10}${order.orderTime.minute % 10}";

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4, horizontal: SGSpacing.p4),
        borderWidth: 0,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                SGTypography.body(
                  timestamp,
                  size: FontSize.normal,
                  weight: FontWeight.w700,
                  color: SGColors.white,
                ),
                SizedBox(width: SGSpacing.p1),
                if (order.status == OrderStatus.newOrder && order.orderType == '포장')
                  SGContainer(
                    color: SGColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SGSpacing.p05 + SGSpacing.p1),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p1, vertical: SGSpacing.p1),
                    child: SGTypography.body("포장 ${order.id}", weight: FontWeight.w500, color: SGColors.primary),
                  ),
                if (order.status == OrderStatus.inProgress)
                  Row(
                    children: [
                      SGContainer(
                        color: SGColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(SGSpacing.p05 + SGSpacing.p1),
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p1, vertical: SGSpacing.p1),
                        child: SGTypography.body("조리중", weight: FontWeight.w500, color: SGColors.primary),
                      ),
                      SizedBox(width: SGSpacing.p2),
                      order.orderType == "포장" ?
                      SGContainer(
                        color: SGColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(SGSpacing.p05 + SGSpacing.p1),
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p1, vertical: SGSpacing.p1),
                        child: SGTypography.body("포장 CYZ1", weight: FontWeight.w500, color: SGColors.primary),
                      ) : Container(),
                    ],
                  )
              ],
            ),
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
              "${order.orderName}",
              size: FontSize.large,
              weight: FontWeight.w700,
              color: SGColors.white,
            ),
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
              "주문금액 ${order.price.toKoreanCurrency}원",
              size: FontSize.normal,
              weight: FontWeight.w500,
              color: SGColors.gray4,
            ),
          ]),
          if (tailing != null) tailing!,
        ]));
  }
}
