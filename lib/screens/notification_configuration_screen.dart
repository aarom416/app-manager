import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
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
import 'package:singleeat/office/providers/notification_configuration_provider.dart';

class NotificationConfigurationScreen extends ConsumerStatefulWidget {
  const NotificationConfigurationScreen({super.key});

  @override
  ConsumerState<NotificationConfigurationScreen> createState() =>
      _NotificationConfigurationScreenState();
}

class _NotificationConfigurationScreenState
    extends ConsumerState<NotificationConfigurationScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(notificationConfigurationNotifierProvider.notifier)
          .notificationStatus();
    });
  }

  double notificationVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    final provider =
        ref.read(notificationConfigurationNotifierProvider.notifier);
    final state = ref.watch(notificationConfigurationNotifierProvider);

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림 설정"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("알림 음량 및 설정",
                size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.line3,
                boxShadow: SGBoxShadow.large,
                child: Row(children: [
                  SGTypography.body("주문 알림 설정",
                      size: FontSize.normal, weight: FontWeight.w500),
                  const Spacer(),
                  SGSwitch(
                      value: state.isOrderNotificationStatus,
                      onChanged: (value) {
                        setState(() {
                          if (state.isOrderNotificationStatus) {
                            showFailDialogWithImageBoth("주문 알림을 비활성화하시겠습니까?",
                                "비활성화 시 주문 관련 알림을 받을 수 없습니다.");
                          } else {
                            provider.orderNotificationStatus(false);
                          }
                        });
                      })
                ])),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.line3,
                boxShadow: SGBoxShadow.large,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("알림 음량",
                          size: FontSize.normal, weight: FontWeight.w500),
                      SizedBox(height: SGSpacing.p2),
                      SliderTheme(
                        data: SliderThemeData(
                          inactiveTrackColor: SGColors.line3,
                          activeTrackColor: SGColors.primary,
                          valueIndicatorColor: SGColors.primary,
                          thumbColor: SGColors.white,
                          trackHeight: 6,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 12),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 1),
                        ),
                        child: Slider(
                          value: notificationVolume,
                          onChanged: (double value) {
                            setState(() {
                              notificationVolume = value;
                            });
                          },
                        ),
                      )
                    ])),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("사장님 알림 센터",
                size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                ref
                    .read(goRouterProvider)
                    .push(AppRoutes.businessNotificationConfiguration);
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
                        SGTypography.body("알림 받기 설정",
                            size: FontSize.normal, weight: FontWeight.w500),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, size: FontSize.small),
                      ])),
            ),
          ]),
        ));
  }

  void showFailDialogWithImageBoth(String mainTitle, String subTitle) {
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
                  SizedBox(height: SGSpacing.p2),
                  Center(
                      child: SGTypography.body(subTitle,
                          color: SGColors.gray4,
                          size: FontSize.small,
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
                        final isOrderNotificationStatus = ref
                            .watch(notificationConfigurationNotifierProvider)
                            .isOrderNotificationStatus;

                        ref
                            .read(notificationConfigurationNotifierProvider
                                .notifier)
                            .orderNotificationStatus(isOrderNotificationStatus);

                        Navigator.of(ctx).pop();
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
}
