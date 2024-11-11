import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/login_screen.dart';

class StoreNotFoundScreen extends StatelessWidget {
  const StoreNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SGContainer(
        color: Colors.white,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/warning.png", width: SGSpacing.p12),
            SizedBox(
              height: SGSpacing.p5,
            ),
            SGTypography.body("등록된 가게가 아닙니다.",
                color: SGColors.black, size: FontSize.xlarge, weight: FontWeight.bold),
            SizedBox(
              height: SGSpacing.p4,
            ),
            SGTypography.body("현재 해당 가게는 미등록 상태입니다.",
                color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
            SizedBox(
                height: SGSpacing.p1
            ),
            SGTypography.body("자세한 사항은 고객센터로 문의해주세요.",
                color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
            SizedBox(
                height: SGSpacing.p5
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: SGContainer(
                margin: EdgeInsets.only(
                    left: SGSpacing.p24,
                    right: SGSpacing.p24
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p6, vertical: SGSpacing.p3),
                borderRadius: BorderRadius.circular(100),
                borderColor: SGColors.primary,
                child: Center(
                    child: SGTypography.body("로그인으로 돌아가기  >",
                        size: FontSize.small,
                        weight: FontWeight.w500,
                        color: SGColors.primary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
