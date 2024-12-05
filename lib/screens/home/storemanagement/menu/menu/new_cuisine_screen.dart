import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:singleeat/core/utils/formatter.dart';
import 'package:singleeat/office/components/cuisine_option_category_selection_bottom_sheet.dart';
import 'package:singleeat/office/components/nutrition_card.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/new_cuisine_category_screen.dart';
import 'package:singleeat/screens/nutrition_form.dart';

class NewCuisineScreen extends StatefulWidget {
  const NewCuisineScreen({super.key});

  @override
  State<NewCuisineScreen> createState() => _NewCuisineScreenState();
}

class _NewCuisineScreenState extends State<NewCuisineScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: pageController, physics: NeverScrollableScrollPhysics(), children: [
        _NewCuisineNameStepScreen(
          onNext: () => animateToPage(1),
          onPrev: () => Navigator.pop(context),
        ),
        _NewCuisineCategoryStepScreen(
          onNext: () => animateToPage(2),
          onPrev: () => animateToPage(0),
        ),
        _NewCuisinePriceStepScreen(
          onNext: () => animateToPage(3),
          onPrev: () => animateToPage(1),
        ),
        _NewCuisineNutritionStepScreen(
          onNext: () => animateToPage(4),
          onPrev: () => animateToPage(2),
        ),
        _NewCuisineRegistrationStepScreen(
          onNext: () => Navigator.of(context).pop(),
          onPrev: () => animateToPage(3),
        ),
      ]),
    );
  }
}

class _NewCuisineNameStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  _NewCuisineNameStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisineNameStepScreen> createState() => _NewCuisineNameStepScreenState();
}

class _NewCuisineNameStepScreenState extends State<_NewCuisineNameStepScreen> {
  String menuName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "새 메뉴 추가", currentStep: 1, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                disabled: menuName.isEmpty,
                onPressed: () {
                  widget.onNext();
                  FocusScope.of(context).unfocus();
                },
                label: "추가하기")),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
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
                      onChanged: (value) {
                        setState(() {
                          menuName = value;
                        });
                      },
                      style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintStyle:
                            TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                        hintText: "Ex) 바베큐 샐러드",
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                )),
              ],
            )));
  }
}

class _NewCuisineCategoryStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  _NewCuisineCategoryStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisineCategoryStepScreen> createState() => _NewCuisineCategoryStepScreenState();
}

class _NewCuisineCategoryStepScreenState extends State<_NewCuisineCategoryStepScreen> {
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
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    // widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("다음",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
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
                              __CategorySelectionDialogBody(
                                  dialogContext: ctx,
                                  onConfirm: () {
                                    showSGDialogWithCloseButton(
                                        context: context,
                                        childrenBuilder: (ctx) => [
                                              __CategoryMultipleSelectionDialogBody(
                                                dialogContext: ctx,
                                                onConfirm: () {
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
                              children: [
                                SGTypography.body("추가하실 카테고리를 선택해주세요.", size: FontSize.normal, color: SGColors.gray3),
                                Image.asset("assets/images/dropdown-arrow.png",
                                    width: SGSpacing.p5, height: SGSpacing.p5)
                              ]))),
                ),
              ],
            )));
  }
}

class __CategorySelectionDialogBody extends StatefulWidget {
  BuildContext dialogContext;
  VoidCallback onConfirm;

  __CategorySelectionDialogBody({super.key, required this.dialogContext, required this.onConfirm});

  @override
  State<__CategorySelectionDialogBody> createState() => __CategorySelectionDialogBodyState();
}

class __CategorySelectionDialogBodyState extends State<__CategorySelectionDialogBody> {
  List<String> categoryOptions = [
    "혼밥 샐러드",
    "2인 포케 세트",
    "3인 포케 세트",
    "사이드 메뉴",
    "음료",
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
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
                ...categoryOptions.map((option) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategories = [option];
                      });
                    },
                    child: __CategoryOptionRadioButton(
                        category: option, isSelected: selectedCategories.contains(option)))),
              ])),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCuisineCategoryScreen()));
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
                  SGTypography.body("메뉴 카테고리 추가",
                      size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                ]))),
          ),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              widget.onConfirm();
            },
            child: SGContainer(
                color: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                  child: SGTypography.body("확인", size: FontSize.normal, color: SGColors.white, weight: FontWeight.w700),
                )),
          ),
        ],
      ),
    ]);
  }
}

class __CategoryMultipleSelectionDialogBody extends StatefulWidget {
  BuildContext dialogContext;
  VoidCallback onConfirm;

  __CategoryMultipleSelectionDialogBody({super.key, required this.dialogContext, required this.onConfirm});

  @override
  State<__CategoryMultipleSelectionDialogBody> createState() => __CategoryMultipleSelectionDialogBodyState();
}

class __CategoryMultipleSelectionDialogBodyState extends State<__CategoryMultipleSelectionDialogBody> {
  List<String> categoryOptions = [
    "샐러드",
    "포케",
    "샌드위치",
    "카페",
    "베이커리",
    "버거",
  ];

