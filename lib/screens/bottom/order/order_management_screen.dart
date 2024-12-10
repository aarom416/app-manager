import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/step_counter.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/order_model.dart';
import 'package:singleeat/screens/bottom/order/model.dart';
import 'package:singleeat/screens/bottom/order/order_detail_screen.dart';
import 'package:singleeat/screens/bottom/order/provider.dart';

class OrderManagementScreen extends ConsumerStatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  ConsumerState<OrderManagementScreen> createState() =>
      _OrderManagementScreenState();
}

class _NoOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("assets/images/no-order.png",
            width: SGSpacing.p16, height: SGSpacing.p16),
        SizedBox(height: SGSpacing.p4),
        SGTypography.body("들어온 주문이 없어요..",
            size: FontSize.medium,
            weight: FontWeight.w600,
            color: SGColors.gray3),
        SizedBox(height: SGSpacing.p16),
      ],
    ));
  }
}

class _OrderManagementScreenState extends ConsumerState<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late TabController _tabController;
  String tab = "신규";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(orderNotifierProvider.notifier).getNewOrderList();
    });
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              tab = "신규";
              ref.read(orderNotifierProvider.notifier).getNewOrderList();
              break;
            case 1:
              tab = "접수";
              ref.read(orderNotifierProvider.notifier).getAcceptOrderList();
              break;
            case 2:
              tab = "완료";
              ref.read(orderNotifierProvider.notifier).getCompletedOrderList();
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

  @override
  Widget build(BuildContext context) {
    const toolbarHeight = 64.0;
    final provider = ref.read(orderNotifierProvider.notifier);
    final state = ref.watch(orderNotifierProvider);
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGContainer(
                              padding:
                                  EdgeInsets.symmetric(vertical: SGSpacing.p4),
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
                                    child: SGTypography.body(
                                        "사장님 신규 주문이 도착했습니다.",
                                        size: FontSize.medium,
                                        weight: FontWeight.w700)),
                                SizedBox(height: SGSpacing.p4),
                                SGContainer(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        vertical: SGSpacing.p4),
                                    borderRadius:
                                        BorderRadius.circular(SGSpacing.p3),
                                    color: SGColors.gray1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SGTypography.body("연어 샐러드 외 1개",
                                            size: FontSize.normal,
                                            weight: FontWeight.w700,
                                            lineHeight: 1.5),
                                        SizedBox(height: SGSpacing.p1),
                                        SGTypography.body(
                                            "${16000.toKoreanCurrency}원",
                                            size: FontSize.normal,
                                            weight: FontWeight.w500,
                                            lineHeight: 1.5),
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: SGSpacing.p4),
                                    borderRadius:
                                        BorderRadius.circular(SGSpacing.p3),
                                    color: SGColors.primary,
                                    child: Center(
                                      child: SGTypography.body("확인",
                                          size: FontSize.normal,
                                          weight: FontWeight.w700,
                                          color: SGColors.white),
                                    ),
                                  ),
                                )
                                // 확인
                              ]);
                    },
                    child: SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: Image.asset("assets/images/alarm-dark.png",
                            width: 24, height: 24)),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize:
                      Size(MediaQuery.of(context).size.width, SGSpacing.p8),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: SGColors.lineDark,
                    indicatorColor: SGColors.primary,
                    onTap: (index) {
                      setState(() {
                        switch (index) {
                          case 0:
                            tab = "신규";
                            break;
                          case 1:
                            tab = "접수";
                            break;
                          case 2:
                            tab = "완료";
                            break;
                        }
                      });
                    },
                    tabs: const [
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
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: SGSpacing.p6),
                    indicatorWeight: 3.0,
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: SGSpacing.p2),
                  ),
                )),
            body: SGContainer(
                borderWidth: 0,
                color: SGColors.black,
                child: SGContainer(
                    borderWidth: 0,
                    child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _NewOrderListView(orders: state.newOrderList),
                          // 접수
                          _InProgressOrderListView(
                              orders: state.acceptOrderList),
                          // 완료
                          _CompleteOrderListView(
                              orders: state.completeOrderList),
                        ])))));
  }
}

class _NewOrderListView extends ConsumerWidget {
  List<NewOrderModel> orders;

  _NewOrderListView({
    super.key,
    required this.orders,
  });

