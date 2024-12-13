import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';
import '../../../core/constants/colors.dart';

class OnbodingFirstView extends StatelessWidget {
  const OnbodingFirstView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
            height: screenHeight * 0.02,
          ),
          SGTypography.body(
            "사장님, 이젠 걱정하지 마세요.",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: screenHeight * 0.4,
                width: screenWidth * 0.7,
                color: Colors.white,
              ),
              Positioned(
                top: screenHeight * 0.01,
                child: Container(
                  height: screenHeight * 0.02,
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02),
                    color: SGColors.gray5,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.02,
                child: Container(
                  height: screenHeight * 0.01,
                  width: screenWidth * 0.68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenHeight * 0.02),
                    color: SGColors.gray2,
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.02,
                child: Container(
                  height: screenHeight * 0.38,
                  width: screenWidth * 0.67,
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