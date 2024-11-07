import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';

class AuthenticateWithPhoneNumberScreen extends ConsumerStatefulWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;
  final String title;

  AuthenticateWithPhoneNumberScreen({
    super.key,
    this.onPrev,
    this.onNext,
    required this.title,
  });

  @override
  ConsumerState<AuthenticateWithPhoneNumberScreen> createState() =>
      _AuthenticateWithPhoneNumberScreenState();
}

class _AuthenticateWithPhoneNumberScreenState
    extends ConsumerState<AuthenticateWithPhoneNumberScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen(authenticateWithPhoneNumberNotifierProvider, (previous, next) {
      if (next.status == AuthenticateWithPhoneNumberStatus.success) {
        context.push(AppRoutes.webView);
      }
    });

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: widget.title, onTap: widget.onPrev),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            child: Column(children: [
              Row(children: [
                SGTypography.body("사장님 휴대폰 인증을\n진행해 주세요!",
                    size: FontSize.xlarge,
                    weight: FontWeight.w700,
                    lineHeight: 1.35),
              ]),
              SizedBox(height: SGSpacing.p10),
              GestureDetector(
                // onTap: onNext,
                onTap: () {
                  ref
                      .read(
                          authenticateWithPhoneNumberNotifierProvider.notifier)
                      .identityVerification();
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    borderColor: SGColors.primary,
                    boxShadow: SGBoxShadow.large,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SGTypography.body("휴대폰 인증하기",
                              size: FontSize.normal,
                              weight: FontWeight.w700,
                              color: SGColors.primary),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,
                              size: FontSize.small, color: SGColors.gray3),
                        ])),
              ),
              SizedBox(height: SGSpacing.p4),
              SGTypography.body("본인명의 휴대폰이 없는 경우, 싱그릿 고객센터 1600-7723 로 문의해주세요.",
                  color: SGColors.gray4,
                  size: FontSize.small,
                  weight: FontWeight.w400,
                  lineHeight: 1.25),
            ])));
  }
}
