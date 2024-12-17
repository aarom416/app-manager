import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/core/utils/router_util.dart';
import 'package:singleeat/screens/home/couponinformation/operation/provider.dart';
import 'package:singleeat/screens/home/couponinformation/operation/screen.dart';

class CouponDetailScreen extends ConsumerStatefulWidget {
  const CouponDetailScreen({super.key});

  @override
  ConsumerState<CouponDetailScreen> createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends ConsumerState<CouponDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.read(couponInformationNotifierProvider.notifier);
    final coupon = ref.watch(couponInformationNotifierProvider).selectedCoupon;

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "쿠폰 관리"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(
            children: [
              SGTypography.label("쿠폰명을 선택해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Row(children: [
                  SGTypography.body(coupon.couponName,
                      color: SGColors.gray4,
                      size: FontSize.small,
                      weight: FontWeight.w400),
                  Spacer(),
                ]),
              )),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("쿠폰 유형을 선택해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Image.asset(
                          "assets/images/inactive-radio-${coupon.discountType == 'PERCENT' ? 'on' : 'off'}.png",
                          width: 24,
                          height: 24),
                      SizedBox(width: SGSpacing.p1),
                      SGTypography.body(" ~% 할인",
                          color: SGColors.black,
                          size: FontSize.small,
                          weight: FontWeight.w400),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(children: [
                      Image.asset(
                          "assets/images/inactive-radio-${coupon.discountType == 'AMOUNT' ? 'on' : 'off'}.png",
                          width: 24,
                          height: 24),
                      SizedBox(width: SGSpacing.p1),
                      SGTypography.body(" ~원 할인",
                          color: SGColors.black,
                          size: FontSize.small,
                          weight: FontWeight.w400),
                    ])
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("발행하실 쿠폰 금액을 입력해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: coupon.discountValue.toKoreanCurrency,
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: SGTypography.body(
                          coupon.discountType == 'PERCENT' ? "%" : "원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500)),
                ],
              )),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("최소 주문 금액을 설정해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: coupon.minOrderAmount.toKoreanCurrency,
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none),
                        )),
                  ),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: SGTypography.body("원",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500)),
                ],
              )),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("쿠폰 사용에 있어 최소 주문 금액을 적어주시면 됩니다!",
                  color: SGColors.gray4, size: FontSize.tiny),
              if (coupon.discountType == 'PERCENT') ...[
                SizedBox(height: SGSpacing.p8),
                SGTypography.label("최대 할인 금액을 설정해주세요.", color: SGColors.black),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Row(children: [
                    SGTypography.body(
                        "최대 ${coupon.discountLimit.toKoreanCurrency}원 할인",
                        color: SGColors.gray4,
                        size: FontSize.small,
                        weight: FontWeight.w400),
                    Spacer(),
                  ]),
                )),
              ],
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("유효기간을 설정해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  SGContainer(
                    width: SGSpacing.p20 + SGSpacing.p2,
                    borderRadius: BorderRadius.circular(SGSpacing.p2),
                    child: _DateRangeInputWrapper(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Center(
                              child: SGTypography.body(
                            createExpirationDateLabel(
                              coupon.startDate,
                              coupon.expiredDate,
                            ),
                            color: SGColors.gray4,
                            size: 15.0,
                            weight: FontWeight.w400,
                          )),
                        ])),
                  ),
                  SizedBox(width: SGSpacing.p3),
                  Expanded(
                      child: _DateRangeInputWrapper(
                          child: SGTypography.body(
                              "${coupon.startDate} ~ ${coupon.expiredDate}",
                              color: SGColors.gray4,
                              size: 15.0,
                              weight: FontWeight.w400))),
                ],
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("주문 가능 유형을 선택해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Row(children: [
                  SGTypography.body(createOrderTypeLabel(coupon),
                      color: SGColors.gray4,
                      size: FontSize.small,
                      weight: FontWeight.w400),
                  Spacer(),
                ]),
              )),
              SizedBox(height: SGSpacing.p12),
              SGActionButton(
                  variant: SGActionButtonVariant.danger,
                  onPressed: () {
                    showCouponIssueSGDialog(
                        context: context,
                        childrenBuilder: (ctx) => [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SGTypography.body("쿠폰을 정말 삭제하시겠습니까?",
                                      size: MediaQuery.of(ctx).size.width <= 320
                                          ? FontSize.tiny
                                          : FontSize.small,
                                      weight: FontWeight.w700),
                                ],
                              ),
                              SizedBox(height: SGSpacing.p5),
                              Row(children: [
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () =>
                                          ref.read(goRouterProvider).pop(),
                                      child: SGContainer(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SGSpacing.p4,
                                            vertical: SGSpacing.p4),
                                        borderRadius:
                                            BorderRadius.circular(SGSpacing.p3),
                                        color: SGColors.gray3,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SGTypography.body("취소",
                                                  color: SGColors.white,
                                                  weight: FontWeight.w700,
                                                  size: FontSize.normal)
                                            ]),
                                      )),
                                ),
                                SizedBox(width: SGSpacing.p2),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteCoupon(provider);
                                    },
                                    child: SGContainer(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: SGSpacing.p4,
                                          vertical: SGSpacing.p4),
                                      borderRadius:
                                          BorderRadius.circular(SGSpacing.p3),
                                      color: SGColors.primary,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SGTypography.body("확인",
                                                color: Colors.white,
                                                weight: FontWeight.w700,
                                                size: FontSize.normal)
                                          ]),
                                    ),
                                  ),
                                ),
                              ]),
                            ]);
                    return;
                  },
                  label: "쿠폰 삭제하기")
            ],
          ),
        ));
  }

  Future<void> deleteCoupon(CouponInformationNotifier provider) async {
    await provider.deleteIssuedCoupon(
        successCallback: () {
          if (!context.mounted) return;
          popUntil(context: context, path: AppRoutes.couponInformation);
        },
        failCallback: () => {
              Navigator.pop(context),
              showFailDialogWithImage("해당 쿠폰은 삭제할 수 없습니다.\n고객센터로 문의해주세요", ""),
            });
  }

  void showFailDialogWithImage(String mainTitle, String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(mainTitle,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              Center(
                  child: SGTypography.body(subTitle,
                      color: SGColors.gray4,
                      size: FontSize.small,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              SizedBox(height: SGSpacing.p6),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                },
                child: SGContainer(
                  color: SGColors.primary,
                  width: double.infinity,
                  borderColor: SGColors.primary,
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Center(
                      child: SGTypography.body("확인",
                          color: SGColors.white,
                          weight: FontWeight.w700,
                          size: FontSize.normal)),
                ),
              )
            ]);
  }

  String createExpirationDateLabel(String startDateStr, String expiredDateStr) {
    final startDate = DateFormat("yyyy.MM.dd").parse(startDateStr);
    final expiredDate = DateFormat("yyyy.MM.dd").parse(expiredDateStr);

    // 오늘을 포함한 종료일까지의 기간
    // 12.10 ~ 12.12 : 3일
    final differenceDays = expiredDate.difference(startDate).inDays + 1;

    if (differenceDays >= 90) {
      return '3개월';
    } else if (differenceDays >= 30) {
      return '한 달';
    } else if (differenceDays >= 21) {
      return '3주';
    } else if (differenceDays >= 14) {
      return '2주';
    } else if (differenceDays >= 7) {
      return '1주';
    } else if (differenceDays >= 3) {
      return '3일';
    }

    throw ArgumentError('유효 기간 설정이 잘못된 쿠폰입니다.');
  }
}

class _DateRangeInputWrapper extends StatelessWidget {
  final Widget child;

  const _DateRangeInputWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      borderRadius: BorderRadius.circular(SGSpacing.p2),
      color: SGColors.white,
      borderColor: SGColors.line3,
      padding: EdgeInsets.all(SGSpacing.p3)
          .copyWith(right: SGSpacing.p3 + SGSpacing.p05),
      child: child,
    );
  }
}
