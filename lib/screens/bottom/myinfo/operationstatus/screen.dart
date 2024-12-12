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
import 'package:singleeat/office/providers/main_provider.dart';

class TemporaryClosedScreen extends ConsumerStatefulWidget {
  const TemporaryClosedScreen({super.key});

  @override
  ConsumerState<TemporaryClosedScreen> createState() =>
      _TemporaryClosedScreenState();
}

class _TemporaryClosedScreenState extends ConsumerState<TemporaryClosedScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mainNotifierProvider);
    final provider = ref.read(mainNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영업 임시중지"),
      body: SGContainer(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
        color: Color(0xFFFAFAFA),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              color: SGColors.white,
              borderColor: SGColors.line3,
              boxShadow: SGBoxShadow.large,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGTypography.body("영업 임시중지",
                      size: FontSize.normal, weight: FontWeight.w500),
                  SGSwitch(
                      value: state.operationStatus == 1,
                      onChanged: (value) {
                        setState(() {
                          if (state.operationStatus == 1) {
                            provider.onChangeOperationStatus(0);
                          } else {
                            showDialog(context: context, provider: provider);
                          }
                        });
                      })
                ],
              )),
          SizedBox(height: SGSpacing.p5),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row( 
              children: [
              SGTypography.body("1. ",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTypography.body("임시 중지 상태에선 싱그릿 앱에 '준비 중'으로 보여요.",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    color: SGColors.gray4
                ),
              ),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(children: [
              SGTypography.body("2.",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTypography.body("가게 영업 임시 중지 시 신규 주문 접수는 어려워요.",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    color: SGColors.gray4),
              ),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(children: [
              SGTypography.body("3.",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  lineHeight: 1.5,
                  color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTypography.body("임시 중지는 언제든지 직접 해지할 수 있어요.",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    lineHeight: 1.5,
                    color: SGColors.gray4),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }

  void showDialog(
      {required BuildContext context, required MainNotifier provider}) {
    showSGDialog(
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
                        provider.onChangeOperationStatus(1);
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
