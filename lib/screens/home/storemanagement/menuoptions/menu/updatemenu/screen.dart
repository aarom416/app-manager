import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/core/screens/textarea_edit_screen.dart';

import '../../../../../../core/screens/image_upload_screen.dart';
import '../../../../../../main.dart';
import 'menu_option_category_card.dart';
import '../../model.dart';
import '../../nutrition/nutrition_card.dart';
import '../../nutrition/screen.dart';
import '../../provider.dart';

class UpdateMenuScreen extends ConsumerStatefulWidget {
  final MenuModel menuModel;

  const UpdateMenuScreen({super.key, required this.menuModel});

  @override
  ConsumerState<UpdateMenuScreen> createState() => _UpdateMenuScreenState();
}

class _UpdateMenuScreenState extends ConsumerState<UpdateMenuScreen> {
  late MenuModel menuModel;

  @override
  void initState() {
    super.initState();
    menuModel = widget.menuModel;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "메뉴 관리"),
        body: SGContainer(
          borderWidth: 0,
          color: const Color(0xFFFAFAFA),
          child: ListView(children: [
            SGContainer(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                child: Column(children: [
                  Row(children: [
                    // --------------------------- menuPictureURL ---------------------------
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          child: Image.network(
                            key: ValueKey(menuModel.menuPictureURL),
                            // "${menuModel.menuPictureURL}?${DateTime.now().millisecondsSinceEpoch}",
                            menuModel.menuPictureURL,
                            width: SGSpacing.p20,
                            height: SGSpacing.p20,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ImageUploadScreen(
                                  title: "메뉴 이미지",
                                  imagePaths: [],
                                  maximumImages: 1,
                                  fieldLabel: "메뉴 이미지",
                                  buttonText: "변경하기",
                                  onSubmit: (List<String> imagePaths) {
                                    logger.i("imagePaths $imagePaths");
                                    provider.adminUpdateMenuPicture(widget.menuModel.menuId, imagePaths[0]);
                                  },
                                ),
                              ),
                            );
                          },
                          child: SGContainer(
                            padding: EdgeInsets.all(SGSpacing.p1),
                            child: CircleAvatar(
                              radius: SGSpacing.p4,
                              backgroundColor: SGColors.line2,
                              child: Icon(Icons.edit, size: FontSize.small),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: SGSpacing.p3),

                    // --------------------------- 메뉴명, 가격 ---------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SGTypography.body(menuModel.menuName, size: FontSize.medium, weight: FontWeight.w700),
                        SizedBox(height: SGSpacing.p2),
                        SGTypography.body("${menuModel.price.toKoreanCurrency}원", size: FontSize.small, color: SGColors.gray4, weight: FontWeight.w400),
                      ],
                    )
                  ]),
                  SizedBox(height: SGSpacing.p3),

                  Row(children: [
                    // --------------------------- 메뉴명 변경 ---------------------------
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextFieldEditScreen(
                                  value: menuModel.menuName,
                                  title: "메뉴명 변경",
                                  buttonText: "변경하기",
                                  hintText: "메뉴명을 입력해주세요.",
                                  onSubmit: (value) {
                                    provider.updateMenuName(widget.menuModel.menuId, value).then((success) {
                                      logger.d("updateMenuName success $success $value");
                                      if (success) {
                                        setState(() {
                                          menuModel = menuModel.copyWith(menuName: value);
                                        });
                                      }
                                    });
                                    Navigator.of(context).pop();
                                  },
                                )));
                      },
                      child: SGContainer(
                        borderColor: SGColors.line3,
                        borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                        child: Center(child: SGTypography.body("메뉴명 변경", size: FontSize.small, weight: FontWeight.w400, color: SGColors.gray4)),
                      ),
                    )),
                    SizedBox(width: SGSpacing.p1),

