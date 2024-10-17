import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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
import 'package:singleeat/office/components/nutrition_card.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/nutrition_form.dart';

class CuisineOptionCategoryScreen extends StatefulWidget {
  const CuisineOptionCategoryScreen({super.key});

  @override
  State<CuisineOptionCategoryScreen> createState() => _CuisineOptionCategoryScreenState();
}

final CuisineOptionCategory category = CuisineOptionCategory(
  name: "곡물 베이스 선택",
  isEssential: true,
  maximumSelection: 1,
  options: [
    CuisineOption(name: "채소 베이스", price: 0),
    CuisineOption(name: "오곡 베이스", price: 0),
  ],
);

final List<Cuisine> cuisines = [
  Cuisine(
    name: "참치 샐러드",
    price: 13000,
    description: "곡물 베이스는 기본입니다.",
    image: "https://via.placeholder.com/150",
    optionCategories: [
      CuisineOptionCategory(name: "추가 옵션", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
      CuisineOptionCategory(name: "소스", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
    ],
  ),
  Cuisine(
    name: "연어 샐러드",
    price: 13000,
    description: "곡물 베이스는 기본입니다.",
    image: "https://via.placeholder.com/150",
    optionCategories: [
      CuisineOptionCategory(name: "추가 옵션", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
      CuisineOptionCategory(name: "소스", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
    ],
  ),
  Cuisine(
    name: "닭가슴살 샐러드",
    price: 13000,
    description: "곡물 베이스는 기본입니다.",
    image: "https://via.placeholder.com/150",
    optionCategories: [
      CuisineOptionCategory(name: "추가 옵션", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
      CuisineOptionCategory(name: "소스", options: [
        CuisineOption(),
        CuisineOption(),
        CuisineOption(),
      ]),
    ],
  )
];

class _CuisineOptionCategoryScreenState extends State<CuisineOptionCategoryScreen> {
  bool isEssential = true;
  bool isSoldOut = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "옵션 카테고리 관리"),
      body: SGContainer(
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          SGTypography.body("곡물 베이스 선택", weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p3),
          MultipleInformationBox(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SGTypography.body("옵션 필수 여부", size: FontSize.normal, weight: FontWeight.w600),
              Spacer(),
              SGSwitch(
                value: isEssential,
                onChanged: (value) {
                  setState(() {
                    isEssential = value;
                  });
                },
              ),
            ]),
            SizedBox(height: SGSpacing.p3 + SGSpacing.p05),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CuisionOptionCategoryQuantityEditScreen(isEssential: isEssential)));
              },
              child: SGContainer(
                borderColor: SGColors.line2,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                child: Row(children: [
                  SGTypography.body("옵션 선택 개수 설정", size: FontSize.small),
                  SizedBox(width: SGSpacing.p1),
                  Icon(Icons.edit, size: FontSize.small),
                  Spacer(),
                  SGTypography.body("최소 1개, 최대 1개", size: FontSize.small)
                ]),
              ),
            ),
          ]),
          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
          SGContainer(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
              borderColor: SGColors.line2,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("품절", size: FontSize.normal),
                Spacer(),
                SGSwitch(
                  value: isSoldOut,
                  onChanged: (value) {
                    setState(() {
                      isSoldOut = value;
                    });
                  },
                ),
              ])),
          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
          _CuisineOptionCategoryCard(category: category),
          SizedBox(height: SGSpacing.p7 + SGSpacing.p05),
          MultipleInformationBox(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => _EditRelatedCuisineScreen(cuisines: cuisines)));
              },
              child: Row(
                children: [
                  SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p2),
                  Icon(Icons.edit, size: FontSize.small),
                ],
              ),
            ),
            ...cuisines
                .mapIndexed((index, cuisine) => [
                      if (index == 0)
                        SizedBox(height: SGSpacing.p4)
                      else ...[
                        SizedBox(height: SGSpacing.p4),
                        Divider(thickness: 1, height: 1, color: SGColors.line1),
                        SizedBox(height: SGSpacing.p4),
                      ],
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          child: Image.network(
                            cuisine.image,
                            width: SGSpacing.p18,
                            height: SGSpacing.p18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: SGSpacing.p4),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SGTypography.body(cuisine.name, size: FontSize.normal, weight: FontWeight.w700),
                          SizedBox(height: SGSpacing.p2),
                          SGTypography.body("${cuisine.price.toKoreanCurrency}원",
                              size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                        ])
                      ])
                    ])
                .flattened
          ]),
          SizedBox(height: SGSpacing.p4),
          GestureDetector(
            onTap: () {
              showSGDialog(
                  context: context,
                  childrenBuilder: (ctx) => [
                        Center(
                            child: SGTypography.body("옵션 카테고리를\n정말 삭제하시겠습니까?",
                                size: FontSize.large,
                                weight: FontWeight.w700,
                                lineHeight: 1.25,
                                align: TextAlign.center)),
                        SizedBox(height: SGSpacing.p5 / 2),
                        SGTypography.body("옵션 카테고리 내 옵션도 전부 삭제됩니다.", color: SGColors.gray4),
                        SizedBox(height: SGSpacing.p5),
                        Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(ctx).pop();
                                Navigator.of(context).pop();
                              },
                              child: SGContainer(
                                color: SGColors.gray3,
                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                child: Center(
                                  child: SGTypography.body("확인",
                                      size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
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
                                  child: SGTypography.body("취소",
                                      size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ]);
            },
            child: SGContainer(
                color: SGColors.warningRed.withOpacity(0.08),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                child: Center(
                  child: SGTypography.body("옵션 카테고리 삭제",
                      color: SGColors.warningRed, weight: FontWeight.w600, size: FontSize.small),
                )),
          ),
          SizedBox(height: SGSpacing.p32),
        ]),
      ),
    );
  }
}

