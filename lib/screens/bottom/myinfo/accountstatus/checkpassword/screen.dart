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
import 'package:singleeat/screens/bottom/myinfo/accountstatus/checkpassword/provider.dart';

class CheckPasswordScreen extends ConsumerStatefulWidget {
  String title;

  CheckPasswordScreen({
    super.key,
    required this.title,
  });

  @override
  ConsumerState<CheckPasswordScreen> createState() =>
      _CheckPasswordScreenState();
}

class _CheckPasswordScreenState extends ConsumerState<CheckPasswordScreen> {
  String password = "";

  bool passwordVisible = false;

  late TextEditingController controller = TextEditingController();

  bool get isPasswordValid => password.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(myInfoCheckPasswordNotifierProvider.notifier);
    final state = ref.watch(myInfoCheckPasswordNotifierProvider);
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: widget.title,
            onTap: () {
              Navigator.pop(context);
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
                onPressed: () async {
                  await provider.checkPassword(password);

                  if (!state.success) {
                    showFailDialogWithImage(
                        ref: ref,
                        mainTitle: "비밀번호 인증 실패",
                        subTitle: "입력하신 비밀번호가 올바르지 않습니다.\n다시 확인해주세요.");
                  } else {
                    ref.read(goRouterProvider).push(AppRoutes.changePassword);
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
                  SGTypography.body("사장님의 정보 보호를 위해,\n현재 비밀번호를 확인해주세요.",
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
                            hintText: "현재 비밀번호를 입력해주세요.",
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
              SizedBox(height: SGSpacing.p8),
            ])));
  }

  void showFailDialogWithImage(
      {required WidgetRef ref,
      required String mainTitle,
      required String subTitle}) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(mainTitle,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              SizedBox(height: SGSpacing.p2),
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
                  //ref.read(goRouterProvider).push(AppRoutes.changePassword);
                  Navigator.pop(context);
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
}
