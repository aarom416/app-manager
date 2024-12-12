import 'package:flutter/material.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';


class OnbodingThirdView extends StatelessWidget {
  const OnbodingThirdView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.03,
          ),
          SGTypography.body(
            "영양성분을 토대로",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SGTypography.body(
            "자동으로 사용자에게 추천돼요!",
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
                    "assets/images/onboding-third-1.png",
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.15,
                child: Container(
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.85,
                  child: Image.asset(
                    "assets/images/onboding-third-2.png",
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
