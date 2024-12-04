import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/office/providers/signup_provider.dart';
import 'package:singleeat/screens/bottom/myinfo/alarmstatus/notification_configuration_provider.dart';

class BusinessNotificationConfigurationScreen extends ConsumerStatefulWidget {
  const BusinessNotificationConfigurationScreen({super.key});

  @override
  ConsumerState<BusinessNotificationConfigurationScreen> createState() =>
      _BusinessNotificationConfigurationScreenState();
}

class _BusinessNotificationConfigurationScreenState
    extends ConsumerState<BusinessNotificationConfigurationScreen> {
  bool allowAnnounce = true;
  bool allowBenefit = true;

  @override
  Widget build(BuildContext context) {
    final provider =
        ref.read(notificationConfigurationNotifierProvider.notifier);
    final state = ref.watch(notificationConfigurationNotifierProvider);

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
                        value: state.isSingleatResearchStatus,
                        onChanged: (value) {
                          final signupProvider =
                              ref.read(signupNotifierProvider.notifier);

                          signupProvider.onChangeIsSingleeatAgree(value);

                          signupProvider.changeStatus().then((result) {
                            if (result) {
                              provider.onChangeIsSingleeatAgree(value);
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
                  child: Row(children: [
                    SGTypography.body("혜택 알림",
                        size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: state.isAdditionalServiceStatus,
                        onChanged: (value) {
                          final signupProvider =
                              ref.read(signupNotifierProvider.notifier);

                          signupProvider.onChangeIsAdditionalAgree(value);

                          signupProvider.changeStatus().then((result) {
                            if (result) {
                              provider.onChangeIsAdditionalAgree(value);
                            }
                          });
                        })
                  ])),
            ])));
  }
}
