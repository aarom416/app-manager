import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import 'model.dart';

class NutritionCard extends StatelessWidget {
  final Nutrition nutrition;
  final String servingAmountType;
  final int servingAmount;
  final VoidCallback? onTap;

  const NutritionCard({
    super.key,
    required this.nutrition,
    this.servingAmountType = "g",
    this.servingAmount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        borderRadius: BorderRadius.circular(SGSpacing.p4),
        color: SGColors.white,
        borderWidth: 2,
        borderColor: SGColors.primary,
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
        child: Column(children: [
          GestureDetector(
            onTap: () {
              this.onTap?.call();
            },
            child: Row(children: [
              SGTypography.body("메뉴 영양성분", size: FontSize.normal, color: SGColors.black, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p2),
              const Icon(Icons.edit, size: FontSize.small),
            ]),
          ),
          SizedBox(height: SGSpacing.p2),
          SGContainer(
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("총 칼로리", size: FontSize.normal, color: SGColors.gray5, weight: FontWeight.w500),
                SGTypography.body("${(nutrition.calories ?? 0).toKoreanCurrency}Kcal", size: FontSize.large, weight: FontWeight.w700, color: SGColors.primary),
              ])),
          SizedBox(height: SGSpacing.p1),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
            SGTypography.body("총 제공량 (g,ml)", size: FontSize.normal, color: SGColors.gray4, weight: FontWeight.w500),
            SGTypography.body("$servingAmount$servingAmountType", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.gray5)
          ]),
          SizedBox(height: SGSpacing.p5),
          Divider(thickness: 1, color: SGColors.line1, height: 1),
          SizedBox(height: SGSpacing.p5),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SGTypography.body("탄수화물", size: FontSize.normal, color: SGColors.gray4, weight: FontWeight.w500), SGTypography.body("${nutrition.carbohydrate}g", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.gray5)]),
          SizedBox(height: SGSpacing.p6),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SGTypography.body("단백질", size: FontSize.normal, color: SGColors.gray4, weight: FontWeight.w500), SGTypography.body("${nutrition.protein}g", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.gray5)]),
          SizedBox(height: SGSpacing.p6),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SGTypography.body("지방", size: FontSize.normal, color: SGColors.gray4, weight: FontWeight.w500), SGTypography.body("${nutrition.fat}g", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.gray5)]),
          SizedBox(height: SGSpacing.p2),
          SGContainer(
              color: SGColors.gray1,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                Expanded(child: Column(children: [SGTypography.body("당", size: FontSize.small, color: SGColors.gray5), SizedBox(height: SGSpacing.p1), SGTypography.body("${nutrition.sugar}g", size: FontSize.normal, color: SGColors.gray5)])),
                SGContainer(width: 1, height: SGSpacing.p8, color: SGColors.line1),
                Expanded(
                    child: Column(children: [SGTypography.body("포화지방", size: FontSize.small, color: SGColors.gray5), SizedBox(height: SGSpacing.p1), SGTypography.body("${nutrition.saturatedFat}g", size: FontSize.normal, color: SGColors.gray5)])),
                SGContainer(width: 1, height: SGSpacing.p8, color: SGColors.line1),
                Expanded(child: Column(children: [SGTypography.body("나트륨", size: FontSize.small, color: SGColors.gray5), SizedBox(height: SGSpacing.p1), SGTypography.body("${nutrition.sodium} mg", size: FontSize.normal, color: SGColors.gray5)])),
              ]))
        ]));
  }
}
