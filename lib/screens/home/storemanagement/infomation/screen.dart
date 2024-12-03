import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/single_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/core/screens/image_upload_screen.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/core/screens/textarea_screen.dart';
import 'package:singleeat/screens/home/storemanagement/infomation/provider.dart';

class StoreManagementBasicInfoScreen extends ConsumerStatefulWidget {
  const StoreManagementBasicInfoScreen({super.key});

  @override
  ConsumerState<StoreManagementBasicInfoScreen> createState() =>
      _StoreManagementBasicInfoScreenState();
}

class _StoreManagementBasicInfoScreenState
    extends ConsumerState<StoreManagementBasicInfoScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(storeManagementBasicInfoNotifierProvider.notifier).storeInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeManagementBasicInfoNotifierProvider);
    final provider =
        ref.read(storeManagementBasicInfoNotifierProvider.notifier);
    return ListView(shrinkWrap: true, children: [
      SGContainer(
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("로고 (썸네일 이미지)",
                  size: FontSize.normal, weight: FontWeight.w600),
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
      SingleInformationBox(
          label: '가게 이름', value: state.storeInfo.name, editable: false),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 번호', value: state.storeInfo.storeNum),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 카테고리', value: '카테고리'),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SingleInformationBox(label: '가게 위치', value: state.storeInfo.address),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      GestureDetector(
          child: SingleInformationBox(
              label: '가게 전화번호', value: state.storeInfo.phone, editable: true),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TextFieldEditScreen(
                    value: state.storeInfo.phone,
                    title: "가게 전화번호 변경",
                    hintText: "가게 전화번호를 입력해주세요",
                    buttonText: "변경하기",
                    onSubmit: (value) {
                      provider.storePhone(value).then((value) {
                        if (value) {
                          context.pop();
                        } else {
                          showFailDialogWithImage(
                              mainTitle: '가게 번호 변경 실패',
                              subTitle: '가게 번호 변경이 실패 하였습니다.');
                        }
                      });
                    })));
          }),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SGContainer(
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("가게 이미지",
                  size: FontSize.normal, weight: FontWeight.w600),
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
          child: SingleInformationBox(
              label: '가게 소개',
              value: state.storeInfo.introduction,
              editable: true),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TextAreaScreen(
                    value: state.storeInfo.introduction,
                    title: "가게 소개 변경",
                    fieldLabel: "가게 소개",
                    hintText: "가게 소개를 입력해주세요",
                    buttonText: "변경하기",
                    onSubmit: (value) {
                      provider.storeIntroduction(value).then((value) {
                        if (value) {
                          context.pop();
                        } else {
                          showFailDialogWithImage(
                              mainTitle: '가게 소개 변경 오류',
                              subTitle: '가게 소개 변경 오류');
                        }
                      });
                    })));
          }),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      SGContainer(
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line2,
          borderRadius: BorderRadius.circular(SGSpacing.p4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SGTypography.body("가게 소개 이미지",
                  size: FontSize.normal, weight: FontWeight.w600),
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
          ref.read(goRouterProvider).push(AppRoutes.allergyInformation);
        },
        child: SingleInformationBox(
          label: '원산지 및 알러지 정보',
          value: state.storeInfo.originInformation,
          editable: true,
        ),
      ),
      SizedBox(height: SGSpacing.p32),
    ]);
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
