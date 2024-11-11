import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/radio.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/bloc/coupon_list_bloc.dart';
import 'package:singleeat/office/models/coupon_model.dart';

class CouponIssueScreen extends StatefulWidget {
  const CouponIssueScreen({super.key});

  @override
  State<CouponIssueScreen> createState() => _CouponIssueScreenState();
}

class _CouponIssueScreenState extends State<CouponIssueScreen> {
  // Need to be generated by random
  late String couponId;

  @override
  void initState() {
    super.initState();
    couponId = Base64Encoder().convert([
      ...List.generate(10, (index) => Random.secure().nextInt(255)),
    ]);
  }

  TextEditingController _couponAmountController = TextEditingController(text: '0');
  TextEditingController _minimumOrderAmountController = TextEditingController(text: '0');

  int minimumDiscountAmount = 0;
  int maximumDiscountAmount = 0;

  String couponName = "첫 주문 할인 쿠폰";
  List<SelectionOption<String>> couponNameOptions = [
    SelectionOption(label: "첫 주문 할인 쿠폰", value: "첫 주문 할인 쿠폰"),
    SelectionOption(label: "감사 쿠폰", value: "감사 쿠폰"),
    SelectionOption(label: "이벤트 쿠폰", value: "이벤트 쿠폰"),
    SelectionOption(label: "신메뉴 이벤트 쿠폰", value: "신메뉴 이벤트 쿠폰"),
    SelectionOption(label: "건강이 최고예요 쿠폰", value: "건강이 최고예요 쿠폰"),
    SelectionOption(label: "힘내요 쿠폰", value: "힘내요 쿠폰"),
  ];

  int couponAmount = 0;
  List<SelectionOption<int>> couponAmountOptions = [
    SelectionOption(label: "1,000원", value: 1000),
    SelectionOption(label: "2,000원", value: 2000),
    SelectionOption(label: "3,000원", value: 3000),
    SelectionOption(label: "4,000원", value: 4000),
  ];

  List<SelectionOption<int>> maximumDiscountAmountOptions = [
    SelectionOption(label: "최대 1,000원 할인", value: 1000),
    SelectionOption(label: "최대 2,000원 할인", value: 2000),
    SelectionOption(label: "최대 3,000원 할인", value: 3000),
    SelectionOption(label: "최대 4,000원 할인", value: 4000),
  ];

  List<SelectionOption<int>> couponPercentageOptions = [
    SelectionOption(label: "10%", value: 10),
    SelectionOption(label: "20%", value: 20),
    SelectionOption(label: "30%", value: 30),
  ];

  CouponDiscountType? discountType = null;

  OrderType orderType = OrderType.delivery;
  bool selectedOrderType = false;

  List<SelectionOption<OrderType>> orderTypeOptions = [
    ...OrderType.values.map((e) => SelectionOption(label: e.labelName, value: e)),
  ];

  CouponExpirationType expirationType = CouponExpirationType.d3;
  bool selectedExpirationType = false;
  List<SelectionOption<CouponExpirationType>> expirationTypeOptions = [
    ...CouponExpirationType.values.map((e) => SelectionOption(label: e.labelName, value: e)),
  ];

