import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';
import '../../../core/constants/colors.dart';

class OnbodingSecondView extends StatelessWidget {
  const OnbodingSecondView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.08,
          ),
          SGTypography.body(
            "이제는 가게의 메뉴만 등록해도",
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
                width: screenWidth * 0.8,
                color: Colors.white,
              ),
              Positioned(
                top: screenHeight * 0.02,
                child: Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.7,
                  child: Image.asset(
                    "assets/images/onboding-second.png",
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
