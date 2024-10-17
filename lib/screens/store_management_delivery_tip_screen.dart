import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/formatter.dart';

class StoreManagementDeliveryTipScreen extends StatelessWidget {
  List<(String, String)> baseDeliveryTip = [('주문 금액', '배달팁'), ('3,000원 이상', '4,000원')];

  List<(String, String)> additionalDeliveryTip = [
    ('26,000원 ~ 39,999원', '4,000원'),
    ('40,000원 ~ 49,999원', '3,000원'),
    ('50,000원 이상', '0원'),
  ];

  StoreManagementDeliveryTipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SGContainer(
            padding: EdgeInsets.all(SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            color: SGColors.white,
            borderColor: SGColors.line2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => _EditDeliveryTipScreen()));
                },
                child: Row(children: [
                  SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p2),
                  Icon(Icons.edit, size: FontSize.small),
                ]),
              ),
              SizedBox(height: SGSpacing.p5),
              SGTypography.body("최소 주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p5 / 2),
              Table(
                  border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)),
                  children: [
                    ...baseDeliveryTip.map((tip) => TableRow(children: [
                          Center(
                              child: SGContainer(
                                  padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                  child: SGTypography.body(tip.$1, color: SGColors.black, weight: FontWeight.w700))),
                          Center(
                              child: SGContainer(
                                  padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                  child: SGTypography.body(tip.$2, color: SGColors.gray5, weight: FontWeight.w500))),
                        ])),
                  ]),
              SizedBox(height: SGSpacing.p4),
              SGTypography.body("배달팁 추가", color: SGColors.gray4, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p5 / 2),
              Table(
                  border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)),
                  children: [
                    ...additionalDeliveryTip.map((tip) => TableRow(children: [
                          Center(
                              child: SGContainer(
                                  padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                  child: SGTypography.body(tip.$1, color: SGColors.black, weight: FontWeight.w700))),
                          Center(
                              child: SGContainer(
                                  padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                  child: SGTypography.body(tip.$2, color: SGColors.gray5, weight: FontWeight.w500))),
                        ])),
                  ]),
            ])),
        SizedBox(height: SGSpacing.p3),
        MultipleInformationBox(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SGTypography.body("배달 지역", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SGTypography.body("현재는 역삼동에서만 배달 가능해요.", color: SGColors.gray4, size: FontSize.normal)
          ])
        ])
      ],
    );
  }
}

class _EditDeliveryTipScreen extends StatefulWidget {
  const _EditDeliveryTipScreen({
    super.key,
  });

  @override
  State<_EditDeliveryTipScreen> createState() => _EditDeliveryTipScreenState();
}

class AdditionalDeliveryTip {
  final int id;
  final int minimumPrice;
  final int maximumPrice;
  final int tip;

  AdditionalDeliveryTip({required this.id, required this.minimumPrice, required this.maximumPrice, required this.tip});

  AdditionalDeliveryTip copyWith({int? minimumPrice, int? maximumPrice, int? tip}) {
    return AdditionalDeliveryTip(
      id: id,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
      tip: tip ?? this.tip,
    );
  }
}

class _EditDeliveryTipScreenState extends State<_EditDeliveryTipScreen> {
  int defaulDelieryTip = 4000;
  int minimumPrice = 16000;

  late TextEditingController minimumPriceController;
  late TextEditingController defaulDelieryTipController;

  List<AdditionalDeliveryTip> additionalDeliveryTips = [];

  @override
  void initState() {
    super.initState();
    minimumPriceController = TextEditingController(text: minimumPrice.toKoreanCurrency);
    defaulDelieryTipController = TextEditingController(text: defaulDelieryTip.toKoreanCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "배달팁 수정"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              SGTypography.body("최소 주문 금액 설정", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p4),
              Row(children: [
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minimumPriceController,
                          style:
                              TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            comparableNumericInputFormatter(1000000000)
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray3),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (value) {
                            value = value.replaceAll(",", "");
                            setState(() {
                              minimumPrice = int.parse(value);
                            });
                          },
                        ),
                      ),
                      SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원 이상",
                              color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                          controller: defaulDelieryTipController,
                          style:
                              TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            comparableNumericInputFormatter(1000000000)
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray3),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (value) {
                            setState(() {
                              defaulDelieryTip = int.parse(value.replaceAll(",", ""));
                            });
                          },
                        ),
                      ),
                      SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원",
                              color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                    ],
                  )),
                ),
              ])
            ]),
            SizedBox(height: SGSpacing.p5),
            SGTypography.body("배달팁 추가", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            _AdditionalDeliveryTipForm(
                key: ValueKey([0, ...additionalDeliveryTips.map((tip) => tip.id)].reduce((a, b) => a ^ b)),
                additionalDeliveryTips: additionalDeliveryTips,
                minimumPrice: minimumPrice,
                onAdditionalDeliveryTipsChanged: (tips) {
                  setState(() {
                    additionalDeliveryTips = tips;
                  });
                }),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("*", color: SGColors.gray3, lineHeight: 1.25),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body("30,000원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는  동일한 배달팁이 적용돼요",
                  color: SGColors.gray3, lineHeight: 1.25)
            ]),
            SizedBox(height: SGSpacing.p20),
            SGActionButton(
              onPressed: () {},
              label: "변경하기",
              disabled: true,
            )
          ])),
    );
  }
}

