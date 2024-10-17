import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class MenuTabBar extends StatelessWidget {
  MenuTabBar({super.key, required this.currentTab, required this.tabs, required this.onTabChanged});

  final String currentTab;
  final List<String> tabs;
  final void Function(String) onTabChanged;

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.gray2,
      borderWidth: 3.0,
      borderColor: Colors.transparent,
      borderRadius: BorderRadius.circular(SGSpacing.p7 + SGSpacing.p05),
      child: Row(children: [
        ...tabs.map((String tab) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onTabChanged(tab);
              },
              child: SGContainer(
                borderRadius: BorderRadius.circular(SGSpacing.p7 + SGSpacing.p05),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                color: currentTab == tab ? Colors.white : Colors.transparent,
                child: Center(
                    child: SGTypography.body(tab,
                        size: FontSize.normal,
                        weight: FontWeight.w600,
                        color: currentTab == tab ? SGColors.black : SGColors.gray3)),
              ),
            ),
          );
        }).toList(),
      ]),
    );
  }
}
