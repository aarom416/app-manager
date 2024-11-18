import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class BusinessNotificationConfigurationScreen extends StatefulWidget {
  BusinessNotificationConfigurationScreen({
    super.key,
  });

  @override
  State<BusinessNotificationConfigurationScreen> createState() =>
      _BusinessNotificationConfigurationScreenState();
}

class _BusinessNotificationConfigurationScreenState
    extends State<BusinessNotificationConfigurationScreen> {
  bool allowAnnounce = true;
  bool allowBenefit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림 받기 설정"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            child: ListView(children: [
              SGContainer(),
              SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(children: [
                    SGTypography.body("소식 알림",
                        size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowAnnounce,
                        onChanged: (value) {
                          setState(() {
                            allowAnnounce = value;
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
                  child: Row(children: [
                    SGTypography.body("혜택 알림",
                        size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowBenefit,
                        onChanged: (value) {
                          setState(() {
                            allowBenefit = value;
                          });
                        })
                  ])),
            ])));
  }
}
