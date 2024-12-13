import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/models/user_model.dart';
import 'package:singleeat/office/providers/login_provider.dart';

class SignUpCompleteScreen extends ConsumerStatefulWidget {
  const SignUpCompleteScreen({
    super.key,
  });

  @override
  ConsumerState<SignUpCompleteScreen> createState() =>
      _SignUpCompleteScreenState();
}

class _SignUpCompleteScreenState extends ConsumerState<SignUpCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: SGTypography.body('싱그릿 식단 연구소',
              size: FontSize.medium, weight: FontWeight.w800),
          elevation: 0.0,
        ),
        // , onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () async {
                    await ref.read(loginNotifierProvider.notifier).logout();
                    // JSS 2024.12.05
                    /*bool logout =
                        await ref.read(loginNotifierProvider.notifier).logout();
                    if (logout) {
                      ref
                          .read(goRouterProvider)
                          .go(AppRoutes.login, extra: UniqueKey());
                    }*/
                  },
                  child: SGContainer(
                      color: SGColors.gray1,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("로그아웃",
                              size: FontSize.large,
                              color: SGColors.gray5,
                              weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    ref.read(goRouterProvider).push(AppRoutes.profileEdit);
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("내 정보",
                              size: FontSize.large,
                              color: SGColors.white,
                              weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (UserHive.get().status == UserStatus.wait)
              _GreetingScreen()
            else
              _NotRegisteredScreen(
                onPressActionButton: () {
                  ref
                      .read(goRouterProvider)
                      .push(AppRoutes.storeRegistrationForm);
                },
              )
          ])),
        ));
  }
}

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late TextEditingController usernameController =
      TextEditingController(text: UserHive.get().loginId);
  late TextEditingController nameController =
      TextEditingController(text: UserHive.get().name);
  late TextEditingController authCodeController =
      TextEditingController(text: "");
  late TextEditingController emailController =
      TextEditingController(text: UserHive.get().email);
  late TextEditingController phoneNumberController =
      TextEditingController(text: UserHive.get().phone);

  String username = "singleat";
  String name = "싱그릿";
  bool emailAuthRequested = false;
  bool emailAuthConfirmed = false;
  String email = "singleeat@singleat.com";
  String phoneNumber = "010-1234-5678";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "싱그릿 식단 연구소"),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            ...[
              SGTypography.body("아이디",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                enabled: false,
                                controller: usernameController,
                                onChanged: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
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
                  ),
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("이름",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: nameController,
                                enabled: false,
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
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
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("이메일",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                enabled: false,
                                controller: emailController,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "이메일을 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            if (emailAuthRequested) ...[
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: authCodeController,
                                onChanged: (value) {
                                  // 인증코드
                                },
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "인증번호",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              GestureDetector(
                onTap: () {
                  setState(() {
                    emailAuthConfirmed = false;
                  });
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p4 + SGSpacing.p05),
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이메일 인증 확인",
                            color: SGColors.primary,
                            weight: FontWeight.w500,
                            size: FontSize.small))),
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("휴대폰 번호",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: phoneNumberController,
                                enabled: false,
                                onChanged: (value) {
                                  setState(() {
                                    phoneNumber = value;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
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
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            ],
          ]),
        ));
  }
}

class _NotRegisteredScreen extends StatelessWidget {
  VoidCallback onPressActionButton;

  _NotRegisteredScreen({
    super.key,
    required this.onPressActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SGContainer(
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            borderColor: SGColors.line3,
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4)
                .copyWith(top: SGSpacing.p10, bottom: SGSpacing.p6),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: SGTypography.body(
                    "아직 싱그릿에 입점하지 않으셨어요.",
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    color: SGColors.black,
                    align: TextAlign.center,
                    lineHeight: 1.25,
                  ),
                )
              ]),
              SizedBox(height: SGSpacing.p8),
              GestureDetector(
                onTap: onPressActionButton,
                child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.primary,
                  child: Center(
                      child: SGTypography.body("입점 신청하기",
                          size: FontSize.normal,
                          weight: FontWeight.w700,
                          color: SGColors.primary)),
                ),
              ),
            ])),
        SizedBox(height: SGSpacing.p32),
      ],
    );
  }
}

class _GreetingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: Colors.transparent,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset("assets/images/home-icon.png", width: SGSpacing.p20),
        SizedBox(height: SGSpacing.p10),
        SGTypography.body("사장님, 입점을 심사하고 있어요!",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: SGColors.black,
            align: TextAlign.center,
            lineHeight: 1.25),
        SizedBox(height: SGSpacing.p4),
        SGTypography.body("24시간 이내에 입점 신청을 완료할 예정입니다.",
            size: FontSize.normal,
            weight: FontWeight.w400,
            color: SGColors.gray4,
            lineHeight: 1.15),
        SizedBox(height: SGSpacing.p32),
      ]),
    );
  }
}
