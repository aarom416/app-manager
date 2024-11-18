import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_routes.dart';

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
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String password = "";
  String passwordConfirm = "";

  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;

  late TextEditingController controller = TextEditingController();
  late TextEditingController controllerConfirm = TextEditingController();

  bool get isPasswordValid =>
      password.isNotEmpty &&
      passwordConfirm.isNotEmpty &&
      password == passwordConfirm;

  String? _passwordErrorText;

  void _validatePassword(String value) {
    final passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+]{8,16}$');
    setState(() {
      if (passwordRegex.hasMatch(value)) {
        _passwordErrorText = null; // Valid password
      } else {
        _passwordErrorText = "비밀번호는 8~16자의 영문, 숫자, 특수문자만 사용 가능합니다.";
      }
    });
  }

  void showFailDialogWithImageBoth(String mainTitle) {
    showSGDialogWithImageBoth(
        context: context,
        childrenBuilder: (ctx) => [
              Column(
                children: [
                  Center(
                      child: SGTypography.body(mainTitle,
                          size: FontSize.medium,
                          weight: FontWeight.w700,
                          lineHeight: 1.25,
                          align: TextAlign.center)),
                  SizedBox(height: SGSpacing.p6),
                ],
              ),
              Row(
                children: [
                  SGFlexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        setState(() {});
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        color: SGColors.primary,
                        child: Center(
                          child: SGTypography.body("확인",
                              size: FontSize.normal,
                              weight: FontWeight.w700,
                              color: SGColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: widget.title,
            onTap: () {
              widget.onPrev!();
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  showFailDialogWithImageBoth(
                      "비밀번호 변경을 위해\n이전과 다른 비밀번호를 입력해주세요.");
                  if (isPasswordValid) {
                    context.push(AppRoutes.successChangePassword);
                  }
                },
                disabled: !isPasswordValid,
                label: "다음")),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            color: SGColors.white,
            child: ListView(children: [
              Row(
                children: [
                  SGTypography.body("비밀번호 변경",
                      size: FontSize.xlarge,
                      weight: FontWeight.w700,
                      lineHeight: 1.35),
                ],
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("비밀번호",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
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
                              _validatePassword(value);
                              password = value;
                            });
                          },
                          controller: controller,
                          style: TextStyle(
                              fontSize: FontSize.small, color: SGColors.gray5),
                          obscureText: !passwordVisible,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle: TextStyle(
                                color: SGColors.gray3,
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.w400),
                            hintText: "8~16자의 영문, 숫자, 특수문자를 입력해주세요.",
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          )),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        child: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: SGColors.gray3)),
                  ],
                ),
              )),
              if (_passwordErrorText != null)
                Padding(
                  padding: EdgeInsets.only(top: SGSpacing.p2),
                  child: Text(
                    _passwordErrorText!,
                    style: TextStyle(
                      fontSize: FontSize.small,
                      color: SGColors.warningRed,
                    ),
                  ),
                ),
              Row(children: []),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("비밀번호 확인",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
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
                          style: TextStyle(
                              fontSize: FontSize.small, color: SGColors.gray5),
                          obscureText: !passwordVisibleConfirm,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle: TextStyle(
                                color: SGColors.gray3,
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.w400),
                            hintText: "비밀번호를 다시 한번 입력해주세요.",
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          )),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordVisibleConfirm = !passwordVisibleConfirm;
                          });
                        },
                        child: Icon(
                            passwordVisibleConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: SGColors.gray3)),
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p2),
              if (password.isNotEmpty &&
                  passwordConfirm.isNotEmpty &&
                  password != passwordConfirm)
                SGTypography.body("다시 한 번 확인해주세요.",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.warningRed)
            ])));
  }
}
