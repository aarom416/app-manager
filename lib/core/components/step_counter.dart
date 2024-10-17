import 'dart:math';

import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class StepCounter extends StatefulWidget {
  final int defaultValue;
  final int step;
  final int maxValue;
  final int minValue;
  Function(int)? onChanged;

  StepCounter({
    super.key,
    required this.defaultValue,
    required this.step,
    required this.maxValue,
    required this.minValue,
    this.onChanged,
  });

  @override
  State<StepCounter> createState() => _StepCounterState();
}

class _StepCounterState extends State<StepCounter> {
  late int value = widget.defaultValue;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      width: double.infinity,
      color: SGColors.white,
      borderRadius: BorderRadius.circular(SGSpacing.p3),
      borderColor: SGColors.line3,
      padding: EdgeInsets.all(SGSpacing.p4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
            onTap: () {
              setState(() {
                value = max(value - widget.step, widget.minValue);
              });
            },
            child: Image.asset("assets/images/minus.png", width: 24, height: 24)),
        SGTypography.body("${value}분", size: FontSize.normal, weight: FontWeight.w500),
        InkWell(
            onTap: () {
              setState(() {
                value = min(value + widget.step, widget.maxValue);
              });
            },
            child: Image.asset("assets/images/plus.png", width: 24, height: 24)),
      ]),
    );
  }
}
