import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../model.dart';

class MenuOptionCategoryCard extends StatelessWidget {
  final MenuOptionCategoryModel category;

  const MenuOptionCategoryCard({super.key, required this.category});

  String get selectionType {
    if (category.essentialStatus==1) return "(필수)";
    return "(선택 최대 ${category.maxChoice ?? 0}개)";
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          child: SGTypography.body(
              category.menuOptionCategoryName,
              size: FontSize.normal,
              weight: FontWeight.w600,
          )
        ),
        SizedBox(width: SGSpacing.p1),
        SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
      ]),
      ...category.menuOptions
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                MenuOptionDataTableRow(left: option.optionContent ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened
    ]);
  }
}

class MenuOptionDataTableRow extends StatelessWidget {
  const MenuOptionDataTableRow({Key? key, required this.left, required this.right}) : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 191,
          child: SGTypography.body(
            left,
            color: SGColors.gray4,
            weight: FontWeight.w500,
            size: FontSize.small,

          ),
        ),
        SGTypography.body(
          right,
          color: SGColors.gray5,
          weight: FontWeight.w500,
          size: FontSize.small,
          align: TextAlign.end,
        ),
      ],
    );
  }
}
