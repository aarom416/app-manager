import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class LoginFailScreen extends StatelessWidget {
  const LoginFailScreen({super.key});

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
            SGTypography.body("로그인 실패",
                color: SGColors.black,
                size: FontSize.xlarge,
                weight: FontWeight.bold),
            SizedBox(
              height: SGSpacing.p4,
            ),
            SGTypography.body("해당 계정은 로그아웃 처리되었습니다.",
                color: SGColors.gray4,
                size: FontSize.normal,
                weight: FontWeight.w400),
            SizedBox(height: SGSpacing.p1),
            SGTypography.body("다시 한 번 로그인 해주세요.",
                color: SGColors.gray4,
                size: FontSize.normal,
                weight: FontWeight.w400),
            SizedBox(height: SGSpacing.p5),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: SGContainer(
                margin: EdgeInsets.only(
                    left: SGSpacing.p28 + SGSpacing.p2,
                    right: SGSpacing.p28 + SGSpacing.p2),
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p2, vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(100),
                borderColor: SGColors.primary,
                child: Center(
                    child: SGTypography.body("로그인하기   >",
                        size: FontSize.medium,
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

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _loginController = TextEditingController();
  bool passwordVisible = false;

  final checkboxOn =
      Image.asset("assets/images/checkbox-on.png", width: SGSpacing.p6);
  final checkboxOff =
      Image.asset("assets/images/checkbox-off.png", width: SGSpacing.p6);

  @override
  void initState() {
    Future.microtask(() {
      ref.read(loginNotifierProvider.notifier).autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginNotifierProvider, (previous, next) {
      switch (next.status) {
        case LoginStatus.direct:
          ref.read(goRouterProvider).push(
            AppRoutes.authenticateWithPhoneNumber,
            extra: {
              'title': '로그인',
            },
          );

          ref
              .read(loginNotifierProvider.notifier)
              .onChangeStatus(LoginStatus.init);
          break;

        case LoginStatus.password:
          ref.read(goRouterProvider).push(AppRoutes.findByPassword);
          ref
              .read(loginNotifierProvider.notifier)
              .onChangeStatus(LoginStatus.init);

        case LoginStatus.success:
          UserModel user = UserHive.get();

          if (user.status == UserStatus.success) {
            ref.read(goRouterProvider).go(AppRoutes.home, extra: UniqueKey());
          } else {
            ref
                .read(goRouterProvider)
                .go(AppRoutes.signupComplete, extra: UniqueKey());
          }

        default:
          break;
      }

      // show models
      if (next.showTitleMessage.isNotEmpty) {
        showFailDialogWithImage(
            mainTitle: next.showTitleMessage, subTitle: next.showSubMessage);
      }
    });

    final state = ref.watch(loginNotifierProvider);
    if (state.loginId.isNotEmpty) {
      _loginController.text = state.loginId;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SGContainer(
        color: SGColors.white,
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
        child: Column(children: [
          SizedBox(height: SGSpacing.p20),
          Image.asset("assets/images/app-logo.png",
              height: SGSpacing.p4 * 10, width: SGSpacing.p4 * 10),
          SizedBox(height: SGSpacing.p10),
          SGTextFieldWrapper(
              child: SGContainer(
            padding: EdgeInsets.all(SGSpacing.p4),
            width: double.infinity,
            child: TextField(
                controller: _loginController,
                onChanged: (value) {
                  ref
                      .read(loginNotifierProvider.notifier)
                      .onChangeLoginId(value);
                },
                style:
                    TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  hintStyle: TextStyle(
                      color: SGColors.gray3,
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.w400),
                  hintText: "아이디",
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide.none),
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
                      onChanged: (value) {
                        ref
                            .read(loginNotifierProvider.notifier)
                            .onChangePassword(value);
                      },
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
                        hintText: "비밀번호",
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
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              ref
                  .read(loginNotifierProvider.notifier)
                  .onChangeRememberLoginId();
            },
            child: Row(
              children: [
                (state.isRememberLoginId) ? checkboxOn : checkboxOff,
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("아이디 저장",
                    size: FontSize.normal, color: SGColors.gray4),
              ],
            ),
          ),
          if (!state.error.success && state.showTitleMessage.isEmpty) ...[
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              child: SGTypography.body(
                state.error.errorMessage,
                color: SGColors.warningRed,
                size: FontSize.small,
              ),
            )
          ],
          SizedBox(height: SGSpacing.p5),
          SGActionButton(
              onPressed: () {
                ref.read(loginNotifierProvider.notifier).directLogin();
                /*이
                showFailDialogWithImageNoSecondTitle("5분만 로그인이 제한됩니다.");
                showFailDialogWithImage(
                    "회원 탈퇴가 완료된 계정입니다.", "회원 탈퇴 후 21일 이내에는 로그인할 수 없습니다.");
                showFailDialogWithImage("해당 계정이 3일간 정지되었습니다.",
                    "비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.");
                showFailDialogWithImage("해당 계정이 7일간 정지되었습니다.",
                    "비정상적인 행동이 감지되었습니다.\n자세한 사항은 고객센터로 문의하시길 바랍니다.");
                showFailDialogWithImage(
                    "비정상적인 행동이 감지되었습니다.", "고객센터(1600-7723)로 문의하시길 바랍니다.");
                 */
              },
              label: "로그인"),
          SizedBox(height: SGSpacing.p8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
                onTap: () {
                  ref.read(goRouterProvider).push(AppRoutes.signup);
                },
                child: Center(
                    child: SGTypography.body("회원가입",
                        color: SGColors.gray4, size: FontSize.normal))),
            SGContainer(
                height: SGSpacing.p3, color: SGColors.line3, borderWidth: 0.5),
            GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();

                  ref.read(goRouterProvider).push(AppRoutes.findByAccount);
                },
                child: Center(
                    child: SGTypography.body("아이디 찾기",
                        color: SGColors.gray4, size: FontSize.normal))),
            SGContainer(
                height: SGSpacing.p3, color: SGColors.line3, borderWidth: 0.5),
            GestureDetector(
                onTap: () {
                  ref.read(goRouterProvider).push(AppRoutes.findByPassword);
                },
                child: Center(
                    child: SGTypography.body("비밀번호 찾기",
                        color: SGColors.gray4, size: FontSize.normal))),
          ])
        ]),
      ),
    );
  }

  /*
  void showFailDialogWithImageNoSecondTitle(String mainTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(mainTitle,
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
   */

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              if (subTitle.isEmpty) ...[
                Center(
                    child: SGTypography.body(mainTitle,
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
              ] else ...[
                Center(
                    child: SGTypography.body(mainTitle,
                        size: FontSize.medium,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p4),
                Center(
                    child: SGTypography.body(subTitle,
                        color: SGColors.gray4,
                        size: FontSize.small,
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
              ]
            ]);
  }
}