  int cookTime = 0;
  void showRejectDialog(
      {required BuildContext context, required NewOrderModel order}) {
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
                                child: Image.asset(
                                    "assets/images/emoticon-cry.png",
                                    width: 40,
                                    height: 40),
                              ),
                              SizedBox(height: SGSpacing.p4),
                              SGTypography.body("주문을 거절하셨어요.",
                                  size: FontSize.medium,
                                  weight: FontWeight.w700),
                              SizedBox(height: SGSpacing.p5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: SGSpacing.p4),
                                  borderRadius:
                                      BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.primary,
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal,
                                        weight: FontWeight.w700,
                                        color: SGColors.white),
                                  ),
                                ),
                              ),
                            ]);
                  })
            ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) return _NoOrderScreen();
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
                            child: SGTypography.body(
                                orders[index].receiveFoodType == 'TAKEOUT'
                                    ? '포장'
                                    : '배달',
                                size: FontSize.medium,
                                weight: FontWeight.w700)),
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
                                        size: FontSize.small,
                                        weight: FontWeight.w700,
                                        lineHeight: 1.5),
                                    SGTypography.body(
                                        orders[index]
                                            .orderInformationId
                                            .toString(),
                                        size: FontSize.small,
                                        weight: FontWeight.w500,
                                        lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("메뉴 개수 : ",
                                        size: FontSize.small,
                                        weight: FontWeight.w700,
                                        lineHeight: 1.5),
                                    SGTypography.body(
                                        orders[index]
                                            .orderMenuDTOList
                                            .length
                                            .toString(),
                                        size: FontSize.small,
                                        weight: FontWeight.w500,
                                        lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("메뉴 : ",
                                        size: FontSize.small,
                                        weight: FontWeight.w700,
                                        lineHeight: 1.5),
                                    SGTypography.body(
                                        orders[index].orderMenuDTOList.length >
                                                1
                                            ? '${orders[index].orderMenuDTOList[0].menuName}'
                                                '외 ${orders[index].orderMenuDTOList.length - 1}개'
                                            : orders[index]
                                                .orderMenuDTOList[0]
                                                .menuName,
                                        size: FontSize.small,
                                        weight: FontWeight.w500,
                                        lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p1),
                                Row(
                                  children: [
                                    SGTypography.body("가격 : ",
                                        size: FontSize.small,
                                        weight: FontWeight.w700,
                                        lineHeight: 1.5),
                                    SGTypography.body(
                                        "${orders[index].orderAmount.toKoreanCurrency}원",
                                        size: FontSize.small,
                                        weight: FontWeight.w500,
                                        lineHeight: 1.5),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.of(ctx).pop();
                                          bool result = await ref
                                              .read(orderNotifierProvider
                                                  .notifier)
                                              .getNewOrderDetail(orders[index]
                                                  .orderInformationId);
                                          if (result) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        NewOrderDetailScreen(
                                                            order: ref
                                                                .watch(
                                                                    orderNotifierProvider)
                                                                .orderDetail)));
                                          }
                                        },
                                        child: SGContainer(
                                            borderColor: SGColors.primary,
                                            borderRadius: BorderRadius.circular(
                                                SGSpacing.p2),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: SGSpacing.p4,
                                                vertical: SGSpacing.p3),
                                            child: Row(children: [
                                              SGTypography.body("자세히",
                                                  size: FontSize.small,
                                                  color: SGColors.primary),
                                            ])),
                                      )
                                    ])
                              ],
                            )),
                        SizedBox(height: SGSpacing.p5),
                        SGTypography.body("예상 소요시간",
                            size: FontSize.small, weight: FontWeight.w700),
                        SizedBox(height: SGSpacing.p2),
                        StepCounter(
                          defaultValue:
                              orders[index].receiveFoodType == "TAKEOUT"
                                  ? 20
                                  : 60,
                          step: 5,
                          maxValue: orders[index].receiveFoodType == "TAKEOUT"
                              ? 60
                              : 100,
                          minValue: orders[index].receiveFoodType == "TAKEOUT"
                              ? 5
                              : 20,
                          onChanged: (value) {
                            print('step counter ${value}');
                            cookTime = value;
                          },
                        ),
                        SizedBox(height: SGSpacing.p4),
                        Row(
                          children: [
                            SGFlexible(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  showRejectDialog(
                                      order: orders[index], context: context);
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: SGSpacing.p4),
                                  borderRadius:
                                      BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.gray3,
                                  child: Center(
                                    child: SGTypography.body("거절",
                                        size: FontSize.normal,
                                        weight: FontWeight.w700,
                                        color: SGColors.white),
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
                                  ref
                                      .read(orderNotifierProvider.notifier)
                                      .acceptOrder(
                                          orders[index].orderInformationId,
                                          cookTime);
                                },
                                child: SGContainer(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: SGSpacing.p4),
                                  borderRadius:
                                      BorderRadius.circular(SGSpacing.p3),
                                  color: SGColors.primary,
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal,
                                        weight: FontWeight.w700,
                                        color: SGColors.white),
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
                    backgroundColor: orders[index].receiveFoodType == "TAKEOUT"
                        ? SGColors.success
                        : SGColors.warningOrange,
                    child: SGTypography.body(
                        orders[index].receiveFoodType == "TAKEOUT"
                            ? '포장'
                            : '배달',
                        size: FontSize.large,
                        weight: FontWeight.w700,
                        color: SGColors.white))),
          );
        });
  }
}

