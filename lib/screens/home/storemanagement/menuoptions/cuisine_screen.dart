import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/core/screens/textarea_edit_screen.dart';

import 'cuisine_option_category_card.dart';
import 'model.dart';
import 'nutrition_card.dart';
import 'nutrition_form.dart';

class CuisineScreen extends StatefulWidget {
  const CuisineScreen({super.key});

  @override
  State<CuisineScreen> createState() => _CuisineScreenState();
}

List<MenuOptionCategoryModel> categoryOptions = [
  MenuOptionCategoryModel(
      menuOptionCategoryName: "곡물 베이스 선택",
      menuOptions: [
        MenuOptionModel(optionContent: "곡물 베이스 선택", price: 0),
        MenuOptionModel(optionContent: "오곡 베이스", price: 0),
      ],
      essentialStatus: 1),
  MenuOptionCategoryModel(menuOptionCategoryName: "토핑 선택", menuOptions: [
    MenuOptionModel(optionContent: "훈제오리 토핑", price: 0),
    MenuOptionModel(optionContent: "연어 토핑", price: 500),
    MenuOptionModel(optionContent: "우삼겹 토핑", price: 3000),
  ]),
];

class _CuisineScreenState extends State<CuisineScreen> {
  String menuName = "김치찌개";
  String menuPrice = "16,000원";

  String intro = "연어 500g + 곡물밥 300g";
  String description = "연어와 곡물 베이스 조화의 오븐에 바싹 구운 연어를 올린 단백질 듬뿍 샐러드";

  bool soldOut = false;
  bool featured = false;
  bool recommended = false;

  Nutrition nutrition = Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, sugar: 12, sodium: 120, saturatedFat: 8);

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              if (subTitle.isEmpty) ...[
                Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                SizedBox(height: SGSpacing.p6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SGContainer(
                    color: SGColors.primary,
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                  ),
                )
              ] else ...[
                Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                SizedBox(height: SGSpacing.p4),
                Center(child: SGTypography.body(subTitle, color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
                    child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                  ),
                )
              ]
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "메뉴 관리"),
        body: SGContainer(
          borderWidth: 0,
          color: Color(0xFFFAFAFA),
          child: ListView(children: [
            SGContainer(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                child: Column(children: [
                  Row(children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          child: Image.network("https://via.placeholder.com/150", width: SGSpacing.p20, height: SGSpacing.p20, fit: BoxFit.cover),
                        ),
                        SGContainer(
                          padding: EdgeInsets.all(SGSpacing.p1),
                          child: CircleAvatar(
                            radius: SGSpacing.p4,
                            backgroundColor: SGColors.line2,
                            child: Icon(Icons.edit, size: FontSize.small),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: SGSpacing.p3),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SGTypography.body(menuName, size: FontSize.medium, weight: FontWeight.w700),
                        SizedBox(height: SGSpacing.p2),
                        SGTypography.body(menuPrice, size: FontSize.small, color: SGColors.gray4, weight: FontWeight.w400),
                      ],
                    )
                  ]),
                  SizedBox(height: SGSpacing.p3),
                  Row(children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextFieldEditScreen(
                                  value: menuName,
                                  title: "메뉴명 변경",
                                  buttonText: "변경하기",
                                  hintText: "메뉴명을 입력해주세요.",
                                  onSubmit: (value) {
                                    setState(() {
                                      menuName = value;
                                    });
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
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextFieldEditScreen(
                                  value: menuPrice,
                                  title: "가격 변경",
                                  buttonText: "변경하기",
                                  hintText: "가격을 입력해주세요.",
                                  onSubmit: (value) {
                                    setState(() {
                                      menuPrice = value;
                                    });
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
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("품절", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      Spacer(),
                      SGSwitch(
                          value: soldOut,
                          onChanged: (value) {
                            setState(() {
                              soldOut = value;
                            });
                          }),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p3),
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("인기 메뉴 등록", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      Spacer(),
                      SGSwitch(
                          value: featured,
                          onChanged: (value) {
                            setState(() {
                              featured = value;
                            });
                          }),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p3),
                  SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("베스트 메뉴", size: FontSize.normal, weight: FontWeight.w500, color: SGColors.black),
                      Spacer(),
                      SGSwitch(
                          value: recommended,
                          onChanged: (value) {
                            setState(() {
                              recommended = value;
                            });
                          }),
                    ]),
                  ),
                ])),
            SGContainer(
                color: Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: SGSpacing.p5),
                child: Column(children: [
                  MultipleInformationBox(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextareaEditScreen(
                                  value: intro,
                                  title: "메뉴 구성",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 구성을 입력해주세요.",
                                  onSubmit: (value) {
                                    setState(() {
                                      intro = value;
                                    });
                                  },
                                  maxLength: 100,
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
                            builder: (context) => TextareaEditScreen(
                                  value: description,
                                  title: "메뉴 설명",
                                  buttonText: "변경하기",
                                  hintText: "메뉴 설명을 입력해주세요.",
                                  onSubmit: (value) {
                                    setState(() {
                                      description = value;
                                    });
                                  },
                                  maxLength: 100,
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
                  ...categoryOptions
                      .mapIndexed((idx, category) => [
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                            CuisineOptionCategoryCard(category: category),
                          ])
                      .flattened
                ])),
            SGContainer(height: SGSpacing.p2, color: SGColors.gray1),
            SGContainer(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: SGSpacing.p5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGTypography.body("총 영양성분", size: FontSize.large, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  NutritionCard(
                    nutrition: nutrition,
                    onTap: () {
                      final screenContext = context;
                      Navigator.of(screenContext).push(MaterialPageRoute(
                          builder: (nutritionScreenContext) => _NutritionEditScreen(
                                nutrition: nutrition,
                                onConfirm: (value, quantity, ctx) {
                                  showSGDialog(
                                      context: ctx,
                                      childrenBuilder: (_ctx) => [
                                            Center(child: SGTypography.body("영양성분을\n정말 수정하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                                            SizedBox(height: SGSpacing.p5),
                                            Row(children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(_ctx).pop();
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
                                                    Navigator.of(ctx).pop();
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
            SGContainer(
                color: Color(0xFFFAFAFA),
                padding: EdgeInsets.all(SGSpacing.p4).copyWith(top: SGSpacing.p5),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGActionButton(
                    onPressed: () {
                      showSGDialog(
                          context: context,
                          childrenBuilder: (ctx) => [
                                // 로그아웃 하시겠습니까.
                                Center(child: SGTypography.body("메뉴를\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                                SizedBox(height: SGSpacing.p5),
                                Row(children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showFailDialogWithImage(mainTitle: "진행 중인 주문에 선택된 메뉴입니다.\n주문 완료 후 삭제 가능합니다.", subTitle: "");
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

class _NutritionEditScreen extends StatefulWidget {
  Nutrition nutrition;
  Function(Nutrition, int, BuildContext) onConfirm;

  _NutritionEditScreen({super.key, required this.nutrition, required this.onConfirm});

  @override
  State<_NutritionEditScreen> createState() => _NutritionEditScreenState();
}

class _NutritionEditScreenState extends State<_NutritionEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 수정"),
      // body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}
