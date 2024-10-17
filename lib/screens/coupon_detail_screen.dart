import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/bloc/coupon_list_bloc.dart';
import 'package:singleeat/office/models/coupon_model.dart';

class CouponDetailScreen extends StatefulWidget {
  const CouponDetailScreen({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  State<CouponDetailScreen> createState() => _CouponDetailScreenState();
}

class _CouponDetailScreenState extends State<CouponDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "쿠폰 관리"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(
            children: [
              SGTypography.label("쿠폰명을 선택해주세요.", color: SGColors.black),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Row(children: [
                  SGTypography.body(widget.coupon.name,
                      color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400),
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
                          "assets/images/inactive-radio-${widget.coupon.discountType == CouponDiscountType.percentage ? 'on' : 'off'}.png",
                          width: 24,
                          height: 24),
                      SizedBox(width: SGSpacing.p1),
                      SGTypography.body(" ~% 할인", color: SGColors.black, size: FontSize.small, weight: FontWeight.w400),
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    Row(children: [
                      Image.asset(
                          "assets/images/inactive-radio-${widget.coupon.discountType == CouponDiscountType.fixed ? 'on' : 'off'}.png",
                          width: 24,
                          height: 24),
                      SizedBox(width: SGSpacing.p1),
                      SGTypography.body(" ~원 할인", color: SGColors.black, size: FontSize.small, weight: FontWeight.w400),
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
                          hintText: widget.coupon.discountAmount.toKoreanCurrency,
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  ),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: SGTypography.body(widget.coupon.discountType == CouponDiscountType.percentage ? "%" : "원",
                          color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: widget.coupon.minimumOrderAmount.toKoreanCurrency,
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  ),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child:
                          SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                ],
              )),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("쿠폰 사용에 있어 최소 주문 금액을 적어주시면 됩니다!", color: SGColors.gray4, size: FontSize.tiny),
              if (widget.coupon.discountType == CouponDiscountType.percentage) ...[
                SizedBox(height: SGSpacing.p8),
                SGTypography.label("최대 할인 금액을 설정해주세요.", color: SGColors.black),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Row(children: [
                    SGTypography.body("최대 ${widget.coupon.maximumDiscountAmount.toKoreanCurrency}원 할인",
                        color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400),
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
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Center(
                          child: SGTypography.body(
                        widget.coupon.expirationType.labelName,
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
                              "${widget.coupon.startDate.koreanDateFormat} ~ ${widget.coupon.endDate.koreanDateFormat}",
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
                  SGTypography.body(widget.coupon.orderType.labelName,
                      color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400),
                  Spacer(),
                ]),
              )),
              SizedBox(height: SGSpacing.p12),
              SGActionButton(
                  variant: SGActionButtonVariant.danger,
                  onPressed: () {
                    showSGDialog(
                        context: context,
                        childrenBuilder: (ctx) => [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SGTypography.body("쿠폰을 정말 삭제하시겠습니까?", size: FontSize.medium, weight: FontWeight.w700),
                                ],
                              ),
                              SizedBox(height: SGSpacing.p5),
                              Row(children: [
                                Expanded(
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: SGContainer(
                                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                                        color: SGColors.gray3,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          SGTypography.body("취소",
                                              color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)
                                        ]),
                                      )),
                                ),
                                SizedBox(width: SGSpacing.p2),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      context.read<CouponListBloc>().add(DeleteCoupon(widget.coupon.id));
                                      Navigator.of(context).pop();
                                    },
                                    child: SGContainer(
                                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                                      color: SGColors.primary,
                                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                        SGTypography.body("확인",
                                            color: Colors.white, weight: FontWeight.w700, size: FontSize.normal)
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
      padding: EdgeInsets.all(SGSpacing.p3).copyWith(right: SGSpacing.p3 + SGSpacing.p05),
      child: child,
    );
  }
}
