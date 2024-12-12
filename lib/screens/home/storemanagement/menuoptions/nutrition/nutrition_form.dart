import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../core/components/numeric_textfield.dart';
import '../model.dart';

class NutritionForm extends StatefulWidget {
  final NutritionModel nutrition;

  final Function(NutritionModel, BuildContext) onChanged;

  const NutritionForm({
    super.key,
    required this.nutrition,
    required this.onChanged,
  });

  @override
  State<NutritionForm> createState() => _NutritionFormState();
}

class _NutritionFormState extends State<NutritionForm> {
  late NutritionModel nutrition = widget.nutrition;
  late bool quantityIsNone = false;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          NutritionFormField(
              label: "칼로리",
              unit: "kcal",
              value: nutrition.calories,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(calories: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.body("제공량", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
              borderRadius: BorderRadius.circular(SGSpacing.p4),
              borderColor: SGColors.line2,
              color: SGColors.white,
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
              width: double.infinity,
              child: Column(
                children: [
                  Row(children: [
                    SGTypography.body("${quantityIsNone ? '-- ' : nutrition.servingAmount.toKoreanCurrency}${nutrition.servingAmountType}", size: FontSize.large, weight: FontWeight.w600, color: quantityIsNone ? SGColors.gray3 : SGColors.black),
                    Spacer(),
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            quantityIsNone = !quantityIsNone;
                          });
                        },
                        child: Image.asset("assets/images/circle-checkbox-${quantityIsNone ? 'on' : 'off'}.png", width: SGSpacing.p6, height: SGSpacing.p6),
                      ),
                      SizedBox(width: SGSpacing.p1),
                      SGTypography.body("내용없음", size: FontSize.small, weight: FontWeight.w500, color: SGColors.black),
                    ])
                  ]),
                  // SizedBox(width: SGSpacing.p2),
                  if (!quantityIsNone) ...[
                    SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
                    GestureDetector(
                      onTap: () {
                        showSelectionBottomSheet(
                            context: context,
                            title: "단위",
                            options: [
                              SelectionOption(label: "g", value: "g"),
                              SelectionOption(label: "ml", value: "ml"),
                            ],
                            onSelect: (value) {
                              setState(() {
                                nutrition = nutrition.copyWith(servingAmountType: value);
                              });
                            },
                            selected: nutrition.servingAmountType);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: SGTextFieldWrapper(
                                child: SGContainer(
                              padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: NumericTextField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                                        hintText: "수정할 값을 입력해주세요.",
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                                      ),
                                      onValueChanged: (inputValue) {
                                        setState(() {
                                          nutrition = nutrition.copyWith(servingAmount: inputValue);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ),
                          SizedBox(width: SGSpacing.p2),
                          IntrinsicHeight(
                            child: SGTextFieldWrapper(
                              child: SGContainer(
                                padding: EdgeInsets.all(SGSpacing.p4),
                                width: SGSpacing.p20 + (SGSpacing.p5 / 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SGContainer(child: SGTypography.body(nutrition.servingAmountType, size: FontSize.normal, weight: FontWeight.w500)),
                                    Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p4, height: SGSpacing.p4),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ]),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "탄수화물",
              unit: "g",
              value: nutrition.carbohydrate,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(carbohydrate: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "단백질",
              unit: "g",
              value: nutrition.protein,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(protein: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "지방",
              unit: "g",
              value: nutrition.fat,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(fat: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "당",
              unit: "g",
              value: nutrition.sugar,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(sugar: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "포화지방",
              unit: "g",
              value: nutrition.saturatedFat,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(saturatedFat: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p6),
          NutritionFormField(
              label: "나트륨",
              unit: "mg",
              value: nutrition.natrium,
              onChanged: (value) {
                setState(() {
                  nutrition = nutrition.copyWith(natrium: value.toInt());
                });
              }),
          SizedBox(height: SGSpacing.p32),
          SGActionButton(
            onPressed: () {
              widget.onChanged(nutrition, context);
            },
            label: "설정하기",
          )
        ]));
  }
}

class NutritionFormField extends StatefulWidget {
  final String label;
  final String unit;
  final int? value;
  final Function(double) onChanged;

  NutritionFormField({required this.label, required this.unit, required this.value, required this.onChanged});

  @override
  State<NutritionFormField> createState() => _NutritionFormFieldState();
}

class _NutritionFormFieldState extends State<NutritionFormField> {
  bool isNone = false;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SGTypography.body(widget.label, size: FontSize.normal, weight: FontWeight.w700),
      SizedBox(height: SGSpacing.p3),
      SGContainer(
        borderRadius: BorderRadius.circular(SGSpacing.p4),
        borderColor: SGColors.line2,
        color: SGColors.white,
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
        width: double.infinity,
        child: Column(
          children: [
            Row(children: [
              SGTypography.body("${isNone ? '-- ' : widget.value!.toKoreanCurrency}${widget.unit}", size: FontSize.large, weight: FontWeight.w600, color: isNone ? SGColors.gray3 : SGColors.black),
              Spacer(),
              Row(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isNone = !isNone;
                      widget.onChanged(0);
                    });
                  },
                  child: Image.asset("assets/images/circle-checkbox-${isNone ? 'on' : 'off'}.png", width: SGSpacing.p6, height: SGSpacing.p6),
                ),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("내용없음", size: FontSize.small, weight: FontWeight.w500, color: SGColors.black),
              ])
            ]),
            // SizedBox(width: SGSpacing.p2),
            if (!isNone) ...[
              SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: NumericTextField(
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                          hintText: "수정할 값을 입력해주세요.",
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onValueChanged: (inputValue) {
                          setState(() {
                            widget.onChanged(inputValue.toDouble());
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )),
            ]
          ],
        ),
      ),
    ]);
  }
}
