import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

enum SGActionButtonVariant { primary, danger }

class SGActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool disabled;
  final SGActionButtonVariant variant;

  SGActionButton(
      {required this.onPressed,
      required this.label,
      this.variant = SGActionButtonVariant.primary,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SGContainer(
          height: SGSpacing.p14,
          width: double.infinity,
          color: disabled
              ? SGColors.gray3
              : (variant == SGActionButtonVariant.danger ? SGColors.warningRed.withOpacity(0.08) : SGColors.primary),
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          child: Center(
              child: SGTypography.body(label,
                  color: SGActionButtonVariant.primary == variant ? Colors.white : SGColors.warningRed,
                  weight: FontWeight.w700,
                  size: MediaQuery.of(context).size.width <= 320 ? FontSize.tiny : FontSize.medium
              ))),
    );
  }
}