  List<TextInputFormatter> get numericInputFormatter {
    return [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
  }

  DateRange get couponAvailableDateRange {
    DateTime endDate = switch (expirationType) {
      CouponExpirationType.d3 => DateTime.now().add(Duration(days: 3)),
      CouponExpirationType.w1 => DateTime.now().add(Duration(days: 7)),
      CouponExpirationType.w3 => DateTime.now().add(Duration(days: 21)),
      CouponExpirationType.m1 => DateTime.now().add(Duration(days: 30)),
      CouponExpirationType.m3 => DateTime.now().add(Duration(days: 90)),
    };
    return DateRange(
      start: DateTime.now(),
      end: endDate.subtract(Duration(days: 1)),
    );
  }

  TextInputFormatter comparableNumericInputFormatter(int? maximumAmount) {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) {
        return newValue;
      }

      int value = int.parse(newValue.text.replaceAll(",", ""));
      if (value == 0) {
        if (newValue.text.length != 1) {
          return oldValue;
        }
        return newValue;
      }

      if (value <= maximumAmount!) {
        String formattedValue =
            value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
        bool isLastOffset = newValue.selection.end == newValue.text.length;
        int currentOffset = newValue.selection.end;
        return TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: isLastOffset ? formattedValue.length : currentOffset),
        );
      }
      return oldValue;
    });
  }

  List<TextInputFormatter> inputFormatterForNumericValue({int? maximumAmount}) {
    if (maximumAmount == null) {
      return [
        ...numericInputFormatter,
      ];
    }

    return [
      ...numericInputFormatter,
      comparableNumericInputFormatter(maximumAmount),
    ];
  }

  bool get submittable => switch (discountType) {
        CouponDiscountType.percentage => selectedExpirationType && selectedOrderType && maximumDiscountAmount != 0,
        CouponDiscountType.fixed => selectedExpirationType && selectedOrderType,
        _ => false,
      };

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          if (subTitle.isEmpty) ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
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
          ] else ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p4),
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
          ]
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "쿠폰 발급"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(
            children: [
              SGTypography.label("쿠폰명을 선택해주세요."),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              GestureDetector(
                onTap: () {
                  showSelectionBottomSheet<String>(
                      context: context,
                      title: "쿠폰명을 선택해주세요.",
                      options: couponNameOptions,
                      onSelect: (value) {
                        setState(() {
                          couponName = value;
                        });
                      },
                      selected: couponName);
                },
                child: SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Row(children: [
                    SGTypography.body(couponName, color: SGColors.gray5, size: FontSize.small, weight: FontWeight.w400),
                    Spacer(),
                    Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                  ]),
                )),
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("쿠폰 유형을 선택해주세요."),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SGRadioGroup(
                      items: [
                        SGRadioOption(label: " ~% 할인", value: CouponDiscountType.percentage),
                        SGRadioOption(label: " ~원 할인", value: CouponDiscountType.fixed),
                      ],
                      selected: discountType,
                      onChanged: (value) {
                        setState(() {
                          discountType = value;
                        });

                        _couponAmountController.text = "";
                      },
                      direction: Axis.vertical,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                ),
              )),
              if (discountType != null) ...[
                SizedBox(height: SGSpacing.p8),
                SGTypography.label(
                    discountType == CouponDiscountType.percentage ? "발행하실 쿠폰의 실할인율을 설정해주세요." : "발행하실 쿠폰의 금액을 설정해주세요."),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<int>(
                        context: context,
                        title: discountType == CouponDiscountType.percentage
                            ? "쿠폰 유형(%)을 선택해 주세요."
                            : "발행하실 쿠폰의 금액을 설정해주세요.",
                        options: discountType == CouponDiscountType.percentage
                            ? couponPercentageOptions
                            : couponAmountOptions,
                        onSelect: (value) {
                          setState(() {
                            couponAmount = value;
                          });
                        },
                        selected: couponAmount);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(children: [
                      SGTypography.body(
                          couponAmount == 0
                              ? ""
                              : discountType == CouponDiscountType.percentage
                                  ? "${couponAmount}% 할인"
                                  : "${couponAmount.toKoreanCurrency}원",
                          color: SGColors.gray5,
                          size: FontSize.small,
                          weight: FontWeight.w400),
                      Spacer(),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ],
              if (couponAmount != 0) ...[
                SizedBox(height: SGSpacing.p8),
                SGTypography.label("최소 주문 금액을 설정해주세요."),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        inputFormatters: [
                          ...inputFormatterForNumericValue(maximumAmount: 50000),
                        ],
                        controller: _minimumOrderAmountController,
                        onChanged: (value) {
                          setState(() {
                            minimumDiscountAmount = int.parse(value.replaceAll(",", "")) ?? 0;
                          });
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
                SizedBox(height: SGSpacing.p2),
                if (int.parse(_minimumOrderAmountController.text.replaceAll(',', '')) == 0) ... {
                } else  ... {
                  if ((int.parse(_minimumOrderAmountController.text.replaceAll(',', '')) < 5000 ||
                      int.parse(_minimumOrderAmountController.text.replaceAll(',', '')) >= 50000)) ... [
                    SGTypography.body(
                      "최소 주문 금액은 5,000원 이상 50,000원 미만으로 설정할 수 있습니다.",
                      color: SGColors.warningRed,
                      size: FontSize.tiny,
                      weight: FontWeight.w500,
                    ),
                  ],
                },
                SizedBox(height: SGSpacing.p3),
                SGTypography.body("쿠폰 사용에 있어 최소 주문 금액을 적어주시면 됩니다!", color: SGColors.gray4, size: FontSize.tiny),
              ],
              if (minimumDiscountAmount != 0) ...[
                if (discountType == CouponDiscountType.percentage) ...[
                  SizedBox(height: SGSpacing.p8),
                  SGTypography.label("최대 할인 금액을 설정해주세요."),
                  SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                  GestureDetector(
                    onTap: () {
                      showSelectionBottomSheet<int>(
                          context: context,
                          title: "최대 할인 금액을 설정해주세요.",
                          options: maximumDiscountAmountOptions,
                          onSelect: (value) {
                            setState(() {
                              maximumDiscountAmount = value;
                            });
                          },
                          selected: maximumDiscountAmount);
                    },
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      child: Row(children: [
                        SGTypography.body(
                            maximumDiscountAmount == 0 ? "" : "최대 ${maximumDiscountAmount.toKoreanCurrency}원 할인",
                            color: SGColors.gray5,
                            size: FontSize.small,
                            weight: FontWeight.w400),
                        Spacer(),
                        Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                      ]),
                    )),
                  ),
                ],
                if (discountType == CouponDiscountType.fixed || maximumDiscountAmount != 0) ...[
                  SizedBox(height: SGSpacing.p8),
                  SGTypography.label("유효기간을 설정해주세요."),
                  SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSelectionBottomSheet<CouponExpirationType>(
                              context: context,
                              title: "유효기간을 설정해주세요.",
                              options: expirationTypeOptions,
                              onSelect: (value) {
                                setState(() {
                                  expirationType = value;
                                  selectedExpirationType = true;
                                });
                              },
                              selected: expirationType);
                        },
                        child: SGContainer(
                          width: SGSpacing.p20 + SGSpacing.p2,
                          child: _DateRangeInputWrapper(
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Expanded(
                                child: SGTypography.body(
                              !selectedExpirationType ? "" : expirationType.labelName,
                              color: SGColors.black,
                              size: 15.0,
                              weight: FontWeight.w400,
                            )),
                            Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16)
                          ])),
                        ),
                      ),
                      SizedBox(width: SGSpacing.p3),
                      Expanded(
                          child: _DateRangeInputWrapper(
                              child: SGTypography.body(
                                  !selectedExpirationType
                                      ? ""
                                      : "${couponAvailableDateRange.start.koreanDateFormat} ~ ${couponAvailableDateRange.end.koreanDateFormat}",
                                  color: SGColors.black,
                                  size: 15.0,
                                  weight: FontWeight.w400))),
                    ],
                  ),
                ]
              ],
              if (selectedExpirationType) ...[
                SizedBox(height: SGSpacing.p8),
                SGTypography.label("주문 가능 유형을 선택해주세요."),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<OrderType>(
                        context: context,
                        title: "주문 가능 유형을 선택해주세요.",
                        options: orderTypeOptions,
                        onSelect: (value) {
                          setState(() {
                            orderType = value;
                            selectedOrderType = true;
                          });
                        },
                        selected: orderType);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(children: [
                      SGTypography.body(!selectedOrderType ? "" : orderType.labelName,
                          color: SGColors.gray5, size: FontSize.small, weight: FontWeight.w400),
                      Spacer(),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ],
              SizedBox(height: SGSpacing.p12),
              if (submittable) ...[
                SGActionButton(
                    onPressed: () {
                      showSGDialogWithCloseButton(
                          context: context,
                          childrenBuilder: (ctx) => [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SGTypography.body("쿠폰 발급이 완료되었습니다!",
                                        size: FontSize.medium, weight: FontWeight.w700),
                                  ],
                                ),
                                SizedBox(height: SGSpacing.p4),
                                GestureDetector(
                                  onTap: () {
                                    showFailDialogWithImage(mainTitle:  "쿠폰 발급 실패", subTitle: "이미 동일한 조건의 쿠폰이 발급되었습니다.\n다른 쿠폰을 확인해주세요.");
                                    context.read<CouponListBloc>().add(AddCoupon(
                                          CouponModel(
                                            id: couponId,
                                            name: couponName,
                                            discountType: discountType!,
                                            discountAmount: couponAmount,
                                            minimumOrderAmount: int.parse(
                                              _minimumOrderAmountController.text.replaceAll(",", ""),
                                            ),
                                            maximumDiscountAmount: maximumDiscountAmount,
                                            startDate: couponAvailableDateRange.start,
                                            endDate: couponAvailableDateRange.end,
                                            expirationType: expirationType,
                                            orderType: orderType,
                                          ),
                                        ));

                                    Navigator.of(ctx).pop();
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
                              ]);
                      return;
                    },
                    label: "쿠폰 발급하기")
              ]
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
      borderColor: SGColors.line3,
      padding: EdgeInsets.all(SGSpacing.p3).copyWith(right: SGSpacing.p3 + SGSpacing.p05),
      child: child,
    );
  }
}
