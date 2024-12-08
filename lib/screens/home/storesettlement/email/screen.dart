import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storeVat/operation/provider.dart';
import 'package:singleeat/screens/home/storesettlement/operation/provider.dart';

class SendEmailScreen extends ConsumerStatefulWidget {
  final int callScreen;
  const SendEmailScreen({super.key, required this.callScreen});

  @override
  ConsumerState<SendEmailScreen> createState() => _SendEmailScreen();
}

class _SendEmailScreen extends ConsumerState<SendEmailScreen> {
  final TextEditingController emailController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(storeSettlementNotifierProvider.notifier);
    final vatProvider = ref.read(storeVatNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "이메일 발송"),
        body: SGContainer(
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            width: double.infinity,
            color: Color(0xFFFAFAFA),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.label("받는사람"),
              SizedBox(height: SGSpacing.p4),
              SGTextFieldWrapper(
                  child: SGContainer(
                width: double.infinity,
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(SGSpacing.p4),
                      isCollapsed: true,
                      hintStyle: TextStyle(color: SGColors.gray3),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none),
                    )),
              )),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SGActionButton(
                      onPressed: () {
                        widget.callScreen == 1
                            ? provider.onChangeEmail(
                                email: emailController.text)
                            : vatProvider.onChangeEmail(
                                email: emailController.text);
                        showSGDialog(
                            context: context,
                            childrenBuilder: (ctx) => [
                                  Center(
                                    child: SGTypography.body(
                                        "사장님의 이메일로\n전송해드리겠습니다.",
                                        size: FontSize.medium,
                                        weight: FontWeight.w700,
                                        align: TextAlign.center,
                                        lineHeight: 1.25),
                                  ),
                                  SizedBox(height: SGSpacing.p3),
                                  SGTypography.body(
                                      "받는사람: ${emailController.text}",
                                      size: FontSize.small,
                                      weight: FontWeight.w500,
                                      color: SGColors.gray4),
                                  SizedBox(height: SGSpacing.p5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: SGContainer(
                                            color: SGColors.gray3,
                                            borderRadius: BorderRadius.circular(
                                                SGSpacing.p3),
                                            padding:
                                                EdgeInsets.all(SGSpacing.p4),
                                            child: Center(
                                              child: SGTypography.body("취소",
                                                  size: FontSize.normal,
                                                  color: SGColors.white,
                                                  weight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: SGSpacing.p2 + SGSpacing.p05),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(ctx).pop();
                                            //Navigator.of(context).pop();
                                            if (widget.callScreen == 1) {
                                              provider
                                                  .generateSettlementReport();
                                            } else {
                                              vatProvider.generateVatReport();
                                            }
                                          },
                                          child: SGContainer(
                                            color: SGColors.primary,
                                            borderRadius: BorderRadius.circular(
                                                SGSpacing.p3),
                                            padding:
                                                EdgeInsets.all(SGSpacing.p4),
                                            child: Center(
                                              child: SGTypography.body("확인",
                                                  size: FontSize.normal,
                                                  color: SGColors.white,
                                                  weight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]);
                        return;
                      },
                      label: "메일 보내기"),
                ],
              ))
            ])));
  }
}
