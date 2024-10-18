import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/checkbox_group.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/radio.dart';
import 'package:singleeat/core/components/single_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/screens/image_upload_screen.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/core/screens/textarea_screen.dart';
import 'package:singleeat/office/bloc/store_bloc.dart';
import 'package:singleeat/office/models/store_model.dart';

class StoreManagementBasicInfoScreen extends StatefulWidget {
  @override
  State<StoreManagementBasicInfoScreen> createState() => _StoreManagementBasicInfoScreenState();
}

class _StoreManagementBasicInfoScreenState extends State<StoreManagementBasicInfoScreen> {
  String phoneNumber = "";
  String introduction = "";

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreBloc>().state.store;

    return ListView(shrinkWrap: true, children: [
      SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("로고 (썸네일 이미지)", size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageUploadScreen(
                            images: [],
                            title: "가게 로고 변경",
                            fieldLabel: "로고 이미지",
                            buttonText: "변경하기",
                            maximumImages: 1,
                            onSubmit: (images) {})));
                  },
                  child: const Icon(Icons.edit, size: FontSize.small)),
              const Spacer(),
              SGContainer(
                color: SGColors.gray1,
                width: SGSpacing.p20,
                height: SGSpacing.p20,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
              )
            ],
          )),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 이름', value: "asdasd" ?? "", editable: false),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 번호', value: store?.id ?? ""),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 카테고리', value: "asdasd" ?? ""),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 위치', value: "asdasd" ?? ""),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      GestureDetector(
          child: SingleInformationBox(label: '가게 전화번호', value: phoneNumber, editable: true),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TextFieldEditScreen(
                    value: phoneNumber,
                    title: "가게 전화번호 변경",
                    hintText: "가게 전화번호를 입력해주세요",
                    buttonText: "변경하기",
                    onSubmit: (value) {
                      setState(() {
                        phoneNumber = value;
                      });
                    })));
          }),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("가게 이미지", size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageUploadScreen(
                            images: [],
                            title: "가게 이미지 변경",
                            fieldLabel: "가게 소개 이미지",
                            buttonText: "변경하기",
                            maximumImages: 3,
                            onSubmit: (images) {})));
                  },
                  child: const Icon(Icons.edit, size: FontSize.small)),
              const Spacer(),
              SGContainer(
                color: SGColors.gray1,
                width: SGSpacing.p20,
                height: SGSpacing.p20,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
              )
            ],
          )),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      GestureDetector(
          child: SingleInformationBox(label: '가게 소개', value: introduction, editable: true),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TextAreaScreen(
                    value: introduction,
                    title: "가게 소개 변경",
                    fieldLabel: "가게 소개",
                    hintText: "가게 소개를 입력해주세요",
                    buttonText: "변경하기",
                    onSubmit: (value) {
                      setState(() {
                        introduction = value;
                      });
                    })));
          }),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("가게 소개 이미지", size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageUploadScreen(
                            images: [],
                            title: "가게 소개 이미지 변경",
                            fieldLabel: "가게 소개 이미지",
                            buttonText: "변경하기",
                            maximumImages: 1,
                            onSubmit: (images) {})));
                  },
                  child: const Icon(Icons.edit, size: FontSize.small)),
              const Spacer(),
              SGContainer(
                color: SGColors.gray1,
                width: SGSpacing.p20,
                height: SGSpacing.p20,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
              )
            ],
          )),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AllergyInformationScreen()));
        },
        child: SingleInformationBox(
          label: '원산지 및 알러지 정보',
          value: "",
          editable: true,
        ),
      ),
      SizedBox(height: SGSpacing.p32),
    ]);
  }
}

class AllergyInformationScreen extends StatefulWidget {
  const AllergyInformationScreen({super.key});

  @override
  State<AllergyInformationScreen> createState() => _AllergyInformationScreenState();
}

class _AllergyInformationScreenState extends State<AllergyInformationScreen> {
  String allergyInformationLink = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "원산지 및 알러지 정보"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: "변경하기",
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("원산지 정보 URL", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p2, vertical: SGSpacing.p3),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                            hintText: "원산지 및 알러지 정보 URL을 입력해주세요",
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          )),
                    ),
                    Image.asset('assets/images/link-icon.png', width: 20, height: 20),
                    SizedBox(width: SGSpacing.p1)
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p2),
              SGTypography.body("「농수산물의 원산지 표시에 관한 법률 에 의거하여 원산지가 표시되어 있는 링크를 삽입해 주세요",
                  size: FontSize.tiny, weight: FontWeight.w400, color: SGColors.gray4),
            ])));
  }
}
