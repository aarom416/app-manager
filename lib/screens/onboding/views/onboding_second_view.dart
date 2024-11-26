import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../../../core/components/sizing.dart';
import '../../../core/constants/colors.dart';

class OnbodingSecondView extends StatelessWidget {
  const OnbodingSecondView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: SGSpacing.p14,
          ),
          SGTypography.body(
            "이제는 가게의 메뉴만 등록해도",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: Colors.black,
          ),
          SizedBox(
            height: SGSpacing.p11,
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
