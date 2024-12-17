import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/app_bar_with_step_indicator.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/image_upload_screen.dart';
import 'package:singleeat/core/screens/textarea_screen.dart';

import '../../../../../../core/components/numeric_textfield.dart';
import '../../../../../../main.dart';
import '../../model.dart';
import '../../provider.dart';
import '../../updatenutrition/nutrition_card.dart';
import '../../updatenutrition/screen.dart';
import '../addmenucategory/screen.dart';
import 'menu_option_category_selection_bottom_sheet.dart';

List<String> userMenuCategories = [
  "샐러드",
  "포케",
  "샌드위치",
  "카페",
  "베이커리",
  "버거",
];

class AddMenuScreen extends ConsumerStatefulWidget {
  const AddMenuScreen({super.key});

  @override
  ConsumerState<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends ConsumerState<AddMenuScreen> {
  PageController pageController = PageController();

  String menuName = "";
  MenuCategoryModel selectedMenuCategory = const MenuCategoryModel(storeMenuCategoryId: -1);
  List<String> selectedUserMenuCategories = [];
  int price = 0;
  NutritionModel nutrition = const NutritionModel();
  String imagePath = "";
  String menuBriefDescription = "";
  String menuIntroduction = "";
  List<MenuOptionCategoryModel> selectedMenuOptionCategories = [];

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    return Scaffold(
      body: PageView(controller: pageController, physics: const NeverScrollableScrollPhysics(), children: [
        _Page_0_MenuName(
          menuName: menuName,
          onPrev: () => Navigator.pop(context),
          onNext: () => animateToPage(1),
          onEditFunction: (menuName) {
            setState(() {
              this.menuName = menuName;
            });
          },
        ),
        _Page_1_MenuCategory(
          storeMenuCategoryDTOList: state.storeMenuCategoryDTOList,
          selectedMenuCategory: selectedMenuCategory,
          selectedUserMenuCategories: selectedUserMenuCategories,
          onPrev: () => animateToPage(0),
          onNext: () => animateToPage(2),
          onEditMenuCategoryFunction: (selectedMenuCategory) {
            setState(() {
              this.selectedMenuCategory = selectedMenuCategory;
            });
          },
          onEditUserMenuCategoryFunction: (selectedUserMenuCategories) {
            setState(() {
              this.selectedUserMenuCategories = selectedUserMenuCategories;
            });
          },
        ),
        _Page_2_MenuPrice(
          price: price,
          onPrev: () => animateToPage(1),
          onNext: () => animateToPage(3),
          onEditFunction: (price) {
            setState(() {
              this.price = price;
            });
          },
        ),
        _Page_3_MenuNutrition(
          nutrition: nutrition,
          onPrev: () => animateToPage(2),
          onNext: () => animateToPage(4),
          onEditFunction: (nutrition) {
            setState(() {
              this.nutrition = nutrition;
            });
          },
        ),
        _Page_4_MenuRegistration(
          imagePath: imagePath,
          menuBriefDescription: menuBriefDescription,
          menuIntroduction: menuIntroduction,
          selectedMenuOptionCategories: selectedMenuOptionCategories,
          onPrev: () => animateToPage(3),
          onNext: () => {
            provider
                .createMenu(
              menuName,
              selectedMenuCategory,
              selectedUserMenuCategories.map((category) => userMenuCategories.indexOf(category)).toList().join(),
              price,
              nutrition,
              imagePath,
              menuBriefDescription,
              menuIntroduction,
              selectedMenuOptionCategories,
            )
                .then((resultFailResponseModel) {
              if (resultFailResponseModel.errorCode.isEmpty) {
                showFailDialogWithImage(
                    context: context,
                    mainTitle: "성공적으로 등록되었습니다.",
                    onTapFunction: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
              } else {
                showFailDialogWithImage(
                    context: context,
                    mainTitle: resultFailResponseModel.errorMessage,
                    onTapFunction: () {
                      Navigator.pop(context);
                    });
              }
            }),
          },
          onEditFunction: (imagePath, menuBriefDescription, menuIntroduction, selectedMenuOptionCategories) {
            logger.d("_Page_4_MenuRegistration onEditFunction selectedMenuOptionCategories ${selectedMenuOptionCategories.toFormattedJson()} ");
            setState(() {
              this.imagePath = imagePath;
              this.menuBriefDescription = menuBriefDescription;
              this.menuIntroduction = menuIntroduction;
              this.selectedMenuOptionCategories = selectedMenuOptionCategories;
            });
          },
        ),
      ]),
    );
  }
}

class _Page_0_MenuName extends StatefulWidget {
  final String menuName;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(String) onEditFunction;

