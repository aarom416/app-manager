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
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/image_upload_screen.dart';
import 'package:singleeat/core/screens/textarea_screen.dart';

import '../../../../../../core/components/numeric_textfield.dart';
import '../../../../../../main.dart';
import '../../cuisine_option_category_selection_bottom_sheet.dart';
import '../../model.dart';
import '../../nutrition_card.dart';
import '../../nutrition_form.dart';
import '../../provider.dart';
import '../addmenucategory/screen.dart';

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
  Nutrition nutrition = Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);
  int supply = 430;

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
          onNext: () => animateToPage(1),
          onPrev: () => Navigator.pop(context),
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
          onNext: () => animateToPage(2),
          onPrev: () => animateToPage(0),
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
          onNext: () => animateToPage(3),
          onPrev: () => animateToPage(1),
          onEditFunction: (price) {
            setState(() {
              this.price = price;
            });
          },
        ),
        _Page_3_MenuNutrition(
          nutrition: nutrition,
          supply: supply,
          onNext: () => animateToPage(4),
          onPrev: () => animateToPage(2),
          onEditFunction: (nutrition, supply) {
            setState(() {
              this.nutrition = nutrition;
              this.supply = supply;
            });
          },
        ),
        _Page_4_MenuRegistration(
          onNext: () => Navigator.of(context).pop(),
          onPrev: () => animateToPage(3),
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

  _Page_0_MenuName({required this.menuName, required this.onNext, required this.onPrev, required this.onEditFunction});

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
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 1, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                disabled: menuName.isEmpty,
                onPressed: () {
                  widget.onEditFunction(menuName);
                  FocusScope.of(context).unfocus();
                  widget.onNext();
                },
                label: "추가하기")),
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
            )));
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

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SGTypography.body("추가하실 카테고리를 선택해 주세요.", size: FontSize.medium, weight: FontWeight.w700),
        ],
      ),
      SizedBox(height: SGSpacing.p4),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 2 / 5),
              child: ListView(shrinkWrap: true, children: [
                ...state.storeMenuCategoryDTOList.map((menuCategory) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMenuCategory = menuCategory;
                      });
                    },
                    child: __CategoryOptionRadioButton(category: menuCategory.menuCategoryName, isSelected: selectedMenuCategory.storeMenuCategoryId == menuCategory.storeMenuCategoryId))),
              ])),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddMenuCategoryScreen()));
            },
            child: SGContainer(
                color: SGColors.white,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                borderColor: SGColors.primary,
                child: Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3),
                  SizedBox(width: SGSpacing.p2),
                  SGTypography.body("메뉴 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                ]))),
          ),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              if (selectedMenuCategory.storeMenuCategoryId != -1) {
                Navigator.of(context).pop();
                widget.onConfirm(selectedMenuCategory);
              }
            },
            child: SGContainer(
              color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray2 : SGColors.primary, // 비활성화 시 색상 변경
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                child: SGTypography.body(
                  "확인",
                  size: FontSize.normal,
                  color: selectedMenuCategory.storeMenuCategoryId == -1 ? SGColors.gray5 : SGColors.white, // 비활성화 시 텍스트 색상 변경
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

class __SelectUserMenuCategoryDialog extends StatefulWidget {
  BuildContext context;
  final List<String> selectedUserMenuCategories;
  final ValueChanged<List<String>> onConfirm;

  __SelectUserMenuCategoryDialog({required this.context, required this.selectedUserMenuCategories, required this.onConfirm});

  @override
  State<__SelectUserMenuCategoryDialog> createState() => __SelectUserMenuCategoryDialogState();
}

class __SelectUserMenuCategoryDialogState extends State<__SelectUserMenuCategoryDialog> {
  List<String> userMenuCategories = [
    "샐러드",
    "포케",
    "샌드위치",
    "카페",
    "베이커리",
    "버거",
  ];

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
          SGTypography.body("메뉴의 카테고리를 선택해 주세요.", size: FontSize.medium, weight: FontWeight.w700),
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
          SizedBox(height: SGSpacing.p4),
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
                    SGTypography.body(category, size: FontSize.normal, color: isSelected ? SGColors.primary : SGColors.gray5, weight: FontWeight.w500),
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
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    price = widget.price;
    priceController = TextEditingController(text: price.toKoreanCurrency);
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
            color: Color(0xFFFAFAFA),
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
  final Nutrition nutrition;
  final int supply;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(Nutrition, int) onEditFunction;

  const _Page_3_MenuNutrition({
    required this.nutrition,
    required this.supply,
    required this.onNext,
    required this.onPrev,
    required this.onEditFunction,
  });

  @override
  State<_Page_3_MenuNutrition> createState() => _Page_3_MenuNutritionState();
}

class _Page_3_MenuNutritionState extends State<_Page_3_MenuNutrition> {
  late Nutrition nutrition;
  late int supply;

  @override
  void initState() {
    super.initState();
    nutrition = widget.nutrition;
    supply = widget.supply;
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
                    widget.onEditFunction(nutrition, supply);
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
                    widget.onEditFunction(nutrition, supply);
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
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("메뉴의 영양성분을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                NutritionCard(
                    nutrition: nutrition,
                    isSolid: true,
                    supply: supply,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _NutritionInputScreen(
                                nutrition: nutrition,
                                supply: supply,
                                onConfirm: (nutrition, supply, context) {
                                  logger.i("onConfirm supply $supply");
                                  logger.i("onConfirm nutrition.calories ${nutrition.calories}");
                                  setState(() {
                                    this.nutrition = nutrition;
                                    this.supply = supply;
                                  });
                                  Navigator.of(context).pop();
                                },
                              )));
                    }),
              ],
            )));
  }
}

