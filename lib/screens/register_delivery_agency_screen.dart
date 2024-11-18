import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class RegisterDeliveryAgencyScreen extends StatefulWidget {
  const RegisterDeliveryAgencyScreen({super.key});

  @override
  State<RegisterDeliveryAgencyScreen> createState() =>
      _RegisterDeliveryAgencyScreenState();
}

class _RegisterDeliveryAgencyScreenState
    extends State<RegisterDeliveryAgencyScreen> {
  String phoneNumber = "";
  String registrationNumber = "";
  String agencyAuthCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "배달대행사 설정"),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: "조회하기")),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("배달대행사에 등록된\n대표님의 정보를 입력해주세요",
                  size: FontSize.large,
                  weight: FontWeight.w700,
                  lineHeight: 1.35),
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("대표자 전화번호",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
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
                              hintText: "전화번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("사업자 번호",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                registrationNumber = value;
                              });
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
                              hintText: "사업자 번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("배달대행사 인증번호",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                agencyAuthCode = value;
                              });
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
                              hintText: "인증번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("대표자명",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            enabled: false,
                            controller: TextEditingController()..text = "홍길동",
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
                              hintText: "인증번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              SizedBox(height: SGSpacing.p32 * 2),
            ])));
  }
}
