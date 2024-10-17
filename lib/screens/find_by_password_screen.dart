import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';

class FindByPasswordScreen extends StatefulWidget {
  const FindByPasswordScreen({super.key});

  @override
  State<FindByPasswordScreen> createState() => _FindByPasswordScreenState();
}

class _FindByPasswordScreenState extends State<FindByPasswordScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(controller: pageController, physics: NeverScrollableScrollPhysics(), children: [
      _LookUpUsernameScreen(onPrev: () {
        FocusScope.of(context).unfocus();

        Navigator.pop(context);
      }, onNext: () {
        FocusScope.of(context).unfocus();

        animateToPage(1);
      }),
      AuthenticateWithPhoneNumberScreen(
          title: "비밀번호 찾기",
          onPrev: () {
            FocusScope.of(context).unfocus();

            animateToPage(0);
          },
          onNext: () {
            FocusScope.of(context).unfocus();

            animateToPage(2);
          }),
      ChangePasswordScreen(
          title: "비밀번호 찾기",
          onPrev: () {
            FocusScope.of(context).unfocus();

            animateToPage(1);
          },
          onNext: () {
            FocusScope.of(context).unfocus();

            animateToPage(3);
          }),
      _SuccessChangePasswordScreen(
        onPrev: () {
          FocusScope.of(context).unfocus();

          animateToPage(2);
        },
        onNext: () {
          FocusScope.of(context).unfocus();

          Navigator.pop(context);
        },
      )
    ]));
  }
}

class _SuccessChangePasswordScreen extends StatelessWidget {
  VoidCallback onPrev;
  VoidCallback onNext;
  _SuccessChangePasswordScreen({
    super.key,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: "비밀번호 찾기",
            onTap: () {
              onPrev();
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  onNext();
                },
                label: "로그인")),
        body: SGContainer(
            color: SGColors.white,
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Image.asset("assets/images/large-checkbox.png", width: SGSpacing.p10 * 2),
              SizedBox(height: SGSpacing.p10),
              SGTypography.body("비밀번호 변경 성공!", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
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

class ChangePasswordScreen extends StatefulWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;
  String title;
  ChangePasswordScreen({
    super.key,
    required this.title,
    this.onPrev,
    this.onNext,
  });

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String password = "";
  String passwordConfirm = "";

  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;

  late TextEditingController controller = TextEditingController();
  late TextEditingController controllerConfirm = TextEditingController();

  bool get isPasswordValid => password.isNotEmpty && passwordConfirm.isNotEmpty && password == passwordConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: widget.title,
            onTap: () {
              widget.onPrev!();
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  if (isPasswordValid) {
                    widget.onNext!();
                  }
                },
                disabled: !isPasswordValid,
                label: "다음")),
        body: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            color: SGColors.white,
            child: ListView(children: [
              Row(
                children: [
                  SGTypography.body("비밀번호 변경", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
                ],
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("비밀번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          controller: controller,
                          style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                            hintText: "8~16자의 영문, 숫자, 특수문자를 입력해주세요.",
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
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
              Row(children: []),
              SizedBox(height: SGSpacing.p8),
              if (password.isNotEmpty && passwordConfirm.isNotEmpty && password != passwordConfirm)
                SGTypography.body("비밀번호가 다릅니다.",
                    size: FontSize.small, weight: FontWeight.w500, color: SGColors.warningRed)
              else
                SGTypography.body("비밀번호 확인", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              passwordConfirm = value;
                            });
                          },
                          controller: controllerConfirm,
                          style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                          obscureText: !passwordVisibleConfirm,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                            hintText: "비밀번호를 다시 한번 입력해주세요.",
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          )),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordVisibleConfirm = !passwordVisibleConfirm;
                          });
                        },
                        child: Icon(passwordVisibleConfirm ? Icons.visibility : Icons.visibility_off,
                            color: SGColors.gray3)),
                  ],
                ),
              )),
            ])));
  }
}

class _LookUpUsernameScreen extends StatefulWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;
  _LookUpUsernameScreen({
    super.key,
    this.onPrev,
    this.onNext,
  });

  @override
  State<_LookUpUsernameScreen> createState() => _LookUpUsernameScreenState();
}

class _LookUpUsernameScreenState extends State<_LookUpUsernameScreen> {
  bool usernameVisible = false;
  String username = "";
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "비밀번호 찾기", onTap: widget.onPrev),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                if (username.isNotEmpty) {
                  widget.onNext!();
                }
              },
              disabled: username.isEmpty,
              label: "다음")),
      body: SGContainer(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SGTypography.body("비밀번호 찾기", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
              ],
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("아이디", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        onChanged: (value) {
                          setState(() {
                            username = value;
                          });
                        },
                        controller: controller,
                        style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintStyle:
                              TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                          hintText: "아이디를 입력해주세요.",
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
