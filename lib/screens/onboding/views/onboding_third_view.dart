import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';
import '../../../core/constants/colors.dart';

class OnbodingThirdView extends StatelessWidget {
  const OnbodingThirdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: SGSpacing.p7,
          ),
          SGTypography.body(
            "영양성분을 토대로",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: SGSpacing.p2,
          ),
          SGTypography.body(
            "자동으로 사용자에게 추천돼요!",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: SGSpacing.p6,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 340,
                width: 360,
                color: Colors.white,
              ),
              Positioned(
                top: 15,
                child: Container(
                  height: 540,
                  width: 255,
                  child: Image.asset(
                    "assets/images/onboding-third-1.png",
                  ),
                ),
              ),
              Positioned(
                top: 116,
                child: Container(
                  height: 200,
                  width: 310,
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
