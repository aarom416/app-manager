import 'package:flutter/material.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class SGRadioOption<T> {
  final String label;
  final T value;

  SGRadioOption({required this.label, required this.value});
}

class SGRadioGroup<T> extends StatelessWidget {
  final List<SGRadioOption<T>> items;
  final T selected;
  final Axis direction;
  final FontWeight fontWeight;

  final Function(T) onChanged;

  SGRadioGroup(
      {required this.items,
      required this.selected,
      required this.onChanged,
      this.direction = Axis.horizontal,
      this.fontWeight = FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      spacing: SGSpacing.p3,
      children: items
          .map((item) => GestureDetector(
                onTap: () {
                  onChanged(item.value);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/radio-${item.value == selected ? 'on' : 'off'}.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: SGSpacing.p1),
                    SGTypography.body(item.label, color: SGColors.black, size: FontSize.small, weight: fontWeight),
                    SizedBox(width: SGSpacing.p10),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
