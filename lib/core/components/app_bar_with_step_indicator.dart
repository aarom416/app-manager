import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class AppBarWithStepIndicator extends StatelessWidget implements PreferredSizeWidget {
  static const double indicatorSize = 4.0;

  AppBarWithStepIndicator({
    super.key,
    required this.title,
    required this.onTap,
    required this.currentStep,
    required this.totalStep,
  });

  final String title;
  final VoidCallback onTap;
  final int currentStep;
  final int totalStep;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onTap();
        return false;
      },
      child: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SGTypography.body(title, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p1 + SGSpacing.p05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SGTypography.body("$currentStep",
                          size: FontSize.small, color: SGColors.black, weight: FontWeight.w700),
                      SGTypography.body(" / $totalStep", size: FontSize.small, color: SGColors.gray3),
                    ],
                  ),
                ],
              ),
              SizedBox(width: SGSpacing.p8),
            ],
          ),
        ),
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(indicatorSize),
          child: SGContainer(
            child: Row(
              children: [
                Flexible(
                    flex: currentStep,
                    child: SGContainer(height: SGSpacing.p1, width: double.infinity, color: SGColors.primary)),
                if (currentStep != totalStep)
                  Flexible(
                      flex: totalStep - currentStep,
                      child: SGContainer(width: double.infinity, height: SGSpacing.p1, color: SGColors.gray2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + indicatorSize);
}
