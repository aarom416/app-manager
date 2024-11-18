import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/profile_provider.dart';
import 'package:singleeat/screens/receipt_list_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).totalOrderAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(profileNotifierProvider.notifier);
    final state = ref.watch(profileNotifierProvider);

    const toolbarHeight = 64.0;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGContainer(
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                      child: SGTypography.body("내 정보",
                          size: (FontSize.large + FontSize.xlarge) / 2,
                          weight: FontWeight.w700)),
                ])),
        toolbarHeight: toolbarHeight,
        leadingWidth: 200,
        actions: [],
      ),
      body: SGContainer(
        color: Color(0xFFFAFAFA),
        borderWidth: 0,
        child: ListView(
          children: [
            SGContainer(
              borderWidth: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SGContainer(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p4 + SGSpacing.p05,
                          vertical: SGSpacing.p5),
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SGTypography.body("하루 매출",
                                    size: FontSize.small,
                                    weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                SGTypography.body("${state.totalAmount}",
                                    size:
                                        (FontSize.large + FontSize.xlarge) / 2,
                                    color: Colors.black,
                                    weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p4 + SGSpacing.p05),
                                Row(children: [
                                  SGTypography.body(
                                      "배달 ${state.deliveryTotalOrderAmount}원"),
                                  SGContainer(
                                      color: SGColors.line3,
                                      width: 1,
                                      height: 10,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: SGSpacing.p2)),
                                  SGTypography.body(
                                      "포장 ${state.pickupTotalOrderAmount}원"),
                                ])
                              ],
                            )),
                            ReloadButton(
                              onReload: () {
                                provider.totalOrderAmount();
                              },
                            )
                          ],
                        ),
                        SizedBox(height: SGSpacing.p5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReceiptListScreen()));
                          },
                          child: SGContainer(
                            color: SGColors.primary,
                            padding:
                                EdgeInsets.symmetric(vertical: SGSpacing.p3),
                            borderRadius: BorderRadius.circular(SGSpacing.p3),
                            child: Center(
                                child: SGTypography.body("지난 주문 내역",
                                    size:
                                        (FontSize.small + FontSize.normal) / 2,
                                    color: Colors.white)),
                          ),
                        ),
                      ]))
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p4),
            SGContainer(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4)
                  .copyWith(top: SGSpacing.p6),
              borderRadius: BorderRadius.circular(SGSpacing.p4),
              boxShadow: SGBoxShadow.large,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body("앱 설정",
                      size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  _NavigationLinkItem(
                      title: "자동 영업 임시중지",
                      onTap: () {
                        context.push(AppRoutes.temporaryClosed);
                      }),
                  _NavigationLinkItem(
                      title: "알림 설정",
                      onTap: () {
                        context.push(AppRoutes.notificationConfiguration);
                      }),
                  _NavigationLinkItem(
                      title: "계정 설정",
                      onTap: () {
                        context.push(AppRoutes.profileDeleteSession);
                      }),
                ],
              ),
            ),
            // 앱 설정
            SizedBox(height: SGSpacing.p4),
            SGContainer(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4)
                  .copyWith(top: SGSpacing.p6),
              borderRadius: BorderRadius.circular(SGSpacing.p4),
              boxShadow: SGBoxShadow.large,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body("고객센터",
                      size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  _NavigationLinkItem(title: "자주 묻는 질문"),
                  _NavigationLinkItem(title: "1:1 문의"),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p12),
          ],
        ),
      ),
    );
  }
}

class _NavigationLinkItem extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const _NavigationLinkItem({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap : () {},
      child: SGContainer(
        color: Colors.white,
        child: Column(
          children: [
            SGContainer(
              color: SGColors.gray2,
              height: 1,
              width: double.infinity,
            ),
            SGContainer(
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              child: Row(
                children: [
                  SGTypography.body(title,
                      size: (FontSize.small + FontSize.normal) / 2),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: FontSize.small),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
