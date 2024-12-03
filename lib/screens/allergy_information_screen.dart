import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/infomation/provider.dart';

class AllergyInformationScreen extends ConsumerStatefulWidget {
  const AllergyInformationScreen({super.key});

  @override
  ConsumerState<AllergyInformationScreen> createState() =>
      _AllergyInformationScreenState();
}

class _AllergyInformationScreenState
    extends ConsumerState<AllergyInformationScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      controller.text = ref
          .read(storeManagementBasicInfoNotifierProvider)
          .storeInfo
          .originInformation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "원산지 및 알러지 정보"),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
              onPressed: () {
                ref
                    .read(storeManagementBasicInfoNotifierProvider.notifier)
                    .storeOriginInformation(controller.text)
                    .then((value) {
                  if (value) {
                    context.pop();
                  } else {
                    showFailDialogWithImage(
                        mainTitle: '원산지 및 알러지 변경 오류',
                        subTitle: '원산지 및 알러지 변경에 실패하였습니다.');
                  }
                });
              },
              label: "변경하기",
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("원산지 정보 URL",
                  size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p2, vertical: SGSpacing.p3),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: controller,
                          onChanged: (value) {
                            controller.text = value;
                          },
                          style: TextStyle(
                              fontSize: FontSize.small, color: SGColors.gray5),
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle: TextStyle(
                                color: SGColors.gray3,
                                fontSize: FontSize.small,
                                fontWeight: FontWeight.w400),
                            hintText: "원산지 및 알러지 정보 URL을 입력해주세요",
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          )),
                    ),
                    Image.asset('assets/images/link-icon.png',
                        width: 20, height: 20),
                    SizedBox(width: SGSpacing.p1)
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(
                  "「농수산물의 원산지 표시에 관한 법률 에 의거하여 원산지가 표시되어 있는 링크를 삽입해 주세요",
                  size: FontSize.tiny,
                  weight: FontWeight.w400,
                  color: SGColors.gray4),
            ])));
  }

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              if (subTitle.isEmpty) ...[
                Center(
                    child: SGTypography.body(mainTitle,
                        size: FontSize.medium,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: SGContainer(
                    color: SGColors.primary,
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("확인",
                            color: SGColors.white,
                            weight: FontWeight.w700,
                            size: FontSize.normal)),
                  ),
                )
              ] else ...[
                Center(
                    child: SGTypography.body(mainTitle,
                        size: FontSize.medium,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p4),
                Center(
                    child: SGTypography.body(subTitle,
                        color: SGColors.gray4,
                        size: FontSize.small,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: SGContainer(
                    color: SGColors.primary,
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("확인",
                            color: SGColors.white,
                            weight: FontWeight.w700,
                            size: FontSize.normal)),
                  ),
                )
              ]
            ]);
  }
}