class _NutritionInputScreen extends StatefulWidget {
  Nutrition nutrition;
  int supply;
  Function(Nutrition, int, BuildContext) onConfirm;

  _NutritionInputScreen({required this.nutrition, required this.supply, required this.onConfirm});

  @override
  State<_NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<_NutritionInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 설정"),
      body: NutritionForm(nutrition: widget.nutrition, supply: widget.supply, onChanged: widget.onConfirm),
    );
  }
}

class _Page_4_MenuRegistration extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _Page_4_MenuRegistration({super.key, required this.onNext, required this.onPrev});

  @override
  State<_Page_4_MenuRegistration> createState() => _Page_4_MenuRegistrationState();
}

class _Page_4_MenuRegistrationState extends State<_Page_4_MenuRegistration> {
  String intro = "연어 500g + 곡물밥 300g";
  String description = "연어와 곡물 베이스 조화의 오븐에 바싹 구운 연어를 올린 단백질 듬뿍 샐러드";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 5, totalStep: 5, onTap: widget.onPrev),
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
                    // todo !!정의된 삭제된 메뉴 판단기준이 발견되지 않음.
                    // showFailDialogWithImage(
                    //   context: context,
                    //   mainTitle: "해당 메뉴는 삭제된 메뉴입니다.",
                    //   subTitle: "이미 동일한 메뉴가 등록되어있습니다.\n다시 한번 확인해주세요.",
                    // );
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("등록", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("새 메뉴 사진을 등록해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ImageUploadScreen(
                              title: "메뉴 이미지",
                              images: [],
                              maximumImages: 1,
                              fieldLabel: "메뉴 이미지",
                              buttonText: "변경하기",
                              onSubmit: (List<String> images) {
                                logger.i("images $images");
                              },
                            )));
                  },
                  child: Row(
                    children: [
                      SGContainer(
                          width: SGSpacing.p24,
                          height: SGSpacing.p24,
                          borderColor: SGColors.line2,
                          color: SGColors.white,
                          borderRadius: BorderRadius.circular(SGSpacing.p2),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            ColorFiltered(colorFilter: ColorFilter.mode(Colors.black, BlendMode.modulate), child: Image.asset("assets/images/plus.png", width: SGSpacing.p6, height: SGSpacing.p6)),
                            SizedBox(height: SGSpacing.p2),
                            SGTypography.body("이미지 등록", weight: FontWeight.w600, color: SGColors.gray5)
                          ])),

                      // SGContainer(
                      //   borderColor: SGColors.line2,
                      //   color: SGColors.white,
                      //   borderRadius: BorderRadius.circular(SGSpacing.p2),
                      //   child: Stack(
                      //     children: [
                      //       Positioned.fill(
                      //         child: Image.file(
                      //           File("/data/user/0/com.golgoru.singleat_owner/cache/3052a09c-c98e-4b3e-9ae9-44267f1860d6/1000000463.jpg"),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: SGSpacing.p3),
                SGTypography.body("10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.", color: SGColors.gray4, weight: FontWeight.w500),
                SizedBox(height: SGSpacing.p8),
                SGTypography.body("메뉴 구성 및 설명을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                MultipleInformationBox(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextAreaScreen(
                                value: intro,
                                title: "메뉴 구성",
                                fieldLabel: "메뉴 구성을 입력해주세요.",
                                buttonText: "변경하기",
                                hintText: "메뉴 구성을 입력해주세요.",
                                onSubmit: (value) {
                                  setState(() {
                                    intro = value;
                                  });
                                },
                              )));
                    },
                    child: Row(
                      children: [
                        SGTypography.body("메뉴 구성", size: FontSize.normal, weight: FontWeight.w600),
                        SizedBox(width: SGSpacing.p1),
                        Icon(Icons.edit, size: FontSize.small),
                      ],
                    ),
                  ),
                  SizedBox(height: SGSpacing.p5),
                  SGTypography.body(intro, size: FontSize.small, weight: FontWeight.w500),
                ]),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                MultipleInformationBox(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextAreaScreen(
                                value: description,
                                title: "메뉴 설명",
                                fieldLabel: "메뉴 설명을 입력해주세요.",
                                buttonText: "변경하기",
                                hintText: "메뉴 설명을 입력해주세요.",
                                onSubmit: (value) {
                                  setState(() {
                                    description = value;
                                  });
                                },
                              )));
                    },
                    child: Row(
                      children: [
                        SGTypography.body("메뉴 설명", size: FontSize.normal, weight: FontWeight.w600),
                        SizedBox(width: SGSpacing.p1),
                        Icon(Icons.edit, size: FontSize.small),
                      ],
                    ),
                  ),
                  SizedBox(height: SGSpacing.p5),
                  SGTypography.body(description, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
                ]),
                SizedBox(height: SGSpacing.p8),
                SGTypography.body("옵션을 선택해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                MultipleInformationBox(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => _SelectCuisionOptionCategoryScreen()));
                    },
                    child: Row(
                      children: [
                        SGTypography.body("옵션 설정", size: FontSize.normal, weight: FontWeight.w600),
                        SizedBox(width: SGSpacing.p1),
                        Icon(Icons.edit, size: FontSize.small),
                      ],
                    ),
                  ),
                  SizedBox(height: SGSpacing.p5),
                  SGTypography.body("등록된 내용이 없어요.", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
                ]),
                SizedBox(height: SGSpacing.p32),
              ],
            )));
  }
}

