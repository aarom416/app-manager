import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/providers/find_by_password_provider.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';

import '../core/components/flex.dart';

class FindByPasswordScreen extends ConsumerStatefulWidget {
  const FindByPasswordScreen({super.key});

  @override
  ConsumerState<FindByPasswordScreen> createState() =>
      _FindByPasswordScreenState();
}

class _FindByPasswordScreenState extends ConsumerState<FindByPasswordScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(findByPasswordNotifierProvider.notifier)
          .onChangeStatus(FindByPasswordStatus.step1);

      ref
          .read(authenticateWithPhoneNumberNotifierProvider.notifier)
          .onChangeMethod(AuthenticateWithPhoneNumberMethod.PASSWORD);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(findByPasswordNotifierProvider, (previous, next) {
      if (previous?.status != next.status) {
        FocusScope.of(context).unfocus();

        switch (next.status) {
          case FindByPasswordStatus.step1:
            animateToPage(0);
            break;
          case FindByPasswordStatus.step2:
            animateToPage(1);
            break;
          case FindByPasswordStatus.step3:
            animateToPage(2);
            break;
          case FindByPasswordStatus.step4:
            animateToPage(3);
            break;
          case FindByPasswordStatus.error:
            break;
        }
      }
    });

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _LookUpUsernameScreen(
            onPrev: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            onNext: () async {
              int statusCode = await ref.read(findByPasswordNotifierProvider.notifier).findPassword();
              final state = ref.read(findByPasswordNotifierProvider);
              if (statusCode == 404) {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return Dialog(
                      insetPadding: EdgeInsets.all(SGSpacing.p10),
                      backgroundColor: Colors.transparent,
                      child: SGContainer(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SGContainer(
                                padding:
                                EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SGTypography.body(state.error.errorMessage, color: SGColors.black, size: FontSize.large, align: TextAlign.center, weight: FontWeight.w600),
                                    SizedBox(
                                      height: SGSpacing.p7,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: SGColors.primary,
                                            borderRadius: BorderRadius.circular(12)
                                        ) ,
                                        child: Center(
                                          child: Text(
                                            "확인",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: FontSize.medium,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ),
                    );
                  },
                );
              }
            },
          ),
          AuthenticateWithPhoneNumberScreen(
            title: "비밀번호 찾기",
            onPrev: () {
              FocusScope.of(context).unfocus();

              animateToPage(0);
            },
          ),
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

              ref
                  .read(goRouterProvider)
                  .go(AppRoutes.login, extra: UniqueKey());
            },
          )
        ],
      ),
    );
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
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  onNext();
                },
                label: "로그인")
        ),
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

class ChangePasswordScreen extends ConsumerStatefulWidget {
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
  ConsumerState<ChangePasswordScreen> createState() =>
      ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;

  late TextEditingController controller = TextEditingController();
  late TextEditingController controllerConfirm = TextEditingController();

  bool get isPasswordValid {
    final state = ref.watch(findByPasswordNotifierProvider);
    return state.password.isNotEmpty &&
        state.passwordConfirm.isNotEmpty &&
        state.password == state.passwordConfirm;
  }


  String? _passwordErrorText;

  bool isPasswordFormatValid(String password) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[-d@$!%*?&])[A-Za-z\d-@$!%*?&]{8,16}$');
    return regex.hasMatch(password);
  }

  void validatePassword(String password) {
    if (!isPasswordFormatValid(password)) {
      setState(() {
        _passwordErrorText = "비밀번호는 8~16자의 영문,숫자,특수문자만 사용 가능합니다.";
      });
    } else {
      setState(() {
        _passwordErrorText = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findByPasswordNotifierProvider);
    final provider = ref.read(findByPasswordNotifierProvider.notifier);
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
                  if (isPasswordValid) {
                    provider.updatePassword().then((value) {
                      if (!value) {
                        showFailDialogWithImage(
                            '비밀번호 변경을 위해\n이전과 다른 비밀번호를 입력해주세요');
                      }
                    });
                  }
                },
                disabled: !isPasswordValid,
                label: "다음")),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            color: SGColors.white,
            child: ListView(
              children: [
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
                            provider.onChangePassword(value);
                            validatePassword(value);
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
                            if (controller.text.isNotEmpty && controllerConfirm.text.isNotEmpty) {
                              provider.onChangePasswordConfirm(value);
                            }
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
              if (state.password.isNotEmpty &&
                  state.passwordConfirm.isNotEmpty &&
                  state.password != state.passwordConfirm)
                SGTypography.body("다시 한 번 확인해주세요.",
                    size: FontSize.small,
                    weight: FontWeight.w400,
                    color: SGColors.warningRed),
            ])));
  }

  void showFailDialogWithImage(String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(subTitle,
                      color: SGColors.black,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
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
                          color: SGColors.white,
                          weight: FontWeight.w700,
                          size: FontSize.normal)),
                ),
              )
            ]);
  }

  void showSGDialogWithImage({
    required BuildContext context,
    required List<Widget> Function(BuildContext) childrenBuilder,
  }) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SGContainer(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            padding: EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05)
                .copyWith(bottom: 0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05)
                        .copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: SGSpacing.p2),
                        Image.asset("assets/images/warning.png",
                            width: SGSpacing.p12),
                        SizedBox(height: SGSpacing.p3),
                        ...childrenBuilder(ctx),
                      ],
                    ),
                  )
                ]),
          ),
        );
      },
    );
  }
}

class _LookUpUsernameScreen extends ConsumerStatefulWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;

  _LookUpUsernameScreen({
    super.key,
    this.onPrev,
    this.onNext,
  });

  @override
  ConsumerState<_LookUpUsernameScreen> createState() =>
      _LookUpUsernameScreenState();
}

class _LookUpUsernameScreenState extends ConsumerState<_LookUpUsernameScreen> {
  bool usernameVisible = false;
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findByPasswordNotifierProvider);
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "비밀번호 찾기", onTap: widget.onPrev),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                if (state.loginId.isNotEmpty) {
                  widget.onNext!();
                }
              },
              disabled: state.loginId.isEmpty,
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
                SGTypography.body("비밀번호 찾기",
                    size: FontSize.xlarge,
                    weight: FontWeight.w700,
                    lineHeight: 1.35),
              ],
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("아이디",
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
                          ref
                              .read(findByPasswordNotifierProvider.notifier)
                              .onChangeLoginId(value);
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
                          hintText: "아이디를 입력해주세요.",
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none),
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
