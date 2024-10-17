import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class NotificationModel {
  final String catergory;
  final String message;

  NotificationModel({required this.catergory, required this.message});
}

class NotificationScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(catergory: '가게 운영', message: '샐러디 역삼점은 현재 가게 영업시간이 아니예요.\n영업임시중지 적용 여부 또는 영업종료시간을 확인해주세요.'),
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.all(SGSpacing.p4),
          child: notifications.isEmpty
              ? Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CircleAvatar(
                    radius: SGSpacing.p5,
                    backgroundColor: SGColors.warningRed.withOpacity(0.1),
                    child: Image.asset('assets/images/warning.png', width: 24),
                  ),
                  SizedBox(height: SGSpacing.p4),
                  SGTypography.body("알림 내역이 없어요.", size: FontSize.large, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  SGTypography.body("홍길동님의 알림 내역이 없어요.",
                      size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                  // half of appbar's height
                  SizedBox(height: SGSpacing.p7),
                ]))
              : ListView(children: [
                  ...notifications.map((notification) => _NotificationCard(notification: notification)).toList(),
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
              child: Center(child: Image.asset('assets/images/store.png', width: 24))),
          SizedBox(width: SGSpacing.p2),
          Expanded(
            child: SGContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(notification.catergory, weight: FontWeight.w500, color: SGColors.gray3),
                  SizedBox(height: SGSpacing.p1 + SGSpacing.p05),
                  SGTypography.body(notification.message,
                      size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