class _SelectCuisionOptionCategoryScreen extends StatefulWidget {
  const _SelectCuisionOptionCategoryScreen({super.key});

  @override
  State<_SelectCuisionOptionCategoryScreen> createState() => _SelectCuisionOptionCategoryScreenState();
}

List<MenuOptionCategoryModel> categories = [
  MenuOptionCategoryModel(menuOptionCategoryId: 1, menuOptionCategoryName: "토핑 선택", menuOptions: [MenuOptionModel(optionContent: "연어 토핑", price: 3000), MenuOptionModel(optionContent: "훈제 오리 토핑", price: 3000)]),
  MenuOptionCategoryModel(
    menuOptionCategoryId: 2,
    menuOptionCategoryName: "추가 선택",
    menuOptions: [MenuOptionModel(optionContent: "참치 토핑", price: 3000), MenuOptionModel(optionContent: "불고기 토핑", price: 3000)],
  ),
  MenuOptionCategoryModel(
    menuOptionCategoryId: 3,
    menuOptionCategoryName: "곡물 베이스 선택",
    menuOptions: [MenuOptionModel(optionContent: "곡물 베이스", price: 3000), MenuOptionModel(optionContent: "야채만", price: 3000)],
  ),
];

class _SelectCuisionOptionCategoryScreenState extends State<_SelectCuisionOptionCategoryScreen> {
  List<MenuOptionCategoryModel> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "옵션 카테고리 선택"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                disabled: selectedCategories.isEmpty,
                label: "변경하기")),
        body: SGContainer(
            color: Color(0xFFFFFFFF),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              Row(
                children: [
                  SGTypography.body("옵션", size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(width: SGSpacing.p1),
                  SGTypography.body("${selectedCategories.length}", size: FontSize.small, color: SGColors.gray3),
                ],
              ),
              ...selectedCategories
                  .mapIndexed((index, category) => [
                        SizedBox(height: SGSpacing.p3),
                        __MenuOptionCataegoryCard(
                          category: category,
                          onRemove: (target) {
                            final result = [...selectedCategories.sublist(0, index), ...selectedCategories.sublist(index + 1)];
                            setState(() {
                              selectedCategories = result;
                            });
                          },
                        )
                      ])
                  .flattened,
              SizedBox(height: SGSpacing.p3),
              GestureDetector(
                onTap: () {
                  showCuisineOptionCategorySelectionBottomSheet(
                      context: context,
                      title: "옵션 카테고리 추가",
                      cuisineOptionCategories: categories,
                      onSelect: (result) {
                        //   final sortedCategories = result..sort((a, b) => a.menuOptionCategoryId!.compareTo(b.menuOptionCategoryId!));
                        setState(() {
                          //    selectedCategories = sortedCategories;
                        });
                      },
                      selectedCuisineOptionCatagories: selectedCategories);
                },
                child: SGContainer(
                    color: SGColors.white,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p2),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Center(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Image.asset("assets/images/plus.png", width: 12, height: 12),
                      SizedBox(width: SGSpacing.p2),
                      SGTypography.body("옵션 카테고리 추가", size: FontSize.small, color: SGColors.primary),
                    ]))),
              ),
            ])));
  }
}

class __MenuOptionCataegoryCard extends StatelessWidget {
  final MenuOptionCategoryModel category;
  final Function(MenuOptionCategoryModel) onRemove;

  __MenuOptionCataegoryCard({
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
                Spacer(),
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
