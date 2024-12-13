import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

final DATA_TABLE_DIVIDER = () => Divider(
      height: SGSpacing.p10,
      color: SGColors.line1,
      thickness: 1,
    );

class DataTableRow extends StatelessWidget {
  const DataTableRow({Key? key, required this.left, required this.right}) : super(key: key);

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SGTypography.body(
            left,
            color: SGColors.gray4,
            weight: FontWeight.w500,
            size: FontSize.small,
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 191,
          child: SGTypography.body(
            right,
            color: SGColors.gray5,
            weight: FontWeight.w500,
            size: FontSize.small,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class MultipleInformationBox extends StatelessWidget {
  MultipleInformationBox({Key? key, this.children = const []}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      color: SGColors.white,
      borderColor: SGColors.line2,
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