  const _Page_0_MenuName({required this.menuName, required this.onNext, required this.onPrev, required this.onEditFunction});

  @override
  State<_Page_0_MenuName> createState() => _Page_0_MenuNameState();
}

class _Page_0_MenuNameState extends State<_Page_0_MenuName> {
  late String menuName;
  late TextEditingController menuNameController;

  @override
  void initState() {
    super.initState();
    menuName = widget.menuName;
    menuNameController = TextEditingController(text: menuName);
  }

  @override
  void dispose() {
    menuNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 1, totalStep: 5, onTap: widget.onPrev),
          floatingActionButton: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
              child: SGActionButton(
                  disabled: menuName.isEmpty,
                  onPressed: () {
                    if (menuName.isNotEmpty) {
                      widget.onEditFunction(menuName);
                      FocusScope.of(context).unfocus();
                      widget.onNext();
                    }
                  },
                  label: "다음")),
          body: SGContainer(
              color: const Color(0xFFFAFAFA),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
              child: ListView(
                children: [
                  SGTypography.body("등록할 새 메뉴명을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p3),
                  SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: TextField(
                        controller: menuNameController,
                        onChanged: (value) {
                          setState(() {
                            menuName = value;
                          });
                        },
                        style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                          hintText: "Ex) 바베큐 샐러드",
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  )),
                ],
              ))),
    );
  }
}

class _Page_1_MenuCategory extends StatefulWidget {
  final List<MenuCategoryModel> storeMenuCategoryDTOList;
  final MenuCategoryModel selectedMenuCategory;
  final List<String> selectedUserMenuCategories;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(MenuCategoryModel) onEditMenuCategoryFunction;
  final Function(List<String>) onEditUserMenuCategoryFunction;

  _Page_1_MenuCategory({
    required this.storeMenuCategoryDTOList,
    required this.selectedMenuCategory,
    required this.selectedUserMenuCategories,
    required this.onNext,
    required this.onPrev,
    required this.onEditMenuCategoryFunction,
    required this.onEditUserMenuCategoryFunction,
  });

  @override
  State<_Page_1_MenuCategory> createState() => _Page_1_MenuCategoryState();
}

class _Page_1_MenuCategoryState extends State<_Page_1_MenuCategory> {
  late MenuCategoryModel selectedMenuCategory;
  late List<String> selectedUserMenuCategories;

  @override
  void initState() {
    super.initState();
    selectedMenuCategory = widget.selectedMenuCategory;
    selectedUserMenuCategories = widget.selectedUserMenuCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 2, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (selectedMenuCategory.storeMenuCategoryId != -1) {
                      widget.onNext();
                    }
                  },
                  child: SGContainer(
                      color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray2 : SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body(
                        "다음",
                        size: FontSize.large,
                        color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray5 : SGColors.white,
                        weight: FontWeight.w700,
                      ))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("어떤 카테고리에 추가할까요?", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                GestureDetector(
                  onTap: () {
                    showSGDialogWithCloseButton(
                        context: context,
                        childrenBuilder: (ctx) => [
                              __SelectMenuCategoryDialog(
                                  context: ctx,
                                  selectedMenuCategory: widget.selectedMenuCategory,
                                  onConfirm: (selectedMenuCategory) {
                                    widget.onEditMenuCategoryFunction(selectedMenuCategory);
                                    showSGDialogWithCloseButton(
                                        context: context,
                                        childrenBuilder: (ctx) => [
                                              __SelectUserMenuCategoryDialog(
                                                context: ctx,
                                                selectedUserMenuCategories: widget.selectedUserMenuCategories,
                                                onConfirm: (selectedUserMenuCategories) {
                                                  widget.onEditUserMenuCategoryFunction(selectedUserMenuCategories);
                                                  FocusScope.of(context).unfocus();
                                                  Navigator.of(ctx).pop();
                                                  widget.onNext();
                                                },
                                              )
                                            ]);
                                  }),
                            ]);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                          padding: EdgeInsets.all(SGSpacing.p4),
                          width: double.infinity,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [SGTypography.body("추가하실 카테고리를 선택해주세요.", size: FontSize.normal, color: SGColors.gray3), Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p5, height: SGSpacing.p5)]))),
                ),
              ],
            )));
  }
}

