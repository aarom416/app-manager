import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/main.dart';

import '../../../../../core/components/app_bar_with_left_arrow.dart';
import '../../../../../core/components/numeric_textfield.dart';
import '../model.dart';

class UpdateNutritionScreen extends StatefulWidget {
  String title;
  NutritionModel nutrition;
  Function(NutritionModel, BuildContext) onConfirm;

  UpdateNutritionScreen({super.key, required this.title, required this.nutrition, required this.onConfirm});

  @override
  State<UpdateNutritionScreen> createState() => _UpdateNutritionScreenState();
}

class _UpdateNutritionScreenState extends State<UpdateNutritionScreen> {
  late NutritionModel nutrition;
  late Map<String, bool> isNoneMap; // 각 필드의 None 상태

  @override
  void initState() {
    super.initState();
    nutrition = widget.nutrition;
    isNoneMap = {
      'calories': false,
      'servingAmount': false,
      'carbohydrate': false,
      'protein': false,
      'fat': false,
      'sugar': false,
      'saturatedFat': false,
      'natrium': false,
    };
  }

  void _handleToggleNone(String field, bool newValue) {
    setState(() {
      isNoneMap[field] = newValue;
      switch (field) {
        case 'calories':
          nutrition = nutrition.copyWith(calories: newValue ? 0 : nutrition.calories);
          break;
        case 'servingAmount':
          nutrition = nutrition.copyWith(servingAmount: newValue ? 0 : nutrition.servingAmount);
          break;
        case 'carbohydrate':
          nutrition = nutrition.copyWith(carbohydrate: newValue ? 0 : nutrition.carbohydrate);
          break;
        case 'protein':
          nutrition = nutrition.copyWith(protein: newValue ? 0 : nutrition.protein);
          break;
        case 'fat':
          nutrition = nutrition.copyWith(fat: newValue ? 0 : nutrition.fat);
          break;
        case 'sugar':
          nutrition = nutrition.copyWith(sugar: newValue ? 0 : nutrition.sugar);
          break;
        case 'saturatedFat':
          nutrition = nutrition.copyWith(saturatedFat: newValue ? 0 : nutrition.saturatedFat);
          break;
        case 'natrium':
          nutrition = nutrition.copyWith(natrium: newValue ? 0 : nutrition.natrium);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      body: Material(
        child: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(
            children: [
              NutritionFormField(
                label: "칼로리",
                unit: "kcal",
                originValue: nutrition.calories.toDouble(),
                value: nutrition.calories,
                isNone: isNoneMap['calories']!,
                onToggleNone: (newValue) => _handleToggleNone('calories', newValue),
                onChanged: (value) {
                  setState(() {
                    nutrition = nutrition.copyWith(calories: value);
                  });
                },
              ),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                label: "제공량",
                unit: nutrition.servingAmountType,
                originValue: nutrition.servingAmount.toDouble(),
                value: nutrition.servingAmount.toDouble(),
                isNone: isNoneMap['servingAmount']!,
                onToggleNone: (newValue) => _handleToggleNone('servingAmount', newValue),
                onChanged: (value) {
                  setState(() {
                    nutrition = nutrition.copyWith(servingAmount: value);
                  });
                },
                additionalContent: GestureDetector(
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
                          logger.d("onSelect servingAmountType $value");
                          nutrition = nutrition.copyWith(servingAmountType: value);
                        });
                      },
                      selected: nutrition.servingAmountType,
                    );
                  },
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
              ),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  label: "탄수화물",
                  unit: "g",
                  originValue: nutrition.carbohydrate.toDouble(),
                  value: nutrition.carbohydrate,
                  isNone: isNoneMap['carbohydrate']!,
                  onToggleNone: (newValue) => _handleToggleNone('carbohydrate', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(carbohydrate: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  key: const ValueKey('protein'),
                  label: "단백질",
                  unit: "g",
                  originValue: nutrition.protein,
                  value: nutrition.protein,
                  isNone: isNoneMap['protein']!,
                  onToggleNone: (newValue) => _handleToggleNone('protein', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(protein: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  key: const ValueKey('fat'),
                  label: "지방",
                  unit: "g",
                  originValue: nutrition.fat.toDouble(),
                  value: nutrition.fat,
                  isNone: isNoneMap['fat']!,
                  onToggleNone: (newValue) => _handleToggleNone('fat', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(fat: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  key: const ValueKey('sugar'),
                  label: "당",
                  unit: "g",
                  originValue: nutrition.sugar.toDouble(),
                  value: nutrition.sugar,
                  isNone: isNoneMap['sugar']!,
                  onToggleNone: (newValue) => _handleToggleNone('sugar', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(sugar: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  key: const ValueKey('saturatedFat'),
                  label: "포화지방",
                  unit: "g",
                  originValue: nutrition.saturatedFat.toDouble(),
                  value: nutrition.saturatedFat,
                  isNone: isNoneMap['saturatedFat']!,
                  onToggleNone: (newValue) => _handleToggleNone('saturatedFat', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(saturatedFat: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p6),
              NutritionFormField(
                  key: const ValueKey('natrium'),
                  label: "나트륨",
                  unit: "mg",
                  originValue: nutrition.natrium,
                  value: nutrition.natrium,
                  isNone: isNoneMap['natrium']!,
                  onToggleNone: (newValue) => _handleToggleNone('natrium', newValue),
                  onChanged: (value) {
                    setState(() {
                      nutrition = nutrition.copyWith(natrium: value);
                    });
                  }),
              SizedBox(height: SGSpacing.p32),
              SGActionButton(
                onPressed: () {
                  // logger.d("onPressed nutrition ${nutrition.toFormattedJson()}");
                  widget.onConfirm(nutrition, context);
                },
                label: "수정하기",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NutritionFormField extends StatelessWidget {
  final String label;
  final String unit;
  final double originValue;
  final double value;
  final bool isNone;
  final Function(bool) onToggleNone;
  final Function(double) onChanged;
  final Widget? additionalContent;

  const NutritionFormField({
    super.key,
    required this.label,
    required this.unit,
    required this.originValue,
    required this.value,
    required this.isNone,
    required this.onToggleNone,
    required this.onChanged,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SGTypography.body(label, size: FontSize.normal, weight: FontWeight.w700),
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
                SGTypography.body(
                  "${isNone ? '-- ' : originValue}${unit}",
                  size: FontSize.large,
                  weight: FontWeight.w600,
                  color: isNone ? SGColors.gray3 : SGColors.black,
                ),
                const Spacer(),
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      onToggleNone(!isNone);
                    },
                    child: Image.asset(
                      "assets/images/circle-checkbox-${isNone ? 'on' : 'off'}.png",
                      width: SGSpacing.p6,
                      height: SGSpacing.p6,
                    ),
                  ),
                  SizedBox(width: SGSpacing.p1),
                  SGTypography.body("내용없음", size: FontSize.small, weight: FontWeight.w500, color: SGColors.black),
                ]),
              ]),
              if (!isNone) ...[
                SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SGTextFieldWrapper(
                        child: SGContainer(
                          padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                          width: double.infinity,
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "수정할 값을 입력해주세요.",
                              border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            ),
                            onChanged: (inputValue) {
                              // 입력값 그대로 처리하여 보여지게 함
                              if (inputValue.isNotEmpty) {
                                // 그대로 값 표시 (변환 없이 그대로)
                                onChanged(double.tryParse(inputValue) ?? 0.0);  // 기본적으로 0.0 처리
                              } else {
                                onChanged(0.0); // 값이 비어있으면 0으로 처리
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    if (additionalContent != null) ...[
                      SizedBox(width: SGSpacing.p3),
                      additionalContent!,
                    ],
                  ],
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}