class _EditRelatedCuisineScreen extends StatelessWidget {
  final List<Cuisine> cuisines;
  const _EditRelatedCuisineScreen({
    super.key,
    required this.cuisines,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "옵션 카테고리 사용 메뉴"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  // widget.onSubmit(controller.text);
                  Navigator.of(context).pop();
                },
                label: "변경하기")),
        body: SGContainer(
            borderWidth: 0,
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("고객은 해당 메뉴 주문 시 다음 옵션 카테고리를\n선택할 수 있습니다.", color: SGColors.gray4),
              SizedBox(height: SGSpacing.p3),
              ...cuisines
                  .mapIndexed((index, cuisine) => [
                        _SelectedCuisineCard(cuisine: cuisine, onRemove: () {}),
                        SizedBox(height: SGSpacing.p5 / 2),
                      ])
                  .flattened,
              GestureDetector(
                  onTap: () {},
                  child: SGContainer(
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      borderColor: SGColors.primary,
                      child: Center(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3),
                        SizedBox(width: SGSpacing.p2),
                        SGTypography.body("메뉴 추가하기",
                            size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                      ])))),
            ])));
  }
}

class _SelectedCuisineCard extends StatelessWidget {
  final Cuisine cuisine;
  final VoidCallback onRemove;

  const _SelectedCuisineCard({Key? key, required this.cuisine, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.white,
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      boxShadow: SGBoxShadow.large,
      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4, horizontal: SGSpacing.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(SGSpacing.p4),
                  child: Image.network(cuisine.image, width: SGSpacing.p18, height: SGSpacing.p18)),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(cuisine.name,
                      color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("${cuisine.price.toKoreanCurrency}원",
                      color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
                ],
              ),
            ],
          ),
          GestureDetector(
              onTap: onRemove,
              child: SGContainer(
                borderWidth: 0,
                width: SGSpacing.p5,
                height: SGSpacing.p5,
                borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                color: SGColors.warningRed,
                child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16)),
              )),
        ],
      ),
    );
  }
}

class CuisionOptionCategoryQuantityEditScreen extends StatefulWidget {
  bool isEssential;
  CuisionOptionCategoryQuantityEditScreen({
    super.key,
    this.isEssential = false,
  });

  @override
  State<CuisionOptionCategoryQuantityEditScreen> createState() => _CuisionOptionCategoryQuantityEditScreenState();
}

