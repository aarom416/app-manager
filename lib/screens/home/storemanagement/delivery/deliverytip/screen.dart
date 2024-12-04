import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/utils/string.dart';

import '../../../../../core/components/dialog.dart';
import '../../../../../core/components/multiple_information_box.dart';
import '../../../../../core/utils/formatter.dart';
import '../../../../../utils/time_utils.dart';
import '../model.dart';
import 'delivery_tip_box.dart';

class DeliveryTipScreen extends StatefulWidget {
  final int baseDeliveryTip;
  final int baseDeliveryTipMax;
  final int minimumOrderPrice;
  final List<DeliveryTipModel> storeDeliveryTipDTOList;
  final Function(int, int, List<DeliveryTipModel>) onSaveFunction;

  const DeliveryTipScreen({super.key, required this.baseDeliveryTip, required this.baseDeliveryTipMax, required this.minimumOrderPrice, required this.storeDeliveryTipDTOList, required this.onSaveFunction});

  @override
  State<DeliveryTipScreen> createState() => _DeliveryTipScreenState();
}

class _DeliveryTipScreenState extends State<DeliveryTipScreen> {
  int minOrderPrice = 0;
  int maxOrderPrice = 12000;
  int orderDeliveryTip = 3000;
  late TextEditingController minOrderPriceController;
  late TextEditingController maxOrderPriceController;
  late TextEditingController orderDeliveryTipController;
  List<AdditionalDeliveryTip> additionalDeliveryTips = [];
  bool isButtonEnabled = true;

  late int baseDeliveryTip;
  late int minimumOrderPrice;
  late List<DeliveryTipModel> storeDeliveryTipDTOList;
  late TextEditingController minimumOrderPriceController;
  late TextEditingController baseDeliveryTipController;

  @override
  void initState() {
    super.initState();
    baseDeliveryTip = widget.baseDeliveryTip;
    minimumOrderPrice = widget.minimumOrderPrice;
    storeDeliveryTipDTOList = widget.storeDeliveryTipDTOList;
    minimumOrderPriceController = TextEditingController(text: minimumOrderPrice.toKoreanCurrency);
    baseDeliveryTipController = TextEditingController(text: baseDeliveryTip.toKoreanCurrency);
  }

  @override
  void dispose() {
    minimumOrderPriceController.dispose();
    baseDeliveryTipController.dispose();
    super.dispose();
  }

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              if (subTitle.isEmpty) ...[
                Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
                    child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                  ),
                )
              ] else ...[
                Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                SizedBox(height: SGSpacing.p4),
                Center(child: SGTypography.body(subTitle, color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
                    child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                  ),
                )
              ]
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "배달팁 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: false,
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (baseDeliveryTip > widget.baseDeliveryTipMax) {
                  // todo 모든 배달팁에 적용되는듯
                  showFailDialogWithImage(mainTitle: "배달팁 등록 실패", subTitle: "배달팁은 ${widget.baseDeliveryTipMax.toKoreanCurrency}원 이하만 설정 가능합니다.");
                } else {
                  widget.onSaveFunction(baseDeliveryTip, minimumOrderPrice, storeDeliveryTipDTOList);
                  Navigator.of(context).pop();
                }
              },
              label: "변경하기")),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            // --------------------------- 기본 배달팁 ---------------------------
            SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              SGTypography.body("최소 주문 금액 설정", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p4),
              Row(children: [
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minimumOrderPriceController,
                          style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (minimumOrderPrice) {
                            setState(() {
                              this.minimumOrderPrice = minimumOrderPrice.toIntFromCurrency;
                            });
                          },
                        ),
                      ),
                      SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 이상", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                    ],
                  )),
                ),
                SizedBox(width: SGSpacing.p2),
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: baseDeliveryTipController,
                          style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (baseDeliveryTip) {
                            setState(() {
                              this.baseDeliveryTip = baseDeliveryTip.toIntFromCurrency;
                            });
                          },
                        ),
                      ),
                      SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                    ],
                  )),
                ),
              ])
            ]),

            SizedBox(height: SGSpacing.p5),

            // --------------------------- 배달팁 추가 ---------------------------
            SGTypography.body("배달팁 추가", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            DeliveryTipBox(
              storeDeliveryTipDTOList: storeDeliveryTipDTOList,
              onEditFunction: (storeDeliveryTipDTOList) {
                // print("onEditFunction storeDeliveryTipDTOList storeDeliveryTipDTOList");
                setState(() {
                  this.storeDeliveryTipDTOList = storeDeliveryTipDTOList;
                });
              },
            ),

            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SGTypography.body("*", color: SGColors.gray3, lineHeight: 1.25), SizedBox(width: SGSpacing.p1), SGTypography.body("30,000원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는  동일한 배달팁이 적용돼요", color: SGColors.gray3, lineHeight: 1.25)]),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
}