class _AdditionalDeliveryTipForm extends StatefulWidget {
  final List<AdditionalDeliveryTip> additionalDeliveryTips;
  final int minimumPrice;
  final Function(List<AdditionalDeliveryTip>) onAdditionalDeliveryTipsChanged;

  _AdditionalDeliveryTipForm(
      {super.key,
      required this.minimumPrice,
      required this.additionalDeliveryTips,
      required this.onAdditionalDeliveryTipsChanged});

  @override
  State<_AdditionalDeliveryTipForm> createState() => _AdditionalDeliveryTipFormState();
}

class _AdditionalDeliveryTipFormState extends State<_AdditionalDeliveryTipForm> {
  bool isEditing = false;

  late List<TextEditingController> minimumPriceControllers;
  late List<TextEditingController> maximumPriceControllers;
  late List<TextEditingController> tipControllers;

  late List<AdditionalDeliveryTip> additionalDeliveryTips;

  @override
  void initState() {
    super.initState();
    minimumPriceControllers = widget.additionalDeliveryTips
        .map((tip) => TextEditingController(text: tip.minimumPrice.toKoreanCurrency))
        .toList();
    maximumPriceControllers = widget.additionalDeliveryTips
        .map((tip) => TextEditingController(text: tip.maximumPrice.toKoreanCurrency))
        .toList();
    tipControllers =
        widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.tip.toKoreanCurrency)).toList();
    additionalDeliveryTips = widget.additionalDeliveryTips;
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SGTypography.body("최소 주문 금액 설정", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
          if (widget.additionalDeliveryTips.isEmpty)
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.onAdditionalDeliveryTipsChanged([
                      AdditionalDeliveryTip(
                          id: DateTime.now().millisecondsSinceEpoch,
                          minimumPrice: widget.minimumPrice,
                          maximumPrice: 0,
                          tip: 3000),
                    ]);
                    isEditing = true;
                  });
                },
                child: SGTypography.body("추가", color: SGColors.gray3, size: FontSize.small))
          else
            GestureDetector(
              onTap: () {
                if (isEditing) {
                  widget.onAdditionalDeliveryTipsChanged(additionalDeliveryTips);
                  setState(() {
                    isEditing = !isEditing;
                  });
                } else {
                  setState(() {
                    isEditing = !isEditing;
                  });
                }
              },
              child: SGTypography.body(isEditing ? "완료" : "수정",
                  color: isEditing ? SGColors.primary : SGColors.gray3, size: FontSize.small),
            ),
        ],
      ),
      ...additionalDeliveryTips.mapIndexed((index, tip) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: !isEditing,
                        controller: minimumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(minimumPrice: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원 이상",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                        readOnly: !isEditing,
                        controller: maximumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          setState(() {
                            additionalDeliveryTips[index] =
                                tip.copyWith(maximumPrice: int.parse(value.replaceAll(",", "")));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원 미만",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
              if (index != 0 && isEditing) ...[
                SizedBox(width: SGSpacing.p2),
                SGContainer(
                    width: SGSpacing.p5,
                    height: SGSpacing.p5,
                    borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                    color: SGColors.warningRed,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            additionalDeliveryTips = [
                              ...additionalDeliveryTips.sublist(0, index),
                              ...additionalDeliveryTips.sublist(index + 1)
                            ];
                            minimumPriceControllers = [
                              ...minimumPriceControllers.sublist(0, index),
                              ...minimumPriceControllers.sublist(index + 1)
                            ];
                            maximumPriceControllers = [
                              ...maximumPriceControllers.sublist(0, index),
                              ...maximumPriceControllers.sublist(index + 1)
                            ];
                            tipControllers = [
                              ...tipControllers.sublist(0, index),
                              ...tipControllers.sublist(index + 1)
                            ];
                          });
                        },
                        child: Center(
                          child: Image.asset('assets/images/minus-white.png', width: 16, height: 16),
                        ))),
              ]
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
                        readOnly: !isEditing,
                        controller: tipControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(tip: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
            ]),
          ])),
      if (isEditing) ...[
        SizedBox(height: SGSpacing.p5),
        GestureDetector(
            onTap: () {
              setState(() {
                final newAdditionalDeliveryTip = AdditionalDeliveryTip(
                    id: DateTime.now().millisecondsSinceEpoch,
                    minimumPrice: widget.minimumPrice,
                    maximumPrice: 0,
                    tip: 3000);
                additionalDeliveryTips = [...additionalDeliveryTips, newAdditionalDeliveryTip];

                minimumPriceControllers = [
                  ...minimumPriceControllers,
                  TextEditingController(text: widget.minimumPrice.toKoreanCurrency)
                ];

                maximumPriceControllers = [
                  ...maximumPriceControllers,
                  TextEditingController(text: newAdditionalDeliveryTip.maximumPrice.toKoreanCurrency)
                ];

                tipControllers = [
                  ...tipControllers,
                  TextEditingController(text: newAdditionalDeliveryTip.tip.toKoreanCurrency)
                ];
              });
            },
            child: SGContainer(
                borderColor: SGColors.primary,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/plus.png', width: 12, height: 12),
                    SizedBox(width: SGSpacing.p2),
                    SGTypography.body("추가", color: SGColors.primary, size: FontSize.small),
                  ],
                ))))
      ],
    ]);
  }
}
