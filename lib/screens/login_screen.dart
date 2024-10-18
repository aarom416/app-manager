import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/find_account_screen.dart';
import 'package:singleeat/screens/find_by_password_screen.dart';
import 'package:singleeat/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SGContainer(
        color: SGColors.white,
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
        child: Column(children: [
          SizedBox(height: SGSpacing.p20),
          Image.asset("assets/images/app-logo.png", width: SGSpacing.p4 * 10),

          /// LOGO
          SGTypography.body("식단 연구소", color: SGColors.primary, weight: FontWeight.w600, size: FontSize.large),
          SizedBox(height: SGSpacing.p10),
          SGTextFieldWrapper(
              child: SGContainer(
            padding: EdgeInsets.all(SGSpacing.p4),
            width: double.infinity,
            child: TextField(
                style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                  hintText: "아이디",
                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                )),
          )),
          SizedBox(height: SGSpacing.p3),
          SGTextFieldWrapper(
              child: SGContainer(
            padding: EdgeInsets.all(SGSpacing.p4),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                      obscureText: !passwordVisible,
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintStyle:
                            TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                        hintText: "비밀번호",
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                    child: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: SGColors.gray3)),
              ],
            ),
          )),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              setState(() {
                rememberMe = !rememberMe;
              });
            },
            child: Row(
              children: [
                Image.asset(rememberMe ? "assets/images/checkbox-on.png" : "assets/images/checkbox-off.png",
                    width: SGSpacing.p6),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("아이디 저장", size: FontSize.normal, color: SGColors.gray4),
              ],
            ),
          ),
          SizedBox(height: SGSpacing.p5),
          SGActionButton(onPressed: () {
            showFailDialogWithImageNoSecondTitle("5분만 로그인이 제한됩니다.");
            showFailDialogWithImage("회원 탈퇴가 완료된 계정입니다.", "회원 탈퇴 후 21일 이내에는 로그인할 수 없습니다.");
            showFailDialogWithImage("해당 계정이 3일간 정지되었습니다.", "비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.");
            showFailDialogWithImage("해당 계정이 7일간 정지되었습니다.", "비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.");
            showFailDialogWithImage("비정상적인 행동이 감지되었습니다.", "고객센터(1600-7723)로 문의하시길 바랍니다.");


          }, label: "로그인"),
          SizedBox(height: SGSpacing.p8),
          Row(children: [
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                    },
                    child: Center(child: SGTypography.body("회원가입", color: SGColors.gray4, size: FontSize.normal)))),
            SGContainer(height: SGSpacing.p3, color: SGColors.line3, borderWidth: 0.5),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => FindAccountScreen(
                                onPressFindPassword: () {
                                  FocusScope.of(context).unfocus();

                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => const FindByPasswordScreen()));
                                },
                              )));
                    },
                    child: Center(child: SGTypography.body("아이디 찾기", color: SGColors.gray4, size: FontSize.normal)))),
            SGContainer(height: SGSpacing.p3, color: SGColors.line3, borderWidth: 0.5),
            Expanded(
                child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FindByPasswordScreen()));
                    },
                    child: Center(child: SGTypography.body("비밀번호 찾기", color: SGColors.gray4, size: FontSize.normal)))),
          ])
        ]),
      ),
    );
  }

  void showFailDialogWithImageNoSecondTitle(String mainTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          Center(
              child: SGTypography.body(mainTitle,
                  size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p6),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: SGContainer(
              color: SGColors.primary,
              width: double.infinity,
              borderColor: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                  child: SGTypography.body("확인",
                      color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
            ),
          )
        ]);
  }

  void showFailDialogWithImage(String mainTitle, String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          Center(
              child: SGTypography.body(mainTitle,
                  size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p4),
          Center(
              child: SGTypography.body(subTitle,
                  color: SGColors.gray4,
                  size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p6),
          GestureDetector(
            onTap: () {
              Navigator.pop(ctx);
            },
            child: SGContainer(
              color: SGColors.primary,
              width: double.infinity,
              borderColor: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                  child: SGTypography.body("확인",
                      color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
            ),
          )
        ]);
  }
}
