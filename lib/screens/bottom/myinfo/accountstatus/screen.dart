import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/home_provider.dart';
import 'package:singleeat/office/providers/login_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'serviceagreement/service_agreement_screen.dart';

class ProfileDeleteSessionScreen extends ConsumerStatefulWidget {
  const ProfileDeleteSessionScreen({super.key});

  @override
  ConsumerState<ProfileDeleteSessionScreen> createState() =>
      _ProfileDeleteSessionScreenState();
}

class _ProfileDeleteSessionScreenState
    extends ConsumerState<ProfileDeleteSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "계정 설정"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
          child: Column(children: [
            SGContainer(
              width: double.infinity,
              child: SGTypography.body(
                "계정 설정",
                size: FontSize.normal,
                weight: FontWeight.w700,
                lineHeight: 1.25,
                align: TextAlign.start,
              ),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                showLogOutSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                      Center(
                          child: SGTypography.body("로그아웃 하시겠습니까?",
                              size: FontSize.large,
                              weight: FontWeight.w700)),
                      SizedBox(height: SGSpacing.p4),
                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();
                            },
                            child: SGContainer(
                              color: SGColors.gray3,
                              padding: EdgeInsets.symmetric(
                                  vertical: SGSpacing.p4),
                              borderRadius:
                              BorderRadius.circular(SGSpacing.p3),
                              child: Center(
                                child: SGTypography.body("취소",
                                    size: FontSize.normal,
                                    weight: FontWeight.w700,
                                    color: SGColors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: SGSpacing.p2),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ref
                                  .read(loginNotifierProvider.notifier)
                                  .logout(
                                errorCallback: () {
                                  ref.read(goRouterProvider).pop();
                                  showFailDialogWithImage(
                                      context: context,
                                      mainTitle: '로그아웃 실패',
                                      subTitle:
                                      '현재 가게가 영업 중이거나 진행 중인 주문이 있어\n로그아웃을 진행할 수 없습니다.',
                                      onTapFunction: () {
                                        // 내정보 이동
                                        ref
                                            .read(homeNotifierProvider
                                            .notifier)
                                            .onChangeSelectedIndex(2);
                                        ref
                                            .read(goRouterProvider)
                                            .go(AppRoutes.home);
                                      });
                                },
                              );
                              // JSS 2024.12.05
                              /*then((value) {
                                    if (value) {
                                      ref.read(goRouterProvider).go(
                                          AppRoutes.login,
                                          extra: UniqueKey());
                                    } else {
                                      showFailDialogWithImage("로그아웃 실패",
                                          "현재 가게가 영업 중이거나 진행 중인 주문이 있어\n로그아웃을 진행할 수 없습니다.");
                                    }
                                  }*/
                            },
                            child: SGContainer(
                              color: SGColors.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: SGSpacing.p4),
                              borderRadius:
                              BorderRadius.circular(SGSpacing.p3),
                              child: Center(
                                child: SGTypography.body("로그아웃",
                                    size: FontSize.normal,
                                    weight: FontWeight.w700,
                                    color: SGColors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]);
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SGTypography.body("로그아웃",
                            size: FontSize.normal, weight: FontWeight.w500),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: FontSize.small),
                      ])),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                showAccountDeleteSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                      // 로그아웃 하시겠습니까.
                      Center(
                          child: SGTypography.body("정말 탈퇴하시겠습니까?",
                              size: FontSize.large,
                              weight: FontWeight.w700)),
                      SizedBox(height: SGSpacing.p3),
                      Center(
                        child: SGTypography.body(
                          "계정 탈퇴 시 고객센터로 전화주세요",
                          color: SGColors.gray4,
                          size: FontSize.small,
                        ),
                      ),
                      SizedBox(height: SGSpacing.p8),
                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.of(ctx).pop();
                              launchUrl(Uri.parse(
                                'tel://1600-7723',
                              ));
                            },
                            child: SGContainer(
                              color: SGColors.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: SGSpacing.p4),
                              borderRadius:
                              BorderRadius.circular(SGSpacing.p3),
                              child: Center(
                                child: SGTypography.body("확인",
                                    size: FontSize.normal,
                                    weight: FontWeight.w700,
                                    color: SGColors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]);
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SGTypography.body("회원탈퇴",
                            size: FontSize.normal, weight: FontWeight.w500),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: FontSize.small),
                      ])),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                ref.read(goRouterProvider).push(AppRoutes.checkPassword);
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SGTypography.body("비밀번호 변경",
                            size: FontSize.normal, weight: FontWeight.w500),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: FontSize.small),
                      ])),
            ),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
              width: double.infinity,
              child: SGTypography.body(
                "서비스 약관",
                size: FontSize.normal,
                weight: FontWeight.w700,
                lineHeight: 1.25,
                align: TextAlign.start,
              ),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ServiceAgreementScreen(title: "이용약관"),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SGTypography.body("이용약관",
                            size: FontSize.normal, weight: FontWeight.w500),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: FontSize.small),
                      ])),
            ),
          ])),
    );
  }
}