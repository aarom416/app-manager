import 'package:flutter/material.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

class SGCheckboxGroup extends StatelessWidget {
  SGCheckboxGroup({required this.items, required this.selected, required this.onChanged});

  final List<String> items;
  final List<String> selected;
  final Function(List<String>) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: SGSpacing.p2 + SGSpacing.p05,
      children: items
          .map((item) => GestureDetector(
                onTap: () {
                  if (selected.contains(item)) {
                    onChanged([...selected]..remove(item));
                  } else {
                    onChanged([...selected]..add(item));
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/checkbox-${selected.contains(item) ? 'on' : 'off'}.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: SGSpacing.p1),
                    SGTypography.body(item, size: FontSize.small),
                    SizedBox(width: SGSpacing.p6),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
