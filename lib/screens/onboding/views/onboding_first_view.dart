import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';
import '../../../core/constants/colors.dart';

class OnbodingFirstView extends StatelessWidget {
  const OnbodingFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SGTypography.body(
            "높은 수수료, 광고비..",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: const Color(0xFF2AC1BC),
          ),
          SizedBox(
            height: SGSpacing.p2,
          ),
          SGTypography.body(
            "사장님, 이젠 걱정하지 마세요.",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: SGSpacing.p7,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 340,
                width: 260,
                color: Colors.white,
              ),
              Positioned(
                top: 10,
                child: Container(
                  height: 18,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: SGColors.gray5,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                child: Container(
                  height: 8,
                  width: 244,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: SGColors.gray2,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                child: Container(
                  height: 312,
                  width: 240,
                  child: Image.asset(
                    "assets/images/onboding-first.png",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