  List<String> selectedCategories = [];
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
                ...categoryOptions.map((option) => GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategories.contains(option)) {
                          selectedCategories.remove(option);
                        } else {
                          selectedCategories.add(option);
                        }
                      });
                    },
                    child: __CategoryOptionRadioButton(
                        category: option, isSelected: selectedCategories.contains(option)))),
              ])),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              widget.onConfirm();
            },
            child: SGContainer(
                color: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                  child: SGTypography.body("확인", size: FontSize.normal, color: SGColors.white, weight: FontWeight.w700),
                )),
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
                    Image.asset("assets/images/radio-${isSelected ? "on" : "off"}.png",
                        width: SGSpacing.p5, height: SGSpacing.p5),
                    SizedBox(width: SGSpacing.p1 + SGSpacing.p05),
                    SGTypography.body(category,
                        size: FontSize.normal,
                        color: isSelected ? SGColors.primary : SGColors.gray5,
                        weight: FontWeight.w500),
                  ],
                )),
          ],
        ),
        Divider(thickness: 1, color: SGColors.line1, height: 1),
      ],
    );
  }
}

class _NewCuisinePriceStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  _NewCuisinePriceStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisinePriceStepScreen> createState() => _NewCuisinePriceStepScreenState();
}

class _NewCuisinePriceStepScreenState extends State<_NewCuisinePriceStepScreen> {
  String menuPrice = "";

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
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onNext();
                    FocusScope.of(context).unfocus();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("다음",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
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
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                menuPrice = value;
                              });
                            },
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              comparableNumericInputFormatter(1000000000)
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "0",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                      SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                    ],
                  ),
                )),
              ],
            )));
  }
}

class _NewCuisineNutritionStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _NewCuisineNutritionStepScreen({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<_NewCuisineNutritionStepScreen> createState() => _NewCuisineNutritionStepScreenState();
}

class _NewCuisineNutritionStepScreenState extends State<_NewCuisineNutritionStepScreen> {
  Nutrition nutrition =
      Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

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
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("다음",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
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
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _NutritionInputScreen(
                                nutrition: nutrition,
                                onConfirm: (nutrition, context) {
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
  Function(Nutrition, BuildContext) onConfirm;

  _NutritionInputScreen({super.key, required this.nutrition, required this.onConfirm});

  @override
  State<_NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<_NutritionInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 설정"),
      body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}

class _NewCuisineRegistrationStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _NewCuisineRegistrationStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisineRegistrationStepScreen> createState() => _NewCuisineRegistrationStepScreenState();
}

class _NewCuisineRegistrationStepScreenState extends State<_NewCuisineRegistrationStepScreen> {
  String intro = "연어 500g + 곡물밥 300g";
  String description = "연어와 곡물 베이스 조화의 오븐에 바싹 구운 연어를 올린 단백질 듬뿍 샐러드";

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
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                        child: GestureDetector(
                      onTap: () {
                        widget.onNext();
                        showFailDialogWithImage(mainTitle: "메뉴 추가 실패", subTitle: "이미 동일한 메뉴가 등록되어있습니다.\n다시 한번 확인해주세요.");
                      },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("등록",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
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
                              onSubmit: (value) {},
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
                            ColorFiltered(
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.modulate),
                                child:
                                    Image.asset("assets/images/plus.png", width: SGSpacing.p6, height: SGSpacing.p6)),
                            SizedBox(height: SGSpacing.p2),
                            SGTypography.body("이미지 등록", weight: FontWeight.w600, color: SGColors.gray5)
                          ])),
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
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => _SelectCuisionOptionCategoryScreen()));
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
                  SGTypography.body("등록된 내용이 없어요.",
                      color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.25),
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

List<CuisineOptionCategory> categories = [
  CuisineOptionCategory(
      id: 1,
      name: "토핑 선택",
      options: [CuisineOption(name: "연어 토핑", price: 3000), CuisineOption(name: "훈제 오리 토핑", price: 3000)]),
  CuisineOptionCategory(
    id: 2,
    name: "추가 선택",
    options: [CuisineOption(name: "참치 토핑", price: 3000), CuisineOption(name: "불고기 토핑", price: 3000)],
  ),
  CuisineOptionCategory(
    id: 3,
    name: "곡물 베이스 선택",
    options: [CuisineOption(name: "곡물 베이스", price: 3000), CuisineOption(name: "야채만", price: 3000)],
  ),
];

class _SelectCuisionOptionCategoryScreenState extends State<_SelectCuisionOptionCategoryScreen> {
  List<CuisineOptionCategory> selectedCategories = [];

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
                        __CuisineOptionCataegoryCard(
                          category: category,
                          onRemove: (target) {
                            final result = [
                              ...selectedCategories.sublist(0, index),
                              ...selectedCategories.sublist(index + 1)
                            ];
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
                        final sortedCategories = result..sort((a, b) => a.id!.compareTo(b.id!));
                        setState(() {
                          selectedCategories = sortedCategories;
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

class __CuisineOptionCataegoryCard extends StatelessWidget {
  final CuisineOptionCategory category;
  final Function(CuisineOptionCategory) onRemove;

  __CuisineOptionCataegoryCard({
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
                    SGTypography.body(category.name, size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p1),
                    ...category.options
                        .map((option) => [
                              SizedBox(height: SGSpacing.p2),
                              SGTypography.body("${option.name} : ${option.price!.toKoreanCurrency}원",
                                  size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
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