class __SelectMenuCategoryDialog extends ConsumerStatefulWidget {
  final BuildContext context;
  final MenuCategoryModel selectedMenuCategory;
  final ValueChanged<MenuCategoryModel> onConfirm;

  __SelectMenuCategoryDialog({required this.context, required this.selectedMenuCategory, required this.onConfirm});

  @override
  ConsumerState<__SelectMenuCategoryDialog> createState() => __SelectMenuCategoryDialogState();
}

class __SelectMenuCategoryDialogState extends ConsumerState<__SelectMenuCategoryDialog> {
  late MenuCategoryModel selectedMenuCategory;

  @override
  void initState() {
    super.initState();
    selectedMenuCategory = widget.selectedMenuCategory;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SGTypography.body(
                "추가하실 카테고리를 선택해 주세요.",
                size: FontSize.medium * (screenWidth / 375),
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: SGSpacing.p4 * (screenHeight / 812)),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.4,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...state.storeMenuCategoryDTOList.map(
                    (menuCategory) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMenuCategory = menuCategory;
                        });
                      },
                      child: __CategoryOptionRadioButton(
                        category: menuCategory.menuCategoryName,
                        isSelected: selectedMenuCategory.storeMenuCategoryId == menuCategory.storeMenuCategoryId,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p4 * (screenHeight / 812)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddMenuCategoryScreen(),
                  ),
                );
              },
              child: SGContainer(
                color: SGColors.white,
                padding: EdgeInsets.symmetric(
                  vertical: SGSpacing.p3 * (screenHeight / 812),
                ),
                borderRadius: BorderRadius.circular(SGSpacing.p2 * (screenWidth / 375)),
                borderColor: SGColors.primary,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/plus.png",
                        width: SGSpacing.p3 * (screenWidth / 375),
                        height: SGSpacing.p3 * (screenWidth / 375),
                      ),
                      SizedBox(width: SGSpacing.p2 * (screenWidth / 375)),
                      SGTypography.body(
                        "메뉴 카테고리 추가",
                        size: FontSize.small * (screenWidth / 375),
                        weight: FontWeight.w500,
                        color: SGColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SGSpacing.p4 * (screenHeight / 812)),
            GestureDetector(
              onTap: () {
                if (selectedMenuCategory.storeMenuCategoryId != -1) {
                  Navigator.of(context).pop();
                  widget.onConfirm(selectedMenuCategory);
                }
              },
              child: SGContainer(
                color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray2 : SGColors.primary,
                padding: EdgeInsets.symmetric(
                  vertical: SGSpacing.p4 * (screenHeight / 812),
                ),
                borderRadius: BorderRadius.circular(SGSpacing.p3 * (screenWidth / 375)),
                child: Center(
                  child: SGTypography.body(
                    "확인",
                    size: FontSize.normal * (screenWidth / 375),
                    color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray5 : SGColors.white,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class __SelectUserMenuCategoryDialog extends StatefulWidget {
  BuildContext context;
  final List<String> selectedUserMenuCategories;
  final ValueChanged<List<String>> onConfirm;

  __SelectUserMenuCategoryDialog({required this.context, required this.selectedUserMenuCategories, required this.onConfirm});

  @override
  State<__SelectUserMenuCategoryDialog> createState() => __SelectUserMenuCategoryDialogState();
}

class __SelectUserMenuCategoryDialogState extends State<__SelectUserMenuCategoryDialog> {
  late List<String> selectedUserMenuCategories;

  @override
  void initState() {
    super.initState();
    selectedUserMenuCategories = widget.selectedUserMenuCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: SGTypography.body("메뉴의 카테고리를 선택해 주세요.", size: FontSize.medium, weight: FontWeight.w700)),
        ],
      ),
      SizedBox(height: SGSpacing.p4),
      SGTypography.body("중복 선택 가능", size: FontSize.small, color: SGColors.gray3, weight: FontWeight.w700),
      SizedBox(height: SGSpacing.p4),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 2 / 5),
              child: ListView(shrinkWrap: true, children: [
                ...userMenuCategories.map((userMenuCategory) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedUserMenuCategories.contains(userMenuCategory)) {
                          selectedUserMenuCategories.remove(userMenuCategory);
                        } else {
                          selectedUserMenuCategories.add(userMenuCategory);
                        }
                      });
                    },
                    child: __CategoryOptionRadioButton(category: userMenuCategory, isSelected: selectedUserMenuCategories.contains(userMenuCategory)))),
              ])),
          SizedBox(height: SGSpacing.p2),
          GestureDetector(
            onTap: () {
              if (selectedUserMenuCategories.isNotEmpty) {
                widget.onConfirm(selectedUserMenuCategories);
              }
            },
            child: SGContainer(
              color: selectedUserMenuCategories.isEmpty ? SGColors.gray2 : SGColors.primary, // 비활성화 시 색상 변경
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                child: SGTypography.body(
                  "확인",
                  size: FontSize.normal,
                  color: selectedUserMenuCategories.isEmpty ? SGColors.gray5 : SGColors.white, // 비활성화 시 텍스트 색상 변경
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

class __CategoryOptionRadioButton extends StatelessWidget {
  final String category;
  final bool isSelected;

  __CategoryOptionRadioButton({super.key, required this.category, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SGContainer(
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4 + SGSpacing.p05),
                child: Row(
                  children: [
                    Image.asset("assets/images/radio-${isSelected ? "on" : "off"}.png", width: SGSpacing.p5, height: SGSpacing.p5),
                    SizedBox(width: SGSpacing.p1 + SGSpacing.p05),
                    SizedBox(
                        width: 175,
                        child: SGTypography.body(
                          category,
                          size: FontSize.normal,
                          color: isSelected ? SGColors.primary : SGColors.gray5,
                          weight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                )),
          ],
        ),
        Divider(thickness: 1, color: SGColors.line1, height: 1),
      ],
    );
  }
}

class _Page_2_MenuPrice extends StatefulWidget {
  final int price;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(int) onEditFunction;

  _Page_2_MenuPrice({required this.price, required this.onNext, required this.onPrev, required this.onEditFunction});

  @override
  State<_Page_2_MenuPrice> createState() => _Page_2_MenuPriceState();
}

class _Page_2_MenuPriceState extends State<_Page_2_MenuPrice> {
  late int price;

  @override
  void initState() {
    super.initState();
    price = widget.price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 3, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onEditFunction(price);
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (price > 0) {
                      widget.onEditFunction(price);
                      widget.onNext();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: SGContainer(
                      color: price == 0 ? SGColors.gray2 : SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body(
                        "다음",
                        size: FontSize.large,
                        color: price == 0 ? SGColors.gray5 : SGColors.white,
                        weight: FontWeight.w700,
                      ))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("가격을 설정해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: NumericTextField(
                          initialValue: widget.price,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                            hintText: price.toKoreanCurrency,
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onValueChanged: (price) {
                            setState(() {
                              this.price = price;
                            });
                          },
                        ),
                      ),
                      SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                    ],
                  ),
                )),
              ],
            )));
  }
}

