import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/step_counter.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/order_menu_option_screen.dart';
import 'package:singleeat/office/models/order_model.dart';
import 'package:singleeat/screens/bottom/myinfo/orderlist/model.dart';
import 'package:singleeat/screens/bottom/order/operation/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class _DataTable extends StatelessWidget {
  const _DataTable({super.key, this.children = const []});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      padding: EdgeInsets.symmetric(
          horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      color: Color(0xFF1F1F1F),
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _DataTableRow extends StatelessWidget {
  const _DataTableRow({Key? key, required this.left, required this.right})
      : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SGTypography.body(left,
            color: SGColors.gray4,
            weight: FontWeight.w500,
            size: FontSize.small),
        SGTypography.body(right,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w500,
            size: FontSize.small),
      ],
    );
  }
}

class NewOrderDetailScreen extends ConsumerWidget {
  final MyInfoOrderHistoryModel order;
  const NewOrderDetailScreen({super.key, required this.order});

  void showRejectDialog(
      {required BuildContext context, required MyInfoOrderHistoryModel order}) {
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: SGColors.black,
          foregroundColor: SGColors.whiteForDarkMode,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          title: SGTypography.body(
            order.receiveFoodType == 'TAKEOUT' ? '포장 신규 접수' : '배달 신규 접수',
            size: FontSize.medium,
            weight: FontWeight.w800,
            color: SGColors.white,
          ),
        ),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            color: SGColors.black,
            child: ListView(children: [
              _DataTable(children: [
                Row(children: [
                  SGTypography.body("주문 상태",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                  Spacer(),
                  SGTypography.body(order.orderDate,
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
                SizedBox(height: SGSpacing.p4),
                Row(children: [
                  SGContainer(
                      color: order.orderStatus != OrderStatus.cancelled
                          ? SGColors.primary.withOpacity(0.1)
                          : SGColors.warningRed.withOpacity(0.1),
                      padding: EdgeInsets.all(SGSpacing.p1),
                      borderRadius: BorderRadius.circular(SGSpacing.p1),
                      child: SGTypography.body(
                        "신규 접수",
                        color: order.orderStatus != OrderStatus.cancelled
                            ? SGColors.primary
                            : SGColors.warningRed,
                      )),
                  Spacer(),
                  SGTypography.body(order.orderTime,
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
              ]),
              SizedBox(height: SGSpacing.p3),
              _OrderInformation(order: order),
              SizedBox(height: SGSpacing.p32),
              StepCounter(
                defaultValue: order.receiveFoodType == "TAKEOUT" ? 20 : 60,
                step: 5,
                maxValue: order.receiveFoodType == "TAKEOUT" ? 60 : 100,
                minValue: order.receiveFoodType == "TAKEOUT" ? 5 : 20,
              ),
              SizedBox(height: SGSpacing.p4),
              Row(
                children: [
                  SGFlexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showRejectDialog(order: order, context: context);
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
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
                        Navigator.of(context).pop();
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
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
              ),
              SizedBox(height: SGSpacing.p20),
            ])));
  }
}

class CompletedOrderDetailScreen extends ConsumerWidget {
  final MyInfoOrderHistoryModel order;
  const CompletedOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: SGColors.black,
          foregroundColor: SGColors.whiteForDarkMode,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          title: SGTypography.body(
            order.receiveFoodType == 'DELIVERY' ? '배달 주문 내역' : '포장 주문 내역',
            size: FontSize.medium,
            weight: FontWeight.w800,
            color: SGColors.white,
          ),
        ),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            color: SGColors.black,
            child: ListView(children: [
              _DataTable(children: [
                Row(children: [
                  SGTypography.body("주문 상태",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                  Spacer(),
                  SGTypography.body("${order.createdDate}",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
                SizedBox(height: SGSpacing.p4),
                Row(children: [
                  SGContainer(
                      color: order.orderStatus != OrderStatus.cancelled
                          ? SGColors.primary.withOpacity(0.1)
                          : SGColors.warningRed.withOpacity(0.1),
                      padding: EdgeInsets.all(SGSpacing.p1),
                      borderRadius: BorderRadius.circular(SGSpacing.p1),
                      child: SGTypography.body(
                        order.orderStatus != OrderStatus.cancelled
                            ? order.receiveFoodType == 'DELIVERY'
                                ? '배달 접수'
                                : '포장 접수'
                            : "주문 취소",
                        color: order.orderStatus != OrderStatus.cancelled
                            ? SGColors.primary
                            : SGColors.warningRed,
                      )),
                  Spacer(),
                  SGTypography.body("${order.createdDate}",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
              ]),
              SizedBox(height: SGSpacing.p3),
              _OrderInformation(order: order),
              SizedBox(height: SGSpacing.p20),
              SGActionButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                      'tel://1600-7723',
                    ));
                  },
                  label: "고객 센터"),
              SizedBox(height: SGSpacing.p20),
            ])));
  }
}

class InProgressOrderDetailScreen extends ConsumerWidget {
  final MyInfoOrderHistoryModel order;
  const InProgressOrderDetailScreen({super.key, required this.order});

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
            left: SGSpacing.p24, right: SGSpacing.p24, bottom: SGSpacing.p12),
        behavior: SnackBarBehavior.floating,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: SGColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: SGColors.gray5,
        duration: const Duration(milliseconds: 3000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }

  void showCancelDialog({required BuildContext context}) {
    showSGDialogWithCloseButton(
        context: context,
        childrenBuilder: (ctx) => [
              _CancelDialogBody(
                  order: order,
                  onCancel: () {
                    showSGDialog(
                        context: context,
                        childrenBuilder: (ctx) => [
                              SGTypography.body("주문 취소",
                                  size: FontSize.medium,
                                  weight: FontWeight.w700),
                              SizedBox(height: SGSpacing.p4),
                              SGTypography.body("주문을 정말 취소하시겠습니까?",
                                  size: FontSize.small,
                                  weight: FontWeight.w700,
                                  color: SGColors.gray4),
                              SizedBox(height: SGSpacing.p5),
                              Row(
                                children: [
                                  SGFlexible(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: SGContainer(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: SGSpacing.p4),
                                        borderRadius:
                                            BorderRadius.circular(SGSpacing.p3),
                                        color: SGColors.gray3,
                                        child: Center(
                                          child: SGTypography.body("취소",
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
                                        showSnackBar(context, "주문이 취소되었습니다.");
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
                              ),
                            ]);
                  })
            ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: SGColors.black,
          foregroundColor: SGColors.whiteForDarkMode,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          title: SGTypography.body(
            order.receiveFoodType == 'DELIVERY'
                ? '배달 | ${order.orderNumber}'
                : '포장 | ${order.orderNumber}',
            size: FontSize.medium,
            weight: FontWeight.w800,
            color: SGColors.white,
          ),
        ),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            color: SGColors.black,
            child: ListView(children: [
              if (order.receiveFoodType == "TAKEOUT")
                SGTypography.body("음식을 준비하고 있어요",
                    color: SGColors.whiteForDarkMode,
                    size: FontSize.xlarge,
                    weight: FontWeight.w700)
              else
                SGTypography.body("기사님이 배달중이에요",
                    color: SGColors.whiteForDarkMode,
                    size: FontSize.xlarge,
                    weight: FontWeight.w700),
              if (order.receiveFoodType == "DELIVERY") ...[
                SizedBox(height: SGSpacing.p2),
                SGTypography.body("배달 대행사 : 바로고",
                    size: FontSize.normal,
                    weight: FontWeight.w400,
                    color: SGColors.gray4),
              ],
              SizedBox(height: SGSpacing.p6),
              SizedBox(height: SGSpacing.p2),
              if (order.receiveFoodType == "DELIVERY")
                Image.asset(
                    "assets/images/order-progress-indicator-delivery.png",
                    width: double.infinity)
              else
                Image.asset(
                    "assets/images/order-progress-indicator-takeout.png",
                    width: double.infinity),
              SizedBox(height: SGSpacing.p10),
              _OrderInformation(order: order),
              SizedBox(height: SGSpacing.p20),
              Center(
                child: SGTypography.body("고객센터 문의는 1600-7723으로 문의 주세요",
                    color: SGColors.gray4,
                    size: FontSize.small,
                    weight: FontWeight.w700),
              ),
              SizedBox(height: SGSpacing.p4),
              if (order.receiveFoodType == "TAKEOUT") ...[
                SGActionButton(
                    onPressed: () {
                      showSGDialog(
                          context: context,
                          childrenBuilder: (ctx) => [
                                SGTypography.body("식단 준비 완료",
                                    size: FontSize.medium,
                                    weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p4),
                                SGTypography.body("고객님께 준비 완료 알림을 보내시겠습니까?",
                                    size: FontSize.small,
                                    weight: FontWeight.w700,
                                    color: SGColors.gray4,
                                    lineHeight: 1.25),
                                SGTypography.body(
                                    "'확인' 클릭 시 고객님께 푸시알림이 전송됩니다. ",
                                    size: FontSize.small,
                                    weight: FontWeight.w700,
                                    color: SGColors.gray4),
                                SizedBox(height: SGSpacing.p5),
                                Row(
                                  children: [
                                    SGFlexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: SGContainer(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          borderRadius: BorderRadius.circular(
                                              SGSpacing.p3),
                                          color: SGColors.gray3,
                                          child: Center(
                                            child: SGTypography.body("취소",
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
                                              .read(orderNotifierProvider
                                                  .notifier)
                                              .notifyCookingComplete(order
                                                  .orderMenuDTOList[0]
                                                  .orderInformationId);
                                          showSnackBar(
                                              context, "준비 완료 알림 전송 성공!");
                                        },
                                        child: SGContainer(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          borderRadius: BorderRadius.circular(
                                              SGSpacing.p3),
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
                                ),
                              ]);
                    },
                    label: "준비 완료 알림 보내기"),
                SizedBox(height: SGSpacing.p5),
              ],
              if (order.receiveFoodType == "DELIVERY") ...[
                SGActionButton(
                    onPressed: () {
                      showSGDialog(
                          context: context,
                          childrenBuilder: (ctx) => [
                                SGTypography.body("식단 배달 완료",
                                    size: FontSize.medium,
                                    weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p4),
                                SGTypography.body("고객님께 배달 완료 알림을 보내시겠습니까?",
                                    size: FontSize.small,
                                    weight: FontWeight.w700,
                                    color: SGColors.gray4,
                                    lineHeight: 1.25),
                                SGTypography.body(
                                    "'확인' 클릭 시 고객님께 푸시알림이 전송됩니다. ",
                                    size: FontSize.small,
                                    weight: FontWeight.w700,
                                    color: SGColors.gray4),
                                SizedBox(height: SGSpacing.p5),
                                Row(
                                  children: [
                                    SGFlexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: SGContainer(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          borderRadius: BorderRadius.circular(
                                              SGSpacing.p3),
                                          color: SGColors.gray3,
                                          child: Center(
                                            child: SGTypography.body("취소",
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
                                              .read(orderNotifierProvider
                                                  .notifier)
                                              .notifyDeliveryComplete(order
                                                  .orderMenuDTOList[0]
                                                  .orderInformationId);
                                          showSnackBar(
                                              context, "배달 완료 알림 전송 성공!");
                                        },
                                        child: SGContainer(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          borderRadius: BorderRadius.circular(
                                              SGSpacing.p3),
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
                                ),
                              ]);
                    },
                    label: "배달 완료 처리하기"),
                SizedBox(height: SGSpacing.p5),
              ],
              GestureDetector(
                onTap: () {
                  showCancelDialog(context: context);
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    width: double.infinity,
                    color: SGColors.gray4,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("주문 취소하기",
                            color: Colors.white,
                            weight: FontWeight.w700,
                            size: FontSize.medium))),
              ),
              SizedBox(height: SGSpacing.p32),
            ])));
  }
}

class _OrderInformation extends StatelessWidget {
  const _OrderInformation({
    super.key,
    required this.order,
  });

  final MyInfoOrderHistoryModel order;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _DataTable(children: [
        SGTypography.body("요청 사항",
            size: FontSize.normal,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w600),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "가게", right: order.toOwner),
        if (order.receiveFoodType == 'DELIVERY') ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "배달", right: order.toRider),
        ]
      ]),
      SizedBox(height: SGSpacing.p3),
      _DataTable(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SGTypography.body("주문 정보",
              size: FontSize.normal,
              color: SGColors.whiteForDarkMode,
              weight: FontWeight.w600),
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
                        size: FontSize.small, color: SGColors.gray3))),
            SGFlexible(
                flex: 1,
                child: SGTypography.body("금액",
                    align: TextAlign.right,
                    size: FontSize.small,
                    color: SGColors.gray3)),
          ]),
          SizedBox(height: SGSpacing.p3),
          Divider(height: 1, thickness: 1, color: SGColors.lineDark2),
          SizedBox(height: SGSpacing.p4),
          ...order.orderMenuDTOList.map((e) => OrderMenuList(
                orderMenuOptionDTOList: order.orderMenuOptionDTOList[0],
                orderMenu: e,
                colorType: SGColors.whiteForDarkMode,
              )),
          SizedBox(height: SGSpacing.p4),
          Divider(height: 1, thickness: 1, color: SGColors.lineDark2),
          SizedBox(height: SGSpacing.p3),
          Row(children: [
            SGFlexible(
                flex: 2,
                child: SGTypography.body("메뉴 합계",
                    size: FontSize.small, color: SGColors.gray4)),
            SGFlexible(
                flex: 1,
                child: SGTypography.body(order.orderAmount.toString(),
                    align: TextAlign.right,
                    size: FontSize.small,
                    color: SGColors.gray4)),
          ]),
          if (order.receiveFoodType == 'DELIVERY') ...[
            SizedBox(height: SGSpacing.p3),
            Row(children: [
              SGFlexible(
                  flex: 2,
                  child: SGTypography.body("배달팁",
                      size: FontSize.small, color: SGColors.gray4)),
              SGFlexible(
                  flex: 1,
                  child: SGTypography.body(order.deliveryTip.toKoreanCurrency,
                      align: TextAlign.right,
                      size: FontSize.small,
                      color: SGColors.gray4)),
            ])
          ],
          SizedBox(height: SGSpacing.p3),
          Divider(height: 1, thickness: 1, color: SGColors.lineDark2),
          SizedBox(height: SGSpacing.p5),
          Row(children: [
            SGFlexible(
                flex: 1,
                child: SGTypography.body("총 결제 금액",
                    size: FontSize.normal, color: SGColors.whiteForDarkMode)),
            SGFlexible(
                flex: 1,
                child: SGTypography.body(
                    order.totalOrderAmount.toKoreanCurrency,
                    align: TextAlign.right,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    color: SGColors.whiteForDarkMode)),
          ])
        ])
      ]),
      SizedBox(height: SGSpacing.p3),
      _DataTable(children: [
        SGTypography.body("결제방법",
            size: FontSize.normal,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w600),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "카카오페이", right: '${order.totalOrderAmount}원'),
      ]),
      if (order.receiveFoodType == 'DELIVERY') ...[
        SizedBox(height: SGSpacing.p3),
        _DataTable(children: [
          SGTypography.body("배달 정보",
              size: FontSize.normal,
              color: SGColors.whiteForDarkMode,
              weight: FontWeight.w600),
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "배달 주소", right: order.address.substring(0, 20)),
          if (order.receiveFoodType == "DELIVERY" &&
                  order.orderStatus == OrderStatus.inProgress ||
              order.orderStatus == OrderStatus.completed ||
              order.orderStatus == OrderStatus.cancelled) ...[
            SizedBox(height: SGSpacing.p3),
            _DataTableRow(
                left: "연락처",
                right: [OrderStatus.newOrder, OrderStatus.inProgress]
                        .contains(OrderStatus.newOrder)
                    ? "010-0000-1111"
                    : "010-****-****"),
          ],
        ]),
      ],
      SizedBox(height: SGSpacing.p3),
      _DataTable(children: [
        SGTypography.body("주문 이력",
            size: FontSize.normal,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w600),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "주문 일시", right: order.orderDate),
        if (/*order.status != OrderStatus.newOrder*/ true) ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "접수 일시", right: "00.00(일) 00:00"),
        ],
        if (/*order.status == OrderStatus.completed*/ true) ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "전달 완료", right: "00.00(일) 00:00"),
        ],
      ]),
      SizedBox(height: SGSpacing.p3),
      _DataTable(children: [
        SGTypography.body("가게 정보",
            size: FontSize.normal,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w600),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "가게명", right: order.storeName),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "주문번호", right: order.orderNumber),
      ]),
      if (order.receiveFoodType == 'TAKEOUT' &&
          (order.orderStatus == OrderStatus.inProgress ||
              order.orderStatus == OrderStatus.completed ||
              order.orderStatus == OrderStatus.cancelled)) ...[
        SizedBox(height: SGSpacing.p3),
        _DataTable(children: [
          SGTypography.body("주문자 정보",
              size: FontSize.normal,
              color: SGColors.white,
              weight: FontWeight.w600),
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(
              left: "연락처",
              right: [OrderStatus.newOrder, OrderStatus.inProgress]
                      .contains(OrderStatus.newOrder)
                  ? "010-0000-1111"
                  : "010-****-****"),
        ]),
      ]
    ]);
  }
}

