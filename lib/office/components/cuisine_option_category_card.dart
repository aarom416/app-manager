import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/cuisine_model.dart';

class CuisineOptionCategoryCard extends StatelessWidget {
  final CuisineOptionCategory category;

  const CuisineOptionCategoryCard({super.key, required this.category});

  String get selectionType {
    if (category.isEssential) return "(필수)";
    return "(선택 최대 ${category.maximumSelection ?? 0}개)";
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SGTypography.body(category.name, size: FontSize.normal, weight: FontWeight.w600),
        SizedBox(width: SGSpacing.p1),
        SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
      ]),
      ...category.options
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.name ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened
    ]);
  }
}