class _RejectDialogBody extends ConsumerStatefulWidget {
  _RejectDialogBody({
    super.key,
    required this.order,
    required this.onReject,
  });

  NewOrderModel order;
  VoidCallback onReject;

  @override
  ConsumerState<_RejectDialogBody> createState() => _RejectDialogBodyState();
}

class _RejectDialogBodyState extends ConsumerState<_RejectDialogBody> {
  String rejectReason = "";

  @override
  Widget build(BuildContext context) {
    List<String> reasons = [
      if (widget.order.receiveFoodType == 'DELIVERY') "배달 지역 초과",
      "재료 소진",
      "가게 사정",
      if (widget.order.receiveFoodType == 'DELIVERY') "배달 지연",
      "주문 폭주",
      "기타",
      "영업시간 외",
    ];
    return Column(children: [
      Center(
          child: SGTypography.body("거절 사유",
              size: FontSize.medium, weight: FontWeight.w700)),
      SizedBox(height: SGSpacing.p4),
      Wrap(
          spacing: SGSpacing.p2,
          runSpacing: SGSpacing.p2,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [...reasons.map((e) => _renderRejectButton(e)).toList()]),
      SizedBox(height: SGSpacing.p4),
      Center(
          child: SGTypography.body("최대 1개 선택",
              size: FontSize.small,
              weight: FontWeight.w700,
              color: SGColors.gray4)),
      SizedBox(height: SGSpacing.p4),
      GestureDetector(
        onTap: () {
          if (rejectReason.isEmpty) return;
          Navigator.of(context).pop();
          if (widget.order.receiveFoodType == 'DELIVERY') {
            ref.read(orderNotifierProvider.notifier).deliveryOrderReject(
                widget.order.orderInformationId, reasons.indexOf(rejectReason));
          } else {
            ref.read(orderNotifierProvider.notifier).takeoutOrderReject(
                widget.order.orderInformationId, reasons.indexOf(rejectReason));
          }
          widget.onReject();
        },
        child: SGContainer(
            padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            color: rejectReason.isEmpty ? SGColors.gray3 : SGColors.primary,
            child: Center(
              child: SGTypography.body("거절",
                  size: FontSize.normal,
                  weight: FontWeight.w700,
                  color: SGColors.white),
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
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p5, vertical: SGSpacing.p3 + SGSpacing.p05),
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

class _CompleteOrderListView extends ConsumerWidget {
  List<NewOrderModel> orders;

  _CompleteOrderListView({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) return _NoOrderScreen();
    return ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        separatorBuilder: (ctx, index) => Divider(
              color: SGColors.lineDark,
              thickness: 0.5,
            ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () async {
              bool result = await ref
                  .read(orderNotifierProvider.notifier)
                  .getCompletedOrderDetail(orders[index].orderInformationId);
              if (result) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => CompletedOrderDetailScreen(
                        order: ref.watch(orderNotifierProvider).orderDetail)));
              }
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _OrderCard(
                    order: orders[index],
                    tailing: PercentageIndicator(
                        percentage: orders[index].expectedTime /
                            orders[index].expectedTime,
                        radius: 25,
                        strokeWidth: 3,
                        strokeColor: strokeColor(orders[index]),
                        color: Colors.transparent,
                        label:
                            orders[index].orderStatus != OrderStatus.cancelled
                                ? "완료"
                                : "취소")),
                Positioned(
                    top: SGSpacing.p4,
                    right: SGSpacing.p2,
                    child: CircleAvatar(
                        radius: SGSpacing.p3 + SGSpacing.p05,
                        backgroundColor: strokeColor(orders[index]),
                        child: Center(
                            child: SGTypography.body(
                                orders[index].receiveFoodType == 'DELIVERY'
                                    ? '배달'
                                    : '포장',
                                color: SGColors.white,
                                weight: FontWeight.w700))))
              ],
            ),
          );
        });
  }

  Color strokeColor(NewOrderModel order) {
    if (order.orderStatus == OrderStatus.cancelled) return SGColors.warningRed;
    if (order.receiveFoodType == "DELIVERY") return SGColors.success;
    if (order.receiveFoodType == "TAKEOUT") return SGColors.warningOrange;
    return SGColors.primary;
  }
}

class _InProgressOrderListView extends ConsumerWidget {
  List<NewOrderModel> orders;