class _CuisionOptionCategoryQuantityEditScreenState extends State<CuisionOptionCategoryQuantityEditScreen> {
  TextEditingController minValueController = TextEditingController(text: "1");
  TextEditingController maxValueController = TextEditingController(text: "1");

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "옵션 선택 개수 설정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: "변경하기")),
      body: SGContainer(
        borderWidth: 0,
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          SGTypography.body("옵션 선택 개수를 설정해주세요.", weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p4),
          if (widget.isEssential) ...[
            SGTypography.body("최소", size: FontSize.small, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: minValueController,
                        style: baseStyle.copyWith(color: SGColors.black),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          isCollapsed: true,
                          hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  ),
                  SGTypography.body("개", size: FontSize.small, color: SGColors.gray4),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p3),
          ],
          SGTypography.body("최대", size: FontSize.small, color: SGColors.gray4),
          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
          SGContainer(
            color: Colors.white,
            borderColor: SGColors.line3,
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: maxValueController,
                      style: baseStyle.copyWith(color: SGColors.black),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(SGSpacing.p4),
                        isCollapsed: true,
                        hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                ),
                SGTypography.body("개", size: FontSize.small, color: SGColors.gray4),
                SizedBox(width: SGSpacing.p4),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _CuisineOptionCategoryCard extends StatelessWidget {
  final CuisineOptionCategory category;

  const _CuisineOptionCategoryCard({super.key, required this.category});

  String get selectionType {
    if (category.isEssential) return "(필수)";
    return "(선택 최대 ${category.maximumSelection ?? 0}개)";
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CuisineOptionCategoryEditScreen(category: category)));
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SGTypography.body(category.name, size: FontSize.normal, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          Icon(Icons.edit, size: FontSize.small),
        ]),
      ),
      ...category.options
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.name ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened
    ]);
  }
}

class CuisineOptionCategoryEditScreen extends StatefulWidget {
  final CuisineOptionCategory category;
  CuisineOptionCategoryEditScreen({super.key, required this.category});

  @override
  State<CuisineOptionCategoryEditScreen> createState() => _CuisineOptionCategoryEditScreenState();
}

class _CuisineOptionCategoryEditScreenState extends State<CuisineOptionCategoryEditScreen> {
  bool isSoldOut = false;

  Nutrition nutrition =
      Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

  late String categoryName = widget.category.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "옵션 관리"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              MultipleInformationBox(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TextFieldEditScreen(
                              value: categoryName,
                              title: "옵션 카테고리 변경",
                              onSubmit: (value) {
                                setState(() {
                                  categoryName = value;
                                });
                              },
                              buttonText: "저장하기",
                              hintText: "옵션 카테고리 이름을 입력해주세요",
                            )));
                  },
                  child: Row(children: [
                    SGTypography.body(categoryName, size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(width: SGSpacing.p1),
                    Icon(Icons.edit, size: FontSize.small),
                  ]),
                )
              ]),
              SizedBox(height: SGSpacing.p5),
              ...widget.category.options
                  .mapIndexed((index, option) => [
                        SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                        MultipleInformationBox(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => _CuisineOptionEditScreen(option: option)));
                            },
                            child: Row(children: [
                              SGTypography.body(option.name ?? "", size: FontSize.normal, weight: FontWeight.w600),
                              SizedBox(width: SGSpacing.p1),
                              Icon(Icons.edit, size: FontSize.small),
                            ]),
                          ),
                          SizedBox(height: SGSpacing.p5),
                          DataTableRow(left: "가격", right: "${(option.price ?? 0).toKoreanCurrency}원"),
                        ]),
                      ])
                  .flattened,
              SizedBox(height: SGSpacing.p5),
              GestureDetector(
                  onTap: () {},
                  child: SGContainer(
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      borderColor: SGColors.primary,
                      child: Center(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3),
                        SizedBox(width: SGSpacing.p2),
                        SGTypography.body("옵션 추가하기",
                            size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                      ])))),
            ])));
  }
}

class _CuisineOptionEditScreen extends StatefulWidget {
  final CuisineOption option;
  _CuisineOptionEditScreen({
    super.key,
    required this.option,
  });

  @override
  State<_CuisineOptionEditScreen> createState() => _CuisineOptionEditScreenState();
}

