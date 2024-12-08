import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class PhoneEditScreen extends ConsumerStatefulWidget {
  final String value;
  final String title;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;

  PhoneEditScreen({
    Key? key,
    required this.value,
    required this.title,
    required this.hintText,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  ConsumerState<PhoneEditScreen> createState() => _PhoneEditScreen();
}

class _PhoneEditScreen extends ConsumerState<PhoneEditScreen> {
  late String value;
  late TextEditingController controller = TextEditingController();

  TextStyle baseStyle =
      TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  late TextEditingController emailDomainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    value = widget.value;
    controller.text = widget.value;
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
            SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
                color: Colors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.primary,
                boxShadow: SGBoxShadow.large,
                child: InkWell(
                  onTap: () async {
                    /* final response =
                        ref.read(authenticateWithPhoneNumberServiceProvider);
                    ref
                        .read(findAccountWebViewNotifierProvider.notifier)
                        .onChangeHtml(html: response.data);*/
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SGTypography.body("사장님 전화번호 변경하기",
                            size: FontSize.normal,
                            weight: FontWeight.w700,
                            color: SGColors.primary),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            size: FontSize.small, color: SGColors.gray3),
                      ]),
                )),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("본인명의 휴대폰이 없는 경우, 싱그릿 고객센터 1600-7723 로 연락해주세요.",
                color: SGColors.gray4,
                size: FontSize.small,
                weight: FontWeight.w400),
          ])),
    );
  }
}