class _Page_3_MenuNutrition extends StatefulWidget {
  final NutritionModel nutrition;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(NutritionModel) onEditFunction;

  const _Page_3_MenuNutrition({
    required this.nutrition,
    required this.onNext,
    required this.onPrev,
    required this.onEditFunction,
  });

  @override
  State<_Page_3_MenuNutrition> createState() => _Page_3_MenuNutritionState();
}

class _Page_3_MenuNutritionState extends State<_Page_3_MenuNutrition> {
  late NutritionModel nutrition;

  @override
  void initState() {
    super.initState();
    nutrition = widget.nutrition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 4, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onEditFunction(nutrition);
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onEditFunction(nutrition);
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("다음", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("메뉴의 영양성분을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                NutritionCard(
                    nutrition: nutrition,
                    type: 0,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdateNutritionScreen(
                                title: "영양성분 설정",
                                nutrition: nutrition,
                                onConfirm: (nutrition, context) {
                                  setState(() {
                                    this.nutrition = nutrition;
                                  });
                                  Navigator.of(context).pop();
                                },
                              )));
                    }),
              ],
            )));
  }
}

class _Page_4_MenuRegistration extends StatefulWidget {
  final String imagePath;
  final String menuBriefDescription;
  final String menuIntroduction;
  final List<MenuOptionCategoryModel> selectedMenuOptionCategories;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(String, String, String, List<MenuOptionCategoryModel>) onEditFunction;

