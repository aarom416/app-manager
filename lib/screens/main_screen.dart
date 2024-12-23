import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/main_provider.dart';
import 'package:singleeat/screens/home/storeHistory/operation/screen.dart';
import 'package:singleeat/screens/home/storesettlement/operation/screen.dart';
import 'package:singleeat/screens/notice_screen.dart';

import 'home/storeVat/operation/screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget menuButton(String title, String iconName, void Function() onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: SGContainer(
          padding: EdgeInsets.symmetric(vertical: SGSpacing.p2 + SGSpacing.p05),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: SGColors.gray1,
                child: iconName == "All"
                    ? SGTypography.body(iconName,
                        size: FontSize.large, weight: FontWeight.w700)
                    : Image.asset('assets/images/$iconName.png',
                        width: 36, height: 36),
              ),
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(title,
                  size: FontSize.small, weight: FontWeight.w500),
            ],
          ),
        ),
      ),
    );
  }

  void showOperationStopDialog(
      {required BuildContext context, required MainNotifier provider}) {
    showOperationSGDialog(
        context: context,
        childrenBuilder: (ctx) => [
              SGTypography.body("영업 임시 중지 시",
                  size: FontSize.medium, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p1),
              SGTypography.body("신규 주문 접수가 불가합니다.",
                  size: FontSize.medium, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p5),
              Row(
                children: [
                  SGFlexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        color: SGColors.gray3,
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
                  SGFlexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        provider.onChangeOperationStatus(0);
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
  void initState() {
    ref.read(mainNotifierProvider.notifier).ownerHome();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainNotifierProvider);
    final provider = ref.read(mainNotifierProvider.notifier);

    const toolbarHeight = 64.0;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGContainer(
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                      child: SGTypography.body("싱그릿 사장님",
                          size: (FontSize.large + FontSize.xlarge) / 2,
                          weight: FontWeight.w700)),
                ])),
        toolbarHeight: toolbarHeight,
        leadingWidth: 200,
        actions: [
          GestureDetector(
            onTap: () {
              ref.read(goRouterProvider).push(AppRoutes.notification);
            },
            child: SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                child: Image.asset("assets/images/alarm.png",
                    width: 24, height: 24)),
          ),
        ],
      ),
      body: SGContainer(
        height: double.infinity,
        color: const Color(0xFFFAFAFA),
        child: ListView(
          shrinkWrap: true,
          children: [
            SGContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: SGSpacing.p4),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: SGContainer(
                        color: SGColors.white,
                        padding: EdgeInsets.all(SGSpacing.p4),
                        borderColor: SGColors.primary,
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        boxShadow: SGBoxShadow.large,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SGContainer(
                                child: SGTypography.body("가게 영업 임시 중지",
                                    size: FontSize.normal,
                                    weight: FontWeight.w600),
                              ),
                              SGContainer(
                                  child: SGSwitch(
                                      value: state.operationStatus == 0,
                                      onChanged: (toggled) {
                                        if (state.operationStatus == 0) {
                                          provider.onChangeOperationStatus(1);
                                        } else {
                                          showOperationStopDialog(
                                              context: context,
                                              provider: provider);
                                        }
                                      })),
                            ]),
                      )),
                  SizedBox(height: SGSpacing.p4),
                  SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                    boxShadow: SGBoxShadow.large,
                    child: SGContainer(
                      color: SGColors.white,
                      borderRadius: BorderRadius.circular(SGSpacing.p4),
                      padding: EdgeInsets.symmetric(
                          vertical: SGSpacing.p2 + SGSpacing.p05),
                      child: Column(children: [
                        Row(children: [
                          menuButton('가게 관리', "menu-store", () {
                            ref
                                .read(goRouterProvider)
                                .push(AppRoutes.storeManagement);
                          }),
                          menuButton('주문 내역', "menu-orders", () {
                            ref
                                .read(goRouterProvider)
                                .push(AppRoutes.orderHistory);
                          }),
                          menuButton('통계', "menu-statistics", () {
                            ref
                                .read(goRouterProvider)
                                .push(AppRoutes.statistics);
                          }),
                        ]),
                        Row(children: [
                          menuButton('부가세', "menu-taxes", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TaxesScreen()));
                          }),
                          menuButton('쿠폰 관리', "menu-coupon", () {
                            ref
                                .read(goRouterProvider)
                                .push(AppRoutes.couponInformation);
                          }),
                          /*menuButton('사업자 정보', "menu-business-profile", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    StoreInformationScreen()));
                          }),*/
                          menuButton('사업자 정보', "menu-business-profile", () {
                            ref
                                .read(goRouterProvider)
                                .push(AppRoutes.storeInformation);
                          }),
                        ]),
                        Row(children: [
                          menuButton('정산', "menu-settlements", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettlementScreen()));
                          }),
                          menuButton('이력', "menu-histories", () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EventHistoryScreen()));
                          }),
                          Expanded(child: Container())
                        ]),
                      ]),
                    ),
                  ),
                  SizedBox(height: SGSpacing.p5),

                  // TODO: 공지사항
                  Container(),
                  SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoticeScreen()));
                      },
                      child: SGContainer(
                        color: SGColors.white,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(SGSpacing.p4),
                        padding: EdgeInsets.all(SGSpacing.p4).copyWith(
                            top: SGSpacing.p4 + SGSpacing.p05, bottom: 0),
                        boxShadow: SGBoxShadow.large,
                        child: GestureDetector(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SGTypography.body("공지사항",
                                    size: FontSize.normal, weight: FontWeight.w600),
                                SGTypography.body("자세히",
                                    color: SGColors.gray4),
                              ],
                            ),
                            SizedBox(height: SGSpacing.p4),
                            ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) => InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => NoticeScreen()));
                                      },
                                      child: SGContainer(
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width : 280,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          SGTypography.body(
                                                              state
                                                                  .result
                                                                  .newsDTOList[i]
                                                                  .title,
                                                              size: FontSize.small,
                                                              weight: FontWeight.w500,
                                                              overflow: TextOverflow
                                                                  .ellipsis),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                              SizedBox(
                                                  height:
                                                      SGSpacing.p1 + SGSpacing.p05),
                                              SGTypography.body(
                                                  state.result.newsDTOList[i]
                                                      .createdDate,
                                                  size: FontSize.tiny,
                                                  color: SGColors.gray3),
                                            ],
                                          )),
                                    ),
                                separatorBuilder: (ctx, _i) => Container(
                                      child: Divider(
                                          color: SGColors.gray2,
                                          thickness: 1,
                                          height: 1),
                                    ),
                                itemCount: state.result.newsDTOList.length)
                          ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SGSpacing.p10),
                  // menuButton('공지사항', Icons.logout, () {
                  //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoticeScreen()));
                  // }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
