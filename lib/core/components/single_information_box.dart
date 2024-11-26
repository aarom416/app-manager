import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class SingleInformationBox extends StatelessWidget {
  SingleInformationBox({
    super.key,
    this.label = '',
    this.value = '',
    this.editable = false,
  });

  final String label;
  final String value;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
        color: SGColors.white,
        borderColor: SGColors.line2,
        borderRadius: BorderRadius.circular(SGSpacing.p4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SGTypography.body(label, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(width: SGSpacing.p1),
            if (editable) const Icon(Icons.edit, size: FontSize.small),
            const Spacer(),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SGTypography.body(
                  value,
                  size: FontSize.small,
                  color: SGColors.gray5,
                  weight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ));
  }
}
