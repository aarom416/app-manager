import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../../core/components/action_button.dart';
import '../../../../../../core/components/dialog.dart';
import '../../../../../../core/components/multiple_information_box.dart';
import '../../../../../../core/components/snackbar.dart';
import '../../../../../../core/components/switch.dart';
import '../../../../../../core/components/typography.dart';
import '../../../../../../core/screens/image_upload_screen.dart';
import '../../../../../../core/screens/text_field_edit_screen.dart';
import '../../../../../../core/screens/textarea_edit_screen.dart';
import '../../../../../../main.dart';
import '../../model.dart';
import '../../provider.dart';
import '../../updatenutrition/nutrition_card.dart';
import '../../updatenutrition/screen.dart';
import 'menu_option_category_card.dart';

class UpdateMenuScreen extends ConsumerStatefulWidget {
  final int menuCategoryId;
  final int menuId;

  const UpdateMenuScreen({super.key, required this.menuCategoryId, required this.menuId});

  @override
  ConsumerState<UpdateMenuScreen> createState() => _UpdateMenuScreenState();
}

class _UpdateMenuScreenState extends ConsumerState<UpdateMenuScreen> {
  late MenuModel menuModel;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(menuOptionsNotifierProvider.notifier).getMenu(widget.menuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);
    menuModel = state.menuCategoryList
        .firstWhere(
          (menuCategory) => menuCategory.storeMenuCategoryId == widget.menuCategoryId,
        )
        .menuList
        .firstWhere(
          (menu) => menu.menuId == widget.menuId,
        );

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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (menuModel.menuPictureURL.isNotEmpty) ... [
                                Image.network(
                                  menuModel.menuPictureURL,
                                  width: SGSpacing.p20,
                                  height: SGSpacing.p20,
                                  fit: BoxFit.cover,
                                ),
                                if (menuModel.soldOutStatus == 1)
                                  Container(
                                    width: SGSpacing.p20,
                                    height: SGSpacing.p20,
                                    color: const Color(0xFF808080).withOpacity(0.7),
                                    child: const Center(
                                      child: Text(
                                        "품절",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: FontSize.small,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ]
                              else ... [
                                Container(
                                    width: SGSpacing.p18,
                                    height: SGSpacing.p18,
                                    child: Image.asset("assets/images/default_poke.png")
                                ),
                                if (menuModel.soldOutStatus == 1)
                                  Container(
                                    width: SGSpacing.p20,
                                    height: SGSpacing.p20,
                                    color: const Color(0xFF808080).withOpacity(0.7),
                                    child: const Center(
                                      child: Text(
                                        "품절",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: FontSize.small,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ]
                            ],
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
                                    provider.adminUpdateMenuPicture(widget.menuId, imagePaths[0]);
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
                              child: const Icon(Icons.edit, size: FontSize.small),
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
                              provider.updateMenuName(widget.menuId, value).then((success) {
                                logger.d("updateMenuName success $success $value");
                                if (success) {
                                  showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
                                }
                              });
                            },
                          ),
                        ));
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
                                  keyboardType: TextInputType.number,
                                  onSubmit: (value) {
                                    int? price = int.tryParse(value);
                                    if (price != null) {
                                      provider.updateMenuPrice(widget.menuId, price).then((success) {
                                        logger.d("updateMenuPrice success $success $value");
                                        if (success) {
                                          showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
                                        }
                                      });
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
                            provider.updateMenuSoldOutStatus(widget.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuSoldOutStatus success $success $value");
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
                            provider.updateMenuPopularity(widget.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuPopularity success $success $value");
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
                            provider.updateMenuBestStatus(widget.menuId, value ? 1 : 0).then((success) {
                              logger.d("updateMenuBestStatus success $success $value");
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
                            builder: (context) => TextAreaEditScreen(
                                  value: menuModel.madeOf,
                                  title: "메뉴 구성",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 구성을 입력해주세요.",
                                  onSubmit: (value) {
                                    provider.updateMenuMadeOf(widget.menuId, value).then((success) {
                                      logger.d("updateMenuMadeOf success $success $value");
                                      if (success) {
                                        showGlobalSnackBarWithoutContext("성공적으로 변경되었습니다.");
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
                    SGTypography.body(menuModel.madeOf, size: FontSize.small, weight: FontWeight.w500),
                  ]),
                  SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

                  // --------------------------- 메뉴 설명 ---------------------------
                  MultipleInformationBox(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextAreaEditScreen(
                                  value: menuModel.menuIntroduction,
                                  title: "메뉴 설명",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 설명을 입력해주세요.",
                                  onSubmit: (value) {
                                    provider.updateMenuIntroduction(widget.menuId, value).then((success) {
                                      logger.d("updateMenuIntroduction success $success $value");
                                      if (success) {
                                        showGlobalSnackBarWithoutContext("성공적으로 변경되었습니다.");
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
                    SGTypography.body(menuModel.menuIntroduction, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
                  ]),

                  // --------------------------- 메뉴 옵션 리스트 ---------------------------
                  ...menuModel.menuCategoryOptions.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final category = entry.value;
                    return [
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                      MenuOptionCategoryCard(category: category),
                    ];
                  }).expand((element) => element)
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
                    type: 0,
                    onTap: () {
                      final screenContext = context;
                      Navigator.of(screenContext).push(MaterialPageRoute(
                          builder: (nutritionScreenContext) => UpdateNutritionScreen(
                                title: "영양성분 수정",
                                nutrition: menuModel.nutrition,
                                onConfirm: (nutrition, context) {
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
                                                    provider.updateMenuInfo(widget.menuId, nutrition).then((success) {
                                                      logger.d("updateMenuOptionInfo success $success $nutrition");
                                                      if (success) {
                                                        showGlobalSnackBarWithoutContext("성공적으로 변경되었습니다.");
                                                      }
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
                                        provider.deleteMenu(menuModel).then((resultFailResponseModel) {
                                          logger.d("deleteMenu resultFailResponseModel ${resultFailResponseModel.toFormattedJson()}");
                                          if (resultFailResponseModel.errorCode.isEmpty) {
                                            showGlobalSnackBarWithoutContext("성공적으로 삭제되었습니다.");
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(context).pop();
                                            showFailDialogWithImage(
                                                context: context,
                                                mainTitle: resultFailResponseModel.errorMessage,
                                                onTapFunction: () {
                                                  Navigator.pop(context);
                                                });
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
