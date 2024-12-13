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
          // Label section with flexible width
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Flexible(
                  child: SGTypography.body(
                    label,
                    size: FontSize.normal,
                    weight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (editable)
                  Padding(
                    padding: EdgeInsets.only(left: SGSpacing.p1),
                    child: Icon(Icons.edit, size: FontSize.small),
                  ),
              ],
            ),
          ),
          const Spacer(),
          // Value section with ellipsis
          Flexible(
            flex: 3,
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
      ),
    );
  }
}