  _InProgressOrderListView({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (orders.isEmpty) return _NoOrderScreen();
    return ListView.separated(
        shrinkWrap: true,
        itemCount: orders.length,
        separatorBuilder: (ctx, index) => Divider(
              thickness: 0.5,
              color: SGColors.lineDark,
            ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () async {
              bool result = await ref
                  .read(orderNotifierProvider.notifier)
                  .getAcceptedOrderDetail(orders[index].orderInformationId);
              if (result) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => InProgressOrderDetailScreen(
                        order: ref.watch(orderNotifierProvider).orderDetail)));
              }
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _OrderCard(
                    order: orders[index],
                    // TODO : 2024.12.10 접수 API 경과 시간 추가 필요 현재 10으로 고정
                    tailing: PercentageIndicator(
                        percentage: 10 / orders[index].expectedTime,
                        radius: 25,
                        strokeWidth: 3,
                        strokeColor: strokeColor(orders[index]),
                        color: Colors.transparent,
                        label: "${orders[index].expectedTime}분")),
                Positioned(
                    top: SGSpacing.p4,
                    right: SGSpacing.p2,
                    child: CircleAvatar(
                        radius: SGSpacing.p3 + SGSpacing.p05,
                        backgroundColor: strokeColor(orders[index]),
                        child: Center(
                            child: SGTypography.body(
                                orders[index].receiveFoodType == 'DELIVERY'
                                    ? '배달'
                                    : '포장',
                                color: SGColors.white,
                                weight: FontWeight.w700))))
              ],
            ),
          );
        });
  }

  Color strokeColor(NewOrderModel order) {
    if (order.receiveFoodType == "TAKEOUT") return SGColors.success;
    if (order.receiveFoodType == "DELIVERY") return SGColors.warningOrange;
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
          painter: _PercentageIndicatorPainter(
              percentage, strokeColor, color, radius, strokeWidth),
          child: Center(
              child: SGTypography.body(label,
                  color: SGColors.white,
                  size: FontSize.medium,
                  weight: FontWeight.w700))),
    );
  }
}

class _PercentageIndicatorPainter extends CustomPainter {
  final double percentage;
  final double radius;
  final double strokeWidth;
  final Color strokeColor;
  final Color color;

  _PercentageIndicatorPainter(this.percentage, this.strokeColor, this.color,
      this.radius, this.strokeWidth);

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
    canvas.drawArc(
        rect, -0.5 * 3.14, 2 * percentage * 3.14, false, paintStroke);
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
  final NewOrderModel order;
  final Widget? tailing;

  _OrderCard({super.key, required this.order, this.tailing});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        padding: EdgeInsets.symmetric(
            vertical: SGSpacing.p4, horizontal: SGSpacing.p4),
        borderWidth: 0,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                SGTypography.body(
                  order.createdDate,
                  size: FontSize.normal,
                  weight: FontWeight.w700,
                  color: SGColors.white,
                ),
                SizedBox(width: SGSpacing.p1),
                if (order.orderStatus == OrderStatus.newOrder.orderStatusName &&
                    order.receiveFoodType == 'TAKEOUT')
                  SGContainer(
                    color: SGColors.primary.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(SGSpacing.p05 + SGSpacing.p1),
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p1, vertical: SGSpacing.p1),
                    child: SGTypography.body("포장 ${order.orderInformationId}",
                        weight: FontWeight.w500, color: SGColors.primary),
                  ),
                if (OrderStatus.inProgress == OrderStatus.inProgress)
                  Row(
                    children: [
                      SGContainer(
                        color: SGColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(SGSpacing.p05 + SGSpacing.p1),
                        padding: EdgeInsets.symmetric(
                            horizontal: SGSpacing.p1, vertical: SGSpacing.p1),
                        child: SGTypography.body(order.orderStatus,
                            weight: FontWeight.w500, color: SGColors.primary),
                      ),
                      SizedBox(width: SGSpacing.p2),
                      order.receiveFoodType == "TAKEOUT"
                          ? SGContainer(
                              color: SGColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                  SGSpacing.p05 + SGSpacing.p1),
                              padding: EdgeInsets.symmetric(
                                  horizontal: SGSpacing.p1,
                                  vertical: SGSpacing.p1),
                              child: SGTypography.body(
                                  "포장 ${order.pickUpNumber}",
                                  weight: FontWeight.w500,
                                  color: SGColors.primary),
                            )
                          : Container(),
                    ],
                  )
              ],
            ),
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
              order.orderMenuDTOList.length > 1
                  ? '${order.orderMenuDTOList[0].menuName}'
                      '외 ${order.orderMenuDTOList.length - 1}개'
                  : order.orderMenuDTOList[0].menuName,
              size: FontSize.large,
              weight: FontWeight.w700,
              color: SGColors.white,
            ),
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(
              "주문금액 ${order.orderAmount.toKoreanCurrency}원",
              size: FontSize.normal,
              weight: FontWeight.w500,
              color: SGColors.gray4,
            ),
          ]),
          if (tailing != null) tailing!,
        ]));
  }
}