  const _Page_4_MenuRegistration({required this.imagePath, required this.menuBriefDescription, required this.menuIntroduction, required this.selectedMenuOptionCategories, required this.onNext, required this.onPrev, required this.onEditFunction});

  @override
  State<_Page_4_MenuRegistration> createState() => _Page_4_MenuRegistrationState();
}

class _Page_4_MenuRegistrationState extends State<_Page_4_MenuRegistration> {
  late String imagePath;
  late String menuBriefDescription;
  late String menuIntroduction;
  late List<MenuOptionCategoryModel> selectedMenuOptionCategories;

  static const columns = 3;

  @override
  void initState() {
    super.initState();
    imagePath = widget.imagePath;
    menuBriefDescription = widget.menuBriefDescription;
    menuIntroduction = widget.menuIntroduction;
    selectedMenuOptionCategories = widget.selectedMenuOptionCategories;
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize = (MediaQuery.of(context).size.width - (SGSpacing.p3 * (columns - 1)) - (SGSpacing.p4 * 2)) / columns;

    return Scaffold(
      appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 5, totalStep: 5, onTap: widget.onPrev),

      // --------------------------- ActionButton ---------------------------
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (menuBriefDescription.isNotEmpty && menuIntroduction.isNotEmpty && imagePath.isNotEmpty && selectedMenuOptionCategories.isNotEmpty) {
                    widget.onNext();
                  }
                },
                child: SGContainer(
                    color: SGColors.gray3, padding: EdgeInsets.all(SGSpacing.p4), borderRadius: BorderRadius.circular(SGSpacing.p3), child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
              )),
              SizedBox(width: SGSpacing.p3),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (menuBriefDescription.isNotEmpty && menuIntroduction.isNotEmpty && imagePath.isNotEmpty && selectedMenuOptionCategories.isNotEmpty) {
                    widget.onNext();
                  }
                },
                child: SGContainer(
                    color: menuBriefDescription.isEmpty || menuIntroduction.isEmpty || imagePath.isEmpty || selectedMenuOptionCategories.isEmpty ? SGColors.gray2 : SGColors.primary,
                    padding: EdgeInsets.all(SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body(
                      "등록",
                      size: FontSize.large,
                      color: menuBriefDescription.isEmpty || menuIntroduction.isEmpty || imagePath.isEmpty || selectedMenuOptionCategories.isEmpty ? SGColors.gray5 : SGColors.white,
                      weight: FontWeight.w700,
                    ))),
              )),
            ],
          )),

      body: SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            // --------------------------- 메뉴 사진 ---------------------------
            SGTypography.body("새 메뉴 사진을 등록해주세요.", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: GestureDetector(
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
                                setState(() {
                                  imagePath = imagePaths[0];
                                });
                                widget.onEditFunction(imagePath, menuBriefDescription, menuIntroduction, selectedMenuOptionCategories);
                              },
                            ),
                          ),
                        );
                      },
                      child: imagePath.isEmpty
                          ? SGContainer(
                              borderColor: SGColors.line2,
                              color: SGColors.white,
                              borderRadius: BorderRadius.circular(SGSpacing.p2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.modulate),
                                    child: Image.asset(
                                      "assets/images/plus.png",
                                      width: SGSpacing.p6,
                                      height: SGSpacing.p6,
                                    ),
                                  ),
                                  SizedBox(height: SGSpacing.p2),
                                  SGTypography.body("이미지 등록", weight: FontWeight.w600, color: SGColors.gray5),
                                ],
                              ),
                            )
                          : SGContainer(
                              borderColor: SGColors.line2,
                              color: SGColors.white,
                              borderRadius: BorderRadius.circular(SGSpacing.p2),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                                      child: Image.file(
                                        File(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: SGSpacing.p2),
                                  SGTypography.body("이미지 등록", weight: FontWeight.w600, color: SGColors.gray5),
                                ],
                              ),
                            ),
                    ))),
            SizedBox(height: SGSpacing.p3),
            SGTypography.body("10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.", color: SGColors.gray4, weight: FontWeight.w500),
            SizedBox(height: SGSpacing.p8),

            // --------------------------- 메뉴 구성 ---------------------------
            SGTypography.body("메뉴 구성 및 설명을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextAreaScreen(
                            value: menuBriefDescription,
                            title: "메뉴 구성",
                            fieldLabel: "메뉴 구성을 입력해주세요.",
                            buttonText: "변경하기",
                            hintText: "메뉴 구성을 입력해주세요.",
                            onSubmit: (value) {
                              setState(() {
                                menuBriefDescription = value;
                              });
                              widget.onEditFunction(imagePath, menuBriefDescription, menuIntroduction, selectedMenuOptionCategories);
                              Navigator.pop(context);
                            },
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
              SGTypography.body(menuBriefDescription, size: FontSize.small, weight: FontWeight.w500),
            ]),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

            // --------------------------- 메뉴 설명 ---------------------------
            MultipleInformationBox(children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextAreaScreen(
                            value: menuIntroduction,
                            title: "메뉴 설명",
                            fieldLabel: "메뉴 설명을 입력해주세요.",
                            buttonText: "변경하기",
                            hintText: "메뉴 설명을 입력해주세요.",
                            onSubmit: (value) {
                              setState(() {
                                menuIntroduction = value;
                              });
                              widget.onEditFunction(imagePath, menuBriefDescription, menuIntroduction, selectedMenuOptionCategories);
                              Navigator.pop(context);
                            },
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
              SGTypography.body(menuIntroduction, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
            ]),
            SizedBox(height: SGSpacing.p8),

            // --------------------------- 메뉴 옵션 ---------------------------
            SGTypography.body("옵션을 선택해주세요.", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => _MenuOptionCategorySelectionScreen(
                        selectedMenuOptionCategories: widget.selectedMenuOptionCategories,
                        onConfirm: (selectedMenuOptionCategories) {
                          setState(() {
                            this.selectedMenuOptionCategories = selectedMenuOptionCategories;
                          });
                          widget.onEditFunction(
                            imagePath,
                            menuBriefDescription,
                            menuIntroduction,
                            selectedMenuOptionCategories,
                          );
                        },
                      ),
                    ));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SGTypography.body("옵션 설정", size: FontSize.normal, weight: FontWeight.w600),
                          SizedBox(width: SGSpacing.p1),
                          const Icon(Icons.edit, size: FontSize.small),
                        ],
                      ),
                      SizedBox(height: SGSpacing.p4),
                      if (selectedMenuOptionCategories.isEmpty)
                        SGTypography.body(
                          "등록된 내용이 없어요.",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w500,
                          lineHeight: 1.25,
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true, // 내용물 크기에 맞게 높이를 줄임
                          physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                          itemCount: selectedMenuOptionCategories.length,
                          itemBuilder: (context, index) {
                            final category = selectedMenuOptionCategories[index];
                            return Column(
                              children: [
                                SizedBox(height: SGSpacing.p3),
                                __MenuOptionCataegoryCard(
                                  category: category,
                                  onRemove: (_) {
                                    final updatedSelectedMenuOptionCategories = List<MenuOptionCategoryModel>.from(selectedMenuOptionCategories);
                                    updatedSelectedMenuOptionCategories.removeAt(index);
                                    setState(() {
                                      selectedMenuOptionCategories = updatedSelectedMenuOptionCategories;
                                    });
                                    widget.onEditFunction(
                                      imagePath,
                                      menuBriefDescription,
                                      menuIntroduction,
                                      updatedSelectedMenuOptionCategories,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
                SizedBox(height: SGSpacing.p3),
              ],
            ),
            SizedBox(height: SGSpacing.p32),
          ],
        ),
      ),
    );
  }
}

