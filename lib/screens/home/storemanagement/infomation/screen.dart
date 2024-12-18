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

import '../../../../core/components/network_image_container.dart';
import '../../../../core/components/snackbar.dart';
import '../../../../main.dart';

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

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: SGColors.primary,
      onRefresh: () async {
        provider.storeInfo();
      },
      child: ListView(shrinkWrap: true, children: [
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
                      title: "가게 로고 변경",
                      imagePaths: [],
                      maximumImages: 1,
                      fieldLabel: "로고 이미지",
                      buttonText: "변경하기",
                      onSubmit: (List<String> imagePaths) {
                        logger.i("imagePaths $imagePaths");
                        provider.updateStoreThumbnail(imagePaths[0]);
                      },
                    ),
                  ));
                },
                child: const Icon(Icons.edit, size: FontSize.small),
              ),
              const Spacer(),
              NetworkImageContainer(
                key: ValueKey(state.storeInfo.thumbnail),
                networkImageUrl: state.storeInfo.thumbnail,
              ),
            ],
          ),
        ),
        SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
        SingleInformationBox(
            label: '가게 이름', value: state.storeInfo.name, editable: false),
        SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
        SingleInformationBox(label: '가게 번호', value: state.storeInfo.storeNum),
        SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
        SingleInformationBox(label: '가게 카테고리', value: state.storeInfo.brand),
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
                        showUpdatePhoneSGDialog(
                            context: context,
                            childrenBuilder: (ctx) => [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SGTypography.body("가게 전화번호 변경 희망 시",
                                          size: FontSize.large,
                                          weight: FontWeight.w600),
                                      SizedBox(height: SGSpacing.p1),
                                      SGTypography.body("고객센터로 연락주세요.",
                                          size: FontSize.large,
                                          weight: FontWeight.w600),
                                      SizedBox(height: SGSpacing.p3),
                                      SGTypography.body(
                                          "싱그릿 식단 연구소 고객센터(1600-7723)",
                                          color: SGColors.gray4,
                                          size: FontSize.normal,
                                          weight: FontWeight.w500),
                                      SizedBox(height: SGSpacing.p5),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pop(ctx);
                                        },
                                        child: SGContainer(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: SGSpacing.p4),
                                          borderRadius: BorderRadius.circular(
                                              SGSpacing.p3),
                                          color: SGColors.primary,
                                          child: Center(
                                            child: SGTypography.body("확인",
                                                size: FontSize.normal,
                                                weight: FontWeight.w700,
                                                color: SGColors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ]);
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
                      title: "가게 이미지 변경",
                      imagePaths: [],
                      maximumImages: 3,
                      fieldLabel: "가게 이미지",
                      buttonText: "변경하기",
                      onSubmit: (List<String> imagePaths) {
                        logger.i("imagePaths $imagePaths");
                        provider.updateStorePicture(imagePaths);
                      },
                    ),
                  ));
                },
                child: const Icon(Icons.edit, size: FontSize.small),
              ),
              const Spacer(),
              NetworkImageContainer(
                key: ValueKey(state.storeInfo.storePictureURL1),
                networkImageUrl: state.storeInfo.storePictureURL1,
              ),
            ],
          ),
        ),
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
                        provider.onChangeStoreIntroduction(value);
                        provider.storeIntroduction(successCallback: () {
                          context.pop();
                        }, errorCallback: (errorMessage) {
                          showFailDialogWithImage(
                            context: context,
                            mainTitle: errorMessage,
                          );
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
                      title: "가게 소개 이미지 변경",
                      imagePaths: [],
                      maximumImages: 1,
                      fieldLabel: "가게 소개 이미지",
                      buttonText: "변경하기",
                      onSubmit: (List<String> imagePaths) {
                        logger.i("imagePaths $imagePaths");
                        provider.updateIntroductionPicture(imagePaths[0]);
                      },
                    ),
                  ));
                },
                child: const Icon(Icons.edit, size: FontSize.small),
              ),
              const Spacer(),
              NetworkImageContainer(
                key: ValueKey(state.storeInfo.storeInformationURL),
                networkImageUrl: state.storeInfo.storeInformationURL,
              ),
            ],
          ),
        ),
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
      ]),
    );
  }
}

void showUpdatePhoneSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(SGSpacing.p5),
        child: SGContainer(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                      EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}
