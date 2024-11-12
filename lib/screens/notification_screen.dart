import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/office/models/notification_model.dart';
import 'package:singleeat/office/providers/notification_provider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(notificationNotifierProvider.notifier).loadNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationNotifierProvider);

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림"),
        body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.all(SGSpacing.p4),
          child: state.notification.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      CircleAvatar(
                        radius: SGSpacing.p5,
                        backgroundColor: SGColors.warningRed.withOpacity(0.1),
                        child:
                            Image.asset('assets/images/warning.png', width: 24),
                      ),
                      SizedBox(height: SGSpacing.p4),
                      SGTypography.body("알림 내역이 없어요.",
                          size: FontSize.large, weight: FontWeight.w700),
                      SizedBox(height: SGSpacing.p4),
                      SGTypography.body("홍길동님의 알림 내역이 없어요.",
                          size: FontSize.normal,
                          weight: FontWeight.w400,
                          color: SGColors.gray4),
                      // half of appbar's height
                      SizedBox(height: SGSpacing.p7),
                    ]))
              : ListView(children: [
                  ...state.notification
                      .map((notification) =>
                          _NotificationCard(notification: notification))
                      .toList(),
                ]),
        ));
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  _NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.white,
      padding: EdgeInsets.all(SGSpacing.p3),
      borderRadius: BorderRadius.circular(SGSpacing.p2),
      borderColor: SGColors.gray2,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: SGColors.primary.withOpacity(0.08),
              radius: 20,
              child: Center(
                  child: Image.asset('assets/images/store.png', width: 24))),
          SizedBox(width: SGSpacing.p2),
          Expanded(
            child: SGContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(notification.title,
                      weight: FontWeight.w500, color: SGColors.gray3),
                  SizedBox(height: SGSpacing.p1 + SGSpacing.p05),
                  SGTypography.body(notification.body,
                      size: FontSize.small,
                      weight: FontWeight.w500,
                      lineHeight: 1.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