class AdditionalDeliveryTip {
  final int id;
  final int minPrice;
  final int maxPrice;
  final int deliveryTip;

  AdditionalDeliveryTip({required this.id, required this.minPrice, required this.maxPrice, required this.deliveryTip});

  AdditionalDeliveryTip copyWith({int? minimumPrice, int? maximumPrice, int? tip}) {
    return AdditionalDeliveryTip(
      id: id,
      minPrice: minimumPrice ?? this.minPrice,
      maxPrice: maximumPrice ?? this.maxPrice,
      deliveryTip: tip ?? this.deliveryTip,
    );
  }
}

class _DeliveryTipBox extends StatefulWidget {
  final List<AdditionalDeliveryTip> additionalDeliveryTips;
  final int minimumPrice;
  final Function(List<AdditionalDeliveryTip>) onAdditionalDeliveryTipsChanged;

  const _DeliveryTipBox({super.key, required this.minimumPrice, required this.additionalDeliveryTips, required this.onAdditionalDeliveryTipsChanged});

  @override
  State<_DeliveryTipBox> createState() => _DeliveryTipBoxState();
}

class _DeliveryTipBoxState extends State<_DeliveryTipBox> {
  bool isEditing = false;

  late List<TextEditingController> minimumPriceControllers;
  late List<TextEditingController> maximumPriceControllers;
  late List<TextEditingController> tipControllers;

  late List<AdditionalDeliveryTip> additionalDeliveryTips;

  @override
  void initState() {
    super.initState();
    minimumPriceControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.minPrice.toKoreanCurrency)).toList();
    maximumPriceControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.maxPrice.toKoreanCurrency)).toList();
    tipControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.deliveryTip.toKoreanCurrency)).toList();
    additionalDeliveryTips = widget.additionalDeliveryTips;
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      ...additionalDeliveryTips.mapIndexed((index, tip) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.body("주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: minimumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(minimumPrice: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 이상", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: maximumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(maximumPrice: int.parse(value.replaceAll(",", "")));
                          });
                        },
                      ),
                    ),
                    SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 미만", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
              SizedBox(width: SGSpacing.p2),
              SGContainer(
                  width: SGSpacing.p5,
                  height: SGSpacing.p5,
                  borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                  color: SGColors.warningRed,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          additionalDeliveryTips = [...additionalDeliveryTips.sublist(0, index), ...additionalDeliveryTips.sublist(index + 1)];
                          minimumPriceControllers = [...minimumPriceControllers.sublist(0, index), ...minimumPriceControllers.sublist(index + 1)];
                          maximumPriceControllers = [...maximumPriceControllers.sublist(0, index), ...maximumPriceControllers.sublist(index + 1)];
                          tipControllers = [...tipControllers.sublist(0, index), ...tipControllers.sublist(index + 1)];
                        });
                      },
                      child: Center(
                        child: Image.asset('assets/images/minus-white.png', width: 16, height: 16),
                      ))),
            ]),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("배달팁", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: tipControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(tip: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
            ]),
            SizedBox(height: SGSpacing.p5),
          ])),
      if (!isEditing) ...[
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = true;

                      if (isEditing) {
                        final newAdditionalDeliveryTip = AdditionalDeliveryTip(id: DateTime.now().millisecondsSinceEpoch, minPrice: widget.minimumPrice, maxPrice: 0, deliveryTip: 3000);
                        additionalDeliveryTips = [...additionalDeliveryTips, newAdditionalDeliveryTip];

                        minimumPriceControllers = [...minimumPriceControllers, TextEditingController(text: widget.minimumPrice.toKoreanCurrency)];

                        maximumPriceControllers = [...maximumPriceControllers, TextEditingController(text: newAdditionalDeliveryTip.maxPrice.toKoreanCurrency)];

                        tipControllers = [...tipControllers, TextEditingController(text: newAdditionalDeliveryTip.deliveryTip.toKoreanCurrency)];
                        widget.onAdditionalDeliveryTipsChanged(additionalDeliveryTips);
                      }
                    });
                  },
                  child: Image.asset("assets/images/accumulative.png", width: 24, height: 24)),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body("배달팁 추가하기", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
            ],
          ),
        )
      ],
    ]);
  }
}
