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

import '../../../../../core/components/snackbar.dart';
import '../model.dart';

class _DataTable extends StatelessWidget {
  const _DataTable({super.key, this.children =  const []});

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
        SGTypography.body(
          left,
          color: SGColors.gray4,
          weight: FontWeight.w500,
          size: FontSize.small,
        ),
        Container(
          width: 186,
          alignment: Alignment.centerRight,
          child: SGTypography.body(
            right,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w500,
            size: FontSize.small,
            align: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class NewOrderDetailScreen extends ConsumerWidget {
  final MyInfoOrderHistoryModel order;
  final int orderInformationId;
  NewOrderDetailScreen({super.key, required this.order, required this.orderInformationId});

  int deliveryExpectedTime = 60;
  int takeOutExpectedTime = 20;

  void showRejectDialog(
      {required BuildContext context, required ref, required MyInfoOrderHistoryModel order}) {
    showSGDialogWithCloseButton(
        context: context,
        childrenBuilder: (ctx) => [
              _RejectDialogBody(
                  order: order,
                  orderInformationId: orderInformationId,
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
                                  Navigator.pop(context);
                                  ref.read(orderNotifierProvider.notifier).getNewOrderList(context);
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
    final OrderState state = ref.watch(orderNotifierProvider);

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
              _OrderInformation(order: order, tab: "신규",),
              SizedBox(height: SGSpacing.p32),
              StepCounter(
                defaultValue: order.receiveFoodType == "TAKEOUT" ? 20 : 60,
                step: 5,
                maxValue: order.receiveFoodType == "TAKEOUT" ? 60 : 100,
                minValue: order.receiveFoodType == "TAKEOUT" ? 5 : 20,
                onChanged: (value) {
                  order.receiveFoodType == "TAKEOUT" ? takeOutExpectedTime = value : deliveryExpectedTime = value;
                },
              ),
              SizedBox(height: SGSpacing.p4),
              Row(
                children: [
                  SGFlexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        showRejectDialog(order: order, ref: ref, context: context);
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
                      onTap: () async {
                        bool check = await ref
                            .read(orderNotifierProvider.notifier)
                            .acceptOrder(
                            orderInformationId,
                            order.receiveFoodType == "TAKEOUT" ? takeOutExpectedTime : deliveryExpectedTime
                        );
                        if (check) {
                          ref.read(orderNotifierProvider.notifier).getNewOrderList(context);
                          showSnackBar(context, "주문이 접수되었습니다.");
                        } else {
                          if (state.error.errorCode == 409) {
                            showFailDialogWithImage(
                              context: context,
                              mainTitle: "해당 주문은 이미 접수된 주문입니다.",
                              subTitle: "새로고침을 통해 다시 한번 확인해주세요."
                            );
                          } else if (state.error.errorCode == "PAYMENT_CANCEL_EXCEPTION") {
                            showFailDialogWithImage(
                                context: context,
                                mainTitle: "시스템 오류",
                                subTitle: "해당 주문은 접수할 수 없습니다.\n고객센터로 문의해주세요 (1600-7723)"
                            );
                          }
                        }
                        Navigator.pop(context);
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
            ])));
  }
}

class InProgressOrderDetailScreen extends ConsumerWidget {
  final MyInfoOrderHistoryModel order;

  const InProgressOrderDetailScreen({super.key, required this.order});

  void showCancelDialog({required BuildContext context, required MyInfoOrderHistoryModel order, required WidgetRef ref}) {
    final OrderState state = ref.watch(orderNotifierProvider);
    showSGDialogWithCloseButton(
        context: context,
        childrenBuilder: (ctx) => [
          _CancelDialogBody(
              order: order,
              onCancel: (cancelReason) {
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
                              onTap: () async {
                                Navigator.of(ctx).pop();
                                bool check = false;
                                if (order.receiveFoodType == 'DELIVERY') {
                                  check = await ref.read(orderNotifierProvider.notifier).deliveryOrderCancel(
                                      context,
                                      order.orderMenuDTOList[0].orderInformationId,
                                      cancelReason);
                                } else {
                                  check = await ref.read(orderNotifierProvider.notifier).takeoutOrderCancel(
                                      context,
                                      order.orderMenuDTOList[0].orderInformationId,
                                      cancelReason);
                                }
                                if (check) {
                                  showSnackBar(context, "주문이 취소되었습니다.");
                                  Navigator.of(context).pop();
                                  ref.read(orderNotifierProvider.notifier).getAcceptOrderList(context);
                                } else {
                                  if (state.error.errorCode == "PAYMENT_CANCEL_EXCEPTION") {
                                    showFailDialogWithImage(
                                      context: context,
                                      mainTitle: "시스템 오류",
                                      subTitle: "해당 주문은 현재 취소할 수 없습니다.\n잠시 후 다시 시도해주세요."
                                    );
                                  }
                                }
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
    final OrderState state = ref.watch(orderNotifierProvider);

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
              _OrderInformation(order: order, tab: "접수",),
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
                                    onTap: () async {
                                      bool check = await ref
                                          .read(orderNotifierProvider
                                          .notifier)
                                          .notifyCookingComplete(order
                                          .orderMenuDTOList[0]
                                          .orderInformationId);
                                      if (check) {
                                        showSnackBar(
                                            context, "준비 완료 알림 전송 성공!");
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop();
                                        ref.read(orderNotifierProvider.notifier).getAcceptOrderList(context);
                                      }
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
                                    onTap: () async {
                                      bool check = await ref
                                          .read(orderNotifierProvider
                                          .notifier)
                                          .notifyDeliveryComplete(order
                                          .orderMenuDTOList[0]
                                          .orderInformationId);
                                      if (check) {
                                        showSnackBar(
                                            context, "배달 완료 알림 전송 성공!");
                                        Navigator.of(ctx).pop();
                                        Navigator.of(context).pop();
                                        ref.read(orderNotifierProvider.notifier).getAcceptOrderList(context);
                                      }
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
                            SizedBox(height: SGSpacing.p2),
                          ]);
                    },
                    label: "배달 완료 처리하기"),
                SizedBox(height: SGSpacing.p5),
              ],
              GestureDetector(
                onTap: () {
                  showCancelDialog(context: context, order : order, ref: ref) ;
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
                  SGTypography.body("${order.orderTime}",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
                SizedBox(height: SGSpacing.p4),
                Row(children: [
                  SGContainer(
                      color: order.orderStatus == OrderStatus.cancelled.orderStatusName
                          ? SGColors.warningRed.withOpacity(0.1) :
                      order.orderStatus == OrderStatus.disPatchFail.orderStatusName
                          ? SGColors.warningRed.withOpacity(0.1)
                          : SGColors.primary.withOpacity(0.1),
                      padding: EdgeInsets.all(SGSpacing.p1),
                      borderRadius: BorderRadius.circular(SGSpacing.p1),
                      child: SGTypography.body(
                        order.orderStatus != OrderStatus.cancelled.orderStatusName
                            ? order.orderStatus == OrderStatus.disPatchFail.orderStatusName
                            ? '주문 취소' :
                        order.receiveFoodType == 'DELIVERY'
                            ? '배달 접수'
                            : '포장 접수'
                          : "주문 취소",
                        color: order.orderStatus == OrderStatus.cancelled.orderStatusName
                            ? SGColors.warningRed :
                        order.orderStatus == OrderStatus.disPatchFail.orderStatusName
                            ? SGColors.warningRed
                            : SGColors.primary,
                      )),
                  Spacer(),
                  SGTypography.body("${order.orderDate}",
                      size: FontSize.normal,
                      color: SGColors.whiteForDarkMode,
                      weight: FontWeight.w600),
                ]),
              ]),
              SizedBox(height: SGSpacing.p3),
              _OrderInformation(order: order, tab: "완료",),
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

class _OrderInformation extends StatelessWidget {
  const _OrderInformation({
    super.key,
    required this.order,
    required this.tab
  });

  final MyInfoOrderHistoryModel order;
  final String tab;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _DataTable(children: [
        SGTypography.body("요청 사항",
            size: FontSize.normal,
            color: SGColors.whiteForDarkMode,
            weight: FontWeight.w600),
        SizedBox(height: SGSpacing.p4),
        _DataTableRow(left: "가게", right: order.toOwner == 'null' ? '-' : order.toOwner),
        if (order.receiveFoodType == 'DELIVERY') ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "배달", right: "${order.toRider}\n(도착하면 문자로 알려주세요)"),
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
                colorType: SGColors.white,
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
                child: SGTypography.body(order.orderAmount.toKoreanCurrency.toString(),
                    align: TextAlign.right,
                    size: FontSize.small,
                    color: SGColors.gray4)),
          ]),
          if (order.couponDiscount != 0) ...[
            SizedBox(height: SGSpacing.p3),
            Row(children: [
              SGFlexible(
                  flex: 2,
                  child: SGTypography.body("할인 쿠폰",
                      size: FontSize.small, color: SGColors.gray4)),
              SGFlexible(
                  flex: 1,
                  child: SGTypography.body(order.couponDiscount.toKoreanCurrency,
                      align: TextAlign.right,
                      size: FontSize.small,
                      color: SGColors.gray4)),
            ])
          ],
          if (order.pointAmount != 0) ...[
            SizedBox(height: SGSpacing.p3),
            Row(children: [
              SGFlexible(
                  flex: 2,
                  child: SGTypography.body("포인트",
                      size: FontSize.small, color: SGColors.gray4)),
              SGFlexible(
                  flex: 1,
                  child: SGTypography.body(order.pointAmount.toKoreanCurrency,
                      align: TextAlign.right,
                      size: FontSize.small,
                      color: SGColors.gray4)),
            ])
          ],
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
        _DataTableRow(left: order.payMethodDetail, right: '${order.totalOrderAmount.toKoreanCurrency}원'),
      ]),
      if (order.receiveFoodType == 'DELIVERY') ...[
        SizedBox(height: SGSpacing.p3),
        _DataTable(children: [
          SGTypography.body("배달 정보",
              size: FontSize.normal,
              color: SGColors.whiteForDarkMode,
              weight: FontWeight.w600,
        ),
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "배달 주소", right: order.address),
          if (order.receiveFoodType == "DELIVERY" &&
                  tab == "접수" ||
               tab == "완료") ...[
            SizedBox(height: SGSpacing.p3),
            _DataTableRow(
              left: "연락처",
              right: (tab == "완료" && order.phone.startsWith("010"))
                  ? "010-****-****"
                  : order.phone, // 그 외의 경우
            ),
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
        _DataTableRow(left: "주문 일시", right: order.orderDateTime),
        if (tab == "접수" || tab == "완료") ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "접수 일시", right: order.receivedDate),
        ],
        if (tab == "완료") ...[
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(left: "전달 완료", right: order.completedDate),
        ]
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
          (tab == "접수" ||
              tab == "완료")) ...[
        SizedBox(height: SGSpacing.p3),
        _DataTable(children: [
          SGTypography.body("주문자 정보",
              size: FontSize.normal,
              color: SGColors.white,
              weight: FontWeight.w600),
          SizedBox(height: SGSpacing.p4),
          _DataTableRow(
            left: "연락처",
            right: (tab == "완료" && order.phone.startsWith("010"))
                ? "010-****-****"
                : order.phone, // 그 외의 경우
          ),
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

  final Function(int) onCancel;
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
      if (widget.order.receiveFoodType == 'DELIVERY') "배차 실패",
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
          Navigator.of(context, rootNavigator: true).pop();
          widget.onCancel(reasons.indexOf(cancelReason));
        },
        child: SGContainer(
            padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            color: cancelReason.isEmpty ? SGColors.gray3 : SGColors.primary,
            child: Center(
              child: SGTypography.body("취소",
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
            horizontal: SGSpacing.p3, vertical: SGSpacing.p3 + SGSpacing.p05),
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

class _RejectDialogBody extends ConsumerStatefulWidget {
  _RejectDialogBody({
    super.key,
    required this.order,
    required this.orderInformationId,
    required this.onReject,
  });

  MyInfoOrderHistoryModel order;
  int orderInformationId;
  VoidCallback onReject;

  @override
  ConsumerState<_RejectDialogBody> createState() => _RejectDialogBodyState();
}

class _RejectDialogBodyState extends ConsumerState<_RejectDialogBody> {
  String rejectReason = "";
  @override
  Widget build(BuildContext context) {
    final OrderState state = ref.watch(orderNotifierProvider);

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
      SizedBox(height: SGSpacing.p3),
      GestureDetector(
        onTap: () async {
          if (rejectReason.isEmpty) return;
          Navigator.of(context).pop();
          bool check;
          if (widget.order.receiveFoodType == 'DELIVERY') {
            check = await ref.read(orderNotifierProvider.notifier).deliveryOrderReject(
                context, widget.orderInformationId, reasons.indexOf(rejectReason));
          } else {
            check = await ref.read(orderNotifierProvider.notifier).takeoutOrderReject(
                context, widget.orderInformationId, reasons.indexOf(rejectReason));
          }
          if (check) {
            widget.onReject();
            ref.read(orderNotifierProvider.notifier).getNewOrderList(context);
          } else {
            if (state.error.errorCode == "PAYMENT_CANCEL_EXCEPTION") {
              showFailDialogWithImage(
                context: context,
                mainTitle: "시스템 오류",
                subTitle: "해당 주문은 현재 거절할 수 없습니다.\n잠시 후 다시 시도해주세요."
              );
            }
          }
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
            horizontal: SGSpacing.p3, vertical: SGSpacing.p3 + SGSpacing.p05),
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