class _CuisineOptionEditScreenState extends State<_CuisineOptionEditScreen> {
  late String menuPrice = "${(widget.option.price ?? 0).toKoreanCurrency}원";
  bool isSoldOut = false;
  Nutrition nutrition =
      Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "옵션 관리"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            MultipleInformationBox(children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextFieldEditScreen(
                            value: widget.option.name ?? "",
                            title: "옵션 변경",
                            onSubmit: (value) {
                              setState(() {
                                widget.option.name = value;
                              });
                            },
                            buttonText: "저장하기",
                            hintText: "옵션 이름을 입력해주세요",
                          )));
                },
                child: Row(children: [
                  SGTypography.body(widget.option.name ?? "", size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p1),
                  Icon(Icons.edit, size: FontSize.small),
                ]),
              ),
              SizedBox(height: SGSpacing.p5),
              DataTableRow(left: "가격", right: "$menuPrice"),
              SizedBox(height: SGSpacing.p5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextFieldEditScreen(
                            value: menuPrice,
                            title: "옵션 가격 변경",
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
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    borderColor: SGColors.line3,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SGSpacing.p3 / 2),
                    child: Center(
                        child: SGTypography.body("가격 변경",
                            size: FontSize.small, weight: FontWeight.w400, color: SGColors.gray4))),
              )
            ]),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
              borderColor: SGColors.line2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("품절", size: FontSize.normal),
                Spacer(),
                SGSwitch(
                    value: isSoldOut,
                    onChanged: (value) {
                      setState(() {
                        isSoldOut = value;
                      });
                    }),
              ]),
            ),
            SizedBox(height: SGSpacing.p8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NutritionCard(
                nutrition: nutrition,
                onTap: () {
                  final screenContext = context;
                  Navigator.of(screenContext).push(MaterialPageRoute(
                      builder: (nutritionScreenContext) => _NutritionEditScreen(
                            nutrition: nutrition,
                            onConfirm: (value, ctx) {
                              showSGDialog(
                                  context: ctx,
                                  childrenBuilder: (_ctx) => [
                                        Center(
                                            child: SGTypography.body("영양성분을\n정말 설정하시겠습니까?",
                                                size: FontSize.large,
                                                weight: FontWeight.w700,
                                                lineHeight: 1.25,
                                                align: TextAlign.center)),
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
                                                  child: SGTypography.body("취소",
                                                      size: FontSize.normal,
                                                      weight: FontWeight.w700,
                                                      color: SGColors.white),
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
                                                  child: SGTypography.body("확인",
                                                      size: FontSize.normal,
                                                      weight: FontWeight.w700,
                                                      color: SGColors.white),
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
            ]),
            SizedBox(height: SGSpacing.p4),
            GestureDetector(
              onTap: () {
                showSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                          Center(
                              child: SGTypography.body("해당 옵션을\n정말 삭제하시겠습니까?",
                                  size: FontSize.large,
                                  weight: FontWeight.w700,
                                  align: TextAlign.center,
                                  lineHeight: 1.25)),
                          SizedBox(height: SGSpacing.p5 / 2),
                          SGTypography.body("옵션 삭제 시 해당 옵션은 전부 삭제됩니다.", color: SGColors.gray4),
                          SizedBox(height: SGSpacing.p5),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  Navigator.of(context).pop();
                                },
                                child: SGContainer(
                                  color: SGColors.gray3,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
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
                                    child: SGTypography.body("취소",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ])
                        ]);
              },
              child: SGContainer(
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                color: SGColors.warningRed.withOpacity(0.08),
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Center(
                  child: SGTypography.body("옵션 삭제",
                      size: FontSize.small, weight: FontWeight.w600, color: SGColors.warningRed),
                ),
              ),
            ),
            SizedBox(height: SGSpacing.p32),
          ])),
    );
  }
}

class _NutritionEditScreen extends StatefulWidget {
  Nutrition nutrition;
  Function(Nutrition, BuildContext) onConfirm;

  _NutritionEditScreen({super.key, required this.nutrition, required this.onConfirm});

  @override
  State<_NutritionEditScreen> createState() => _NutritionEditScreenState();
}

class _NutritionEditScreenState extends State<_NutritionEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 수정"),
      body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}