                    // --------------------------- 가격 변경 ---------------------------
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextFieldEditScreen(
                                  value: menuModel.price.toString(),
                                  title: "가격 변경",
                                  buttonText: "변경하기",
                                  hintText: "가격을 입력해주세요.",
                                  onSubmit: (value) {
                                    int? price = int.tryParse(value);
                                    if (price != null) {
                                      provider.updateMenuPrice(widget.menuModel.menuId, price).then((success) {
                                        logger.d("updateMenuPrice success $success $value");
                                        if (success) {
                                          setState(() {
                                            menuModel = menuModel.copyWith(price: price);
                                          });
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )));
                      },
                      child: SGContainer(
                        borderColor: SGColors.line3,
                        borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                        child: Center(child: SGTypography.body("가격 변경", size: FontSize.small, weight: FontWeight.w400, color: SGColors.gray4)),
                      ),
                    )),
                  ]),
                  SizedBox(height: SGSpacing.p3),

                  // --------------------------- 품절 ---------------------------
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("품절", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      const Spacer(),
                      SGSwitch(
                          value: menuModel.soldOutStatus == 1,
                          onChanged: (value) {
                            provider.updateMenuSoldOutStatus(widget.menuModel.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuSoldOutStatus success $success $value");
                              if (success) {
                                setState(() {
                                  menuModel = menuModel.copyWith(soldOutStatus: value ? 1 : 0);
                                });
                              }
                            });
                          }),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p3),

                  // --------------------------- 인기 메뉴 등록 ---------------------------
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("인기 메뉴 등록", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      const Spacer(),
                      SGSwitch(
                          value: menuModel.popularityStatus == 1,
                          onChanged: (value) {
                            provider.updateMenuPopularity(widget.menuModel.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuPopularity success $success $value");
                              if (success) {
                                setState(() {
                                  menuModel = menuModel.copyWith(popularityStatus: value ? 1 : 0);
                                });
                              }
                            });
                          }),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p3),

                  // --------------------------- 베스트 메뉴 ---------------------------
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("베스트 메뉴", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      const Spacer(),
                      SGSwitch(
                          value: menuModel.bestStatus == 1,
                          onChanged: (value) {
                            provider.updateMenuBestStatus(widget.menuModel.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuBestStatus success $success $value");
                              if (success) {
                                setState(() {
                                  menuModel = menuModel.copyWith(bestStatus: value ? 1 : 0);
                                });
                              }
                            });
                          }),
                    ]),
                  ),
                ])),
            SGContainer(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: SGSpacing.p5),
                child: Column(children: [
                  // --------------------------- 메뉴 구성 ---------------------------
                  MultipleInformationBox(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextareaEditScreen(
                                  value: menuModel.menuParts,
                                  title: "메뉴 구성",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 구성을 입력해주세요.",
                                  onSubmit: (value) {
                                    provider.updateMenuMadeOf(widget.menuModel.menuId, value).then((success) {
                                      logger.d("updateMenuMadeOf success $success $value");
                                      if (success) {
                                        setState(() {
                                          menuModel = menuModel.copyWith(menuParts: value);
                                        });
                                      }
                                    });
                                  },
                                  maxLength: 100,
                                )));
                      },
                      child: Row(
                        children: [
                          SGTypography.body("메뉴 구성", size: FontSize.normal, weight: FontWeight.w600),
                          SizedBox(width: SGSpacing.p1),
                          const Icon(Icons.edit, size: FontSize.small),
                        ],
                      ),
                    ),
                    SizedBox(height: SGSpacing.p5),
                    SGTypography.body(menuModel.menuParts, size: FontSize.small, weight: FontWeight.w500),
                  ]),
                  SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

                  // --------------------------- 메뉴 설명 ---------------------------
                  MultipleInformationBox(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextareaEditScreen(
                                  value: menuModel.menuDescription,
                                  title: "메뉴 설명",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 설명을 입력해주세요.",
                                  onSubmit: (value) {
                                    provider.updateMenuIntroduction(widget.menuModel.menuId, value).then((success) {
                                      logger.d("updateMenuIntroduction success $success $value");
                                      if (success) {
                                        setState(() {
                                          menuModel = menuModel.copyWith(menuDescription: value);
                                        });
                                      }
                                    });
                                  },
                                  maxLength: 100,
                                )));
                      },
                      child: Row(
                        children: [
                          SGTypography.body("메뉴 설명", size: FontSize.normal, weight: FontWeight.w600),
                          SizedBox(width: SGSpacing.p1),
                          const Icon(Icons.edit, size: FontSize.small),
                        ],
                      ),
                    ),
                    SizedBox(height: SGSpacing.p5),
                    SGTypography.body(menuModel.menuDescription, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
                  ]),

                  // --------------------------- 메뉴 옵션 리스트 ---------------------------
                  ...widget.menuModel.menuCategoryOptions
                      .mapIndexed((idx, category) => [
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                            MenuOptionCategoryCard(category: category),
                          ])
                      .flattened
                ])),
            SGContainer(height: SGSpacing.p2, color: SGColors.gray1),

            // --------------------------- 영양성분 ---------------------------
            SGContainer(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: SGSpacing.p5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGTypography.body("총 영양성분", size: FontSize.large, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  NutritionCard(
                    nutrition: menuModel.nutrition,
                    onTap: () {
                      final screenContext = context;
                      Navigator.of(screenContext).push(MaterialPageRoute(
                          builder: (nutritionScreenContext) => NutritionInputScreen(
                                title: "영양성분 수정",
                                nutrition: menuModel.nutrition,
                                onConfirm: (nutrition,  context) {
                                  showSGDialog(
                                      context: context,
                                      childrenBuilder: (ctx) => [
                                            Center(child: SGTypography.body("영양성분을\n정말 수정하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                                            SizedBox(height: SGSpacing.p5),
                                            Row(children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: SGContainer(
                                                    color: SGColors.gray3,
                                                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                                                    child: Center(
                                                      child: SGTypography.body("취소", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: SGSpacing.p2),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      menuModel = menuModel.copyWith(nutrition: nutrition);
                                                    });
                                                    Navigator.of(context).pop();
                                                    Navigator.of(nutritionScreenContext).pop();
                                                  },
                                                  child: SGContainer(
                                                    color: SGColors.primary,
                                                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                                                    child: Center(
                                                      child: SGTypography.body("확인", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ]);
                                },
                              )));
                    },
                  ),
                ])),
            SGContainer(height: SGSpacing.p2, color: SGColors.gray1),

            // --------------------------- 메뉴 삭제 ---------------------------
            SGContainer(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(top: SGSpacing.p5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGActionButton(
                    onPressed: () {
                      showSGDialog(
                          context: context,
                          childrenBuilder: (ctx) => [
                                Center(child: SGTypography.body("메뉴를\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                                SizedBox(height: SGSpacing.p5),
                                Row(children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        provider.deleteMenu(widget.menuModel).then((success) {
                                          logger.d("updateMenuIntroduction success $success");
                                          if (success) {
                                            Navigator.of(context).pop();
                                          } else {
                                            if (state.error.errorCode == 409) {
                                              showFailDialogWithImage(
                                                context: context,
                                                mainTitle: "진행 중인 주문에 선택된 메뉴입니다.\n주문 완료 후 삭제 가능합니다.",
                                              );
                                            }
                                          }
                                        });
                                      },
                                      child: SGContainer(
                                        color: SGColors.gray3,
                                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                                        child: Center(
                                          child: SGTypography.body("확인", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: SGSpacing.p2),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: SGContainer(
                                        color: SGColors.primary,
                                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                                        child: Center(
                                          child: SGTypography.body("취소", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ]);
                    },
                    label: "메뉴 삭제",
                    variant: SGActionButtonVariant.danger,
                  ),
                  SizedBox(height: SGSpacing.p24),
                ])),
          ]),
        ));
  }
}