class _CancelDialogBody extends ConsumerStatefulWidget {
  _CancelDialogBody({
    super.key,
    required this.onCancel,
    required this.order,
  });

  VoidCallback onCancel;
  MyInfoOrderHistoryModel order;

  @override
  ConsumerState<_CancelDialogBody> createState() => _CancelDialogBodyState();
}

class _CancelDialogBodyState extends ConsumerState<_CancelDialogBody> {
  String cancelReason = "";

  @override
  Widget build(BuildContext context) {
    List<String> reasons = [
      "고객 사정",
      "주문 폭주",
      if (widget.order.receiveFoodType == 'DELIVERY') "배달 지연",
      "재료 소진",
      "가게 사정",
      "기타 사정",
    ];
    return Column(children: [
      Center(
          child: SGTypography.body("취소 사유",
              size: FontSize.medium, weight: FontWeight.w700)),
      SizedBox(height: SGSpacing.p4),
      Wrap(
          alignment: WrapAlignment.center,
          spacing: SGSpacing.p2,
          runSpacing: SGSpacing.p2,
          children: [...reasons.map((e) => _renderCancelButton(e)).toList()]),
      SizedBox(height: SGSpacing.p4),
      Center(
          child: SGTypography.body("최대 1개 선택",
              size: FontSize.small,
              weight: FontWeight.w700,
              color: SGColors.gray4)),
      SizedBox(height: SGSpacing.p4),
      GestureDetector(
        onTap: () {
          if (cancelReason.isEmpty) {
            return;
          }
          Navigator.of(context).pop();
          if (widget.order.receiveFoodType == 'DELIVERY') {
            ref.read(orderNotifierProvider.notifier).deliveryOrderCancel(
                widget.order.orderMenuDTOList[0].orderInformationId,
                reasons.indexOf(cancelReason));
          } else {
            ref.read(orderNotifierProvider.notifier).takeoutOrderCancel(
                widget.order.orderMenuDTOList[0].orderInformationId,
                reasons.indexOf(cancelReason));
          }
        },
        child: SGContainer(
            padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            color: cancelReason.isEmpty ? SGColors.gray3 : SGColors.primary,
            child: Center(
              child: SGTypography.body("거절",
                  size: FontSize.normal,
                  weight: FontWeight.w700,
                  color: SGColors.white),
            )),
      )
    ]);
  }

  Widget _renderCancelButton(String reason) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (cancelReason == reason) {
            cancelReason = "";
          } else {
            cancelReason = reason;
          }
        });
      },
      child: SGContainer(
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p5, vertical: SGSpacing.p3 + SGSpacing.p05),
        borderRadius: BorderRadius.circular(SGSpacing.p3),
        borderColor: cancelReason == reason ? SGColors.primary : SGColors.line3,
        color: SGColors.white,
        child: SGTypography.body(reason,
            size: FontSize.normal,
            weight: FontWeight.w700,
            color: cancelReason == reason ? SGColors.primary : SGColors.black),
      ),
    );
  }
}

class _RejectDialogBody extends StatefulWidget {
  _RejectDialogBody({
    super.key,
    required this.order,
    required this.onReject,
  });

  MyInfoOrderHistoryModel order;
  VoidCallback onReject;

  @override
  State<_RejectDialogBody> createState() => _RejectDialogBodyState();
}

class _RejectDialogBodyState extends State<_RejectDialogBody> {
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
          alignment: WrapAlignment.center,
          spacing: SGSpacing.p2,
          runSpacing: SGSpacing.p2,
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
