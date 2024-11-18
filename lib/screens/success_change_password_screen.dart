import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/login_screen.dart';

class SuccessChangePasswordScreen extends StatelessWidget {
  const SuccessChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: "비밀번호 변경",
            onTap: () {
              Navigator.pop(context);
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                label: "확인")),
        body: SGContainer(
            color: SGColors.white,
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset("assets/images/large-checkbox.png",
                  width: SGSpacing.p10 * 2),
              SizedBox(height: SGSpacing.p10),
              SGTypography.body("비밀번호 변경 성공!",
                  size: FontSize.xlarge,
                  weight: FontWeight.w700,
                  lineHeight: 1.35),
              SizedBox(height: SGSpacing.p4),
              SGTypography.body("싱그릿 사장님 비밀번호가\n성공적으로 변경되었습니다.",
                  align: TextAlign.center,
                  size: FontSize.normal,
                  weight: FontWeight.w400,
                  color: SGColors.gray4,
                  lineHeight: 1.25),
              SizedBox(height: SGSpacing.p32),
            ]))));
  }
}
