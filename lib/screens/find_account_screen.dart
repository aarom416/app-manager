import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';

class FindAccountScreen extends StatefulWidget {
  const FindAccountScreen({super.key});

  @override
  State<FindAccountScreen> createState() => _FindAccountScreenState();
}

class _FindAccountScreenState extends State<FindAccountScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
          _LookUpUsernameScreen(onPrev: () {
            FocusScope.of(context).unfocus();

            Navigator.pop(context);
          }, onNext: () {
            FocusScope.of(context).unfocus();

            animateToPage(1);
          }),
          AuthenticateWithPhoneNumberScreen(
              title: "아이디 찾기",
              onPrev: () {
                FocusScope.of(context).unfocus();

                animateToPage(0);
              }),
          /*
              onNext: () {
                FocusScope.of(context).unfocus();

                animateToPage(2);
              }
               */
          _ExistingAccountScreen(
            findPasswordCallback: () {
              FocusScope.of(context).unfocus();

              Navigator.pop(context);

              context.push(AppRoutes.findByPassword);
            },
            loginCallback: () {
              FocusScope.of(context).unfocus();

              Navigator.pop(context);
            },
            onPrev: () {
              FocusScope.of(context).unfocus();

              animateToPage(1);
            },
          )
        ]));
  }
}

class _ExistingAccountScreen extends StatelessWidget {
  VoidCallback onPrev;
  VoidCallback findPasswordCallback;
  VoidCallback loginCallback;

  _ExistingAccountScreen({
    super.key,
    required this.onPrev,
    required this.findPasswordCallback,
    required this.loginCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
          title: "아이디 찾기",
          onTap: onPrev,
        ),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    findPasswordCallback();
                  },
                  child: SGContainer(
                      color: SGColors.gray1,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("비밀번호 찾기",
                              size: FontSize.large,
                              color: SGColors.gray5,
                              weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    loginCallback();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("로그인하기",
                              size: FontSize.large,
                              color: SGColors.white,
                              weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: SGColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            child: Column(children: [
              Row(children: [
                SGTypography.body("가입하신 아이디는\n다음과 같습니다.",
                    size: FontSize.xlarge,
                    weight: FontWeight.w700,
                    lineHeight: 1.35),
              ]),
              SizedBox(height: SGSpacing.p8),
              SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.line3,
                child: Column(children: [
                  Row(children: []),
                  SGTypography.body("아이디 abcdef1234",
                      size: FontSize.large,
                      weight: FontWeight.w700,
                      color: SGColors.black),
                  SizedBox(height: SGSpacing.p4),
                  SGTypography.body("가입일 2024.05.16",
                      size: FontSize.small,
                      weight: FontWeight.w400,
                      color: SGColors.gray4)
                ]),
              ),
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
  String username = "";
  String errorMessage = "";
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "아이디 찾기", onTap: widget.onPrev),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                if (username.isNotEmpty) {
                  FocusScope.of(context).unfocus();
                  widget.onNext!();
                }
              },
              disabled: username.isEmpty,
              label: "다음")),
      body: SGContainer(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SGTypography.body("아이디 찾기",
                    size: FontSize.xlarge,
                    weight: FontWeight.w700,
                    lineHeight: 1.35),
              ],
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("이름",
                size: FontSize.small,
                weight: FontWeight.w500,
                color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGTextFieldWrapper(
              child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        final validCharacters = RegExp(r'^[a-zA-Z0-9ㄱ-ㅎ가-힣\s]*$');
                        if (validCharacters.hasMatch(value)) {
                          setState(() {
                            username = value;
                            errorMessage = "";
                          });
                        } else {
                          setState(() {
                            errorMessage =
                            "특수문자는 입력하실 수 없습니다.\n한글, 영문, 숫자, 띄어쓰기만 입력해주세요";
                          });
                        }
                      },
                      controller: controller,
                      style: TextStyle(
                          fontSize: FontSize.small, color: SGColors.gray5),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintStyle: TextStyle(
                            color: SGColors.gray3,
                            fontSize: FontSize.small,
                            fontWeight: FontWeight.w400),
                        hintText: "이름을 입력해주세요.",
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: SGSpacing.p2),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: FontSize.small,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}


