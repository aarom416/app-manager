import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class AuthenticateWithPhoneNumberScreen extends StatelessWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;
  final String title;
  AuthenticateWithPhoneNumberScreen({super.key, this.onPrev = null, this.onNext = null, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: title, onTap: onPrev),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            child: Column(children: [
              Row(children: [
                SGTypography.body("사장님 휴대폰 인증을\n진행해 주세요!",
                    size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
              ]),
              SizedBox(height: SGSpacing.p10),
              GestureDetector(
                onTap: onNext,
                child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    borderColor: SGColors.primary,
                    boxShadow: SGBoxShadow.large,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SGTypography.body("휴대폰 인증하기",
                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.primary),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: FontSize.small, color: SGColors.gray3),
                    ])),
              ),
              SizedBox(height: SGSpacing.p4),
              SGTypography.body("본인명의 휴대폰이 없는 경우, 싱그릿 고객센터 1600-7723 로 문의해주세요.",
                  color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w400, lineHeight: 1.25),
            ])));
  }
}