class _MenuOptionCategorySelectionScreen extends ConsumerStatefulWidget {
  final List<MenuOptionCategoryModel> selectedMenuOptionCategories;
  final ValueChanged<List<MenuOptionCategoryModel>> onConfirm;

  const _MenuOptionCategorySelectionScreen({required this.selectedMenuOptionCategories, required this.onConfirm});

  @override
  ConsumerState<_MenuOptionCategorySelectionScreen> createState() => _MenuOptionCategorySelectionScreenState();
}

class _MenuOptionCategorySelectionScreenState extends ConsumerState<_MenuOptionCategorySelectionScreen> {
  late List<MenuOptionCategoryModel> selectedMenuOptionCategories;

  @override
  void initState() {
    super.initState();
    selectedMenuOptionCategories = widget.selectedMenuOptionCategories;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);

    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "옵션 카테고리 선택"),
      floatingActionButton: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
        child: SGActionButton(
          onPressed: () {
            logger.d("onPressed 변경하기 ${selectedMenuOptionCategories.toFormattedJson()} ");
            widget.onConfirm(selectedMenuOptionCategories);
            Navigator.of(context).pop();
          },
          disabled: selectedMenuOptionCategories.isEmpty,
          label: "변경하기",
        ),
      ),
      body: SGContainer(
        color: const Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            Row(
              children: [
                SGTypography.body("옵션", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("${selectedMenuOptionCategories.length}", size: FontSize.small, color: SGColors.gray3),
              ],
            ),
            ...selectedMenuOptionCategories
                .mapIndexed((index, category) => [
              SizedBox(height: SGSpacing.p3),
              __MenuOptionCataegoryCard(
                category: category,
                onRemove: (target) {
                  final result = [...selectedMenuOptionCategories.sublist(0, index), ...selectedMenuOptionCategories.sublist(index + 1)];
                  setState(() {
                    selectedMenuOptionCategories = result;
                  });
                },
              )
            ])
                .flattened,
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                // BottomSheet 열기
                showMenuOptionCategorySelectionBottomSheet(
                  context: context,
                  title: "옵션 카테고리 추가",
                  onSelect: (selectedMenuOptionCategories) {
                    logger.d("onSelect selectedMenuOptionCategories ${selectedMenuOptionCategories.toFormattedJson()}");
                    setState(() {
                      this.selectedMenuOptionCategories = selectedMenuOptionCategories
                        ..sort((a, b) => a.menuOptionCategoryName.compareTo(b.menuOptionCategoryName));
                    });
                    widget.onConfirm(selectedMenuOptionCategories);
                  },
                  selectedMenuOptionCategories: selectedMenuOptionCategories,
                );
              },
              child: SGContainer(
                color: SGColors.white,
                borderColor: SGColors.primary,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/plus.png", width: 12, height: 12),
                      SizedBox(width: SGSpacing.p2),
                      SGTypography.body("옵션 카테고리 추가", size: FontSize.small, color: SGColors.primary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class __MenuOptionCataegoryCard extends StatelessWidget {
  final MenuOptionCategoryModel category;
  final Function(MenuOptionCategoryModel) onRemove;

  const __MenuOptionCataegoryCard({
    super.key,
    required this.category,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.asset("assets/images/accordion.png", width: SGSpacing.p4, height: SGSpacing.p4),
      SizedBox(width: SGSpacing.p2),
      Expanded(
        child: SGContainer(
            color: SGColors.white,
            padding: EdgeInsets.all(SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            boxShadow: SGBoxShadow.large,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SGTypography.body(category.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p1),
                    ...category.menuOptions
                        .map((option) => [
                              SizedBox(height: SGSpacing.p2),
                              SGTypography.body("${option.optionContent} : ${option.price!.toKoreanCurrency}원", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                            ])
                        .flattened
                  ],
                ),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      onRemove(category);
                    },
                    child: SGContainer(
                      borderWidth: 0,
                      width: SGSpacing.p5,
                      height: SGSpacing.p5,
                      borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                      color: SGColors.warningRed,
                      child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16)),
                    )),
              ],
            )),
      ),
    ]);
  }
}
