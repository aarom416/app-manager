import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/constants/colors.dart';

class SGTextFieldWrapper extends StatelessWidget {
  final Widget child;
  final bool disabled;

  const SGTextFieldWrapper({Key? key, required this.child, this.disabled = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        color: disabled ? SGColors.gray2 : Colors.white,
        borderColor: SGColors.line3,
        borderRadius: BorderRadius.circular(SGSpacing.p3),
        child: child);
  }
}
