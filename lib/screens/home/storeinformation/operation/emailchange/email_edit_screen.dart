import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storeinformation/operation/provider.dart';

class EmailEditScreen extends ConsumerStatefulWidget {
  final String value;
  final String title;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;

  EmailEditScreen({
    Key? key,
    required this.value,
    required this.title,
    required this.hintText,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  ConsumerState<EmailEditScreen> createState() => _EmailEditScreenState();
}

class _EmailEditScreenState extends ConsumerState<EmailEditScreen> {
  late String value;
  late TextEditingController controller = TextEditingController();
  late TextEditingController authController = TextEditingController();

  TextStyle baseStyle =
      TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  late TextEditingController emailDomainController = TextEditingController();

  String emailInputOption = '직접 입력';
  bool isSendCode = false;
  bool isVerify = false;

  List<SelectionOption<String>> emailInputOptions = [
    SelectionOption<String>(label: "naver.com", value: "naver.com"),
    SelectionOption<String>(label: "gmail.com", value: "gmail.com"),
    SelectionOption<String>(label: "daum.net", value: "daum.net"),
    SelectionOption<String>(label: "hanmail.net", value: "hanmail.net"),
    SelectionOption<String>(label: "nate.com", value: "nate.com"),
    SelectionOption<String>(label: "yahoo.com", value: "yahoo.com"),
    SelectionOption<String>(label: "직접 입력", value: "직접 입력"),
  ];

  @override
  void initState() {
    super.initState();
    value = widget.value;
    isVerify = false;
    //controller.text = widget.value;
  }

  void showDialog(String message) {
    showSGDialog(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(message,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              SizedBox(height: SGSpacing.p8),
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
            ]);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeInformationNotifierProvider);
    final provider = ref.read(storeInformationNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                widget.onSubmit(controller.text);
                Navigator.of(context).pop();
              },
              disabled: isVerify ? false : true,
              label: widget.buttonText)),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.label("변경 전"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(SGSpacing.p4),
                hintText: widget.value,
                isCollapsed: true,
                hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                enabled: false,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none),
              )),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.label("변경 후"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(
              children: [
                Expanded(
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                // ref
                                //     .read(signupNotifierProvider.notifier)
                                //     .onChangeEmail(value);
                                controller.text = value;
                              },
                              style: TextStyle(
                                  fontSize: FontSize.small,
                                  color: SGColors.gray5),
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                    color: SGColors.gray3,
                                    fontSize: FontSize.small,
                                    fontWeight: FontWeight.w400),
                                hintText: "이메일 앞자리",
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ],
                    ),
                  )),
                ),
                SizedBox(width: SGSpacing.p4),
                SGTypography.body("@",
                    size: FontSize.medium,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(width: SGSpacing.p4),
                Expanded(
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: emailInputOption == "직접 입력",
                              controller: emailDomainController,
                              onChanged: (value) {
                                // ref
                                //     .read(signupNotifierProvider.notifier)
                                //     .onChangeDomain(value);
                              },
                              style: TextStyle(
                                  fontSize: FontSize.small,
                                  color: SGColors.gray5),
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                    color: SGColors.gray3,
                                    fontSize: FontSize.small,
                                    fontWeight: FontWeight.w400),
                                hintText: "이메일 뒷자리",
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ],
                    ),
                  )),
                ),
              ],
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            GestureDetector(
              onTap: () {
                showSelectionBottomSheet<String>(
                    context: context,
                    title: "이메일 뒷자리를 선택해주세요.",
                    options: emailInputOptions,
                    onSelect: (value) {
                      setState(() {
                        emailInputOption = value;
                        if (value == "직접 입력") {
                          emailDomainController.text = "";
                          // ref
                          //     .read(signupNotifierProvider.notifier)
                          //     .onChangeDomain(value);
                        } else {
                          emailDomainController.text = value;
                          // ref
                          //     .read(signupNotifierProvider.notifier)
                          //     .onChangeDomain(value);
                        }
                      });
                    },
                    selected: emailInputOption);
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: false,
                              style: TextStyle(
                                  fontSize: FontSize.small,
                                  color: SGColors.gray5),
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle: TextStyle(
                                    color: SGColors.gray3,
                                    fontSize: FontSize.small,
                                    fontWeight: FontWeight.w400),
                                hintText: emailInputOption,
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ],
                    ),
                  )),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: Image.asset("assets/images/dropdown-arrow.png",
                          width: SGSpacing.p5, height: SGSpacing.p5))
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            if (isSendCode) ...[
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            authController.text = value;
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
                            hintText: "인증번호",
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          )),
                    ),
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              GestureDetector(
                onTap: () async {
                  await provider.verifyEmailCode(
                      '${controller.text}@${emailDomainController.text}',
                      authController.text);

                  if (state.status == StoreInformationStatus.success) {
                    showDialog("이메일 인증이 완료되었습니다.");
                    setState(() {
                      isVerify = true;
                    });
                  } else {
                    showDialog("인증에 실패하였습니다.\n잠시후 다시 시도해주세요");
                  }
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p4 + SGSpacing.p05),
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이메일 인증 확인",
                            color: SGColors.primary,
                            weight: FontWeight.w500,
                            size: FontSize.small))),
              ),
            ] else ...[
              GestureDetector(
                onTap: () {
                  provider.sendEmailCode(
                      '${controller.text}@${emailDomainController.text}');

                  setState(() {
                    isSendCode = true;
                  });

                  showDialog("사장님 이메일로 인증메일을\n보내드렸습니다.");
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p4 + SGSpacing.p05),
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이메일 인증",
                            color: SGColors.primary,
                            weight: FontWeight.w700,
                            size: FontSize.small))),
              ),
            ],
          ])),
    );
  }
}
