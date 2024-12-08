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
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';

import '../model.dart';
import '../new_cuisine_option_screen.dart';
import '../nutrition_card.dart';
import '../nutrition_form.dart';

class CuisineOptionCategoryScreen extends StatefulWidget {
  const CuisineOptionCategoryScreen({super.key});

  @override
  State<CuisineOptionCategoryScreen> createState() => _CuisineOptionCategoryScreenState();
}

final MenuOptionCategoryModel category = MenuOptionCategoryModel(
  menuOptionCategoryName: "곡물 베이스 선택",
  essentialStatus: 1,
  maxChoice: 1,
  menuOptions: [
    MenuOptionModel(optionContent: "채소 베이스", price: 0),
    MenuOptionModel(optionContent: "오곡 베이스", price: 0),
  ],
);

final List<MenuModel> cuisines = [
  MenuModel(
    menuName: "참치 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
    ],
  ),
  MenuModel(
    menuName: "연어 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
    ],
  ),
  MenuModel(
    menuName: "닭가슴살 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisionOptionCategoryQuantityEditScreen(isEssential: isEssential)));
              },
              child: SGContainer(
                borderColor: SGColors.line2,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                child: Row(children: [SGTypography.body("옵션 선택 개수 설정", size: FontSize.small), SizedBox(width: SGSpacing.p1), Icon(Icons.edit, size: FontSize.small), Spacer(), SGTypography.body("최소 1개, 최대 1개", size: FontSize.small)]),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => _EditRelatedCuisineScreen(cuisines: cuisines)));
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
                            cuisine.menuPictureURL,
                            width: SGSpacing.p18,
                            height: SGSpacing.p18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: SGSpacing.p4),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SGTypography.body(cuisine.menuName, size: FontSize.normal, weight: FontWeight.w700),
                          SizedBox(height: SGSpacing.p2),
                          SGTypography.body("${cuisine.price.toKoreanCurrency}원", size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
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
                        Center(child: SGTypography.body("옵션 카테고리를\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
            child: SGContainer(
                color: SGColors.warningRed.withOpacity(0.08),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                child: Center(
                  child: SGTypography.body("옵션 카테고리 삭제", color: SGColors.warningRed, weight: FontWeight.w600, size: FontSize.small),
                )),
          ),
          SizedBox(height: SGSpacing.p32),
        ]),
      ),
    );
  }
}

class _EditRelatedCuisineScreen extends StatefulWidget {
  final List<MenuModel> cuisines;

  const _EditRelatedCuisineScreen({
    super.key,
    required this.cuisines,
  });

  @override
  State<_EditRelatedCuisineScreen> createState() => _EditRelatedCuisineScreenState();
}

class _EditRelatedCuisineScreenState extends State<_EditRelatedCuisineScreen> {
  void showDialog(String message) {
    showSGDialog(
        context: context,
        childrenBuilder: (ctx) => [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: SGTypography.body(message, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                  SizedBox(height: SGSpacing.p4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: SGSpacing.p8),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: SGContainer(
                          color: SGColors.gray3,
                          width: SGSpacing.p24 + SGSpacing.p8,
                          borderColor: SGColors.white,
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          child: Center(child: SGTypography.body("취소", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                        ),
                      ),
                      SizedBox(width: SGSpacing.p2),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(ctx);
                        },
                        child: SGContainer(
                          color: SGColors.primary,
                          width: SGSpacing.p24 + SGSpacing.p8,
                          borderColor: SGColors.primary,
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "옵션 카테고리 사용 메뉴"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  showDialog("해당 변경사항을\n적용하시겠습니까?");
                  // widget.onSubmit(controller.text);
                  // Navigator.of(context).pop();
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
              ...widget.cuisines
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
                        SGTypography.body("메뉴 추가하기", size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                      ])))),
            ])));
  }
}

class _SelectedCuisineCard extends StatelessWidget {
  final MenuModel cuisine;
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
              ClipRRect(borderRadius: BorderRadius.circular(SGSpacing.p4), child: Image.network(cuisine.menuPictureURL, width: SGSpacing.p18, height: SGSpacing.p18)),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(cuisine.menuName, color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("${cuisine.price.toKoreanCurrency}원", color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
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
  String minErrorMessage = "";
  String maxErrorMessage = "";

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  void _validateMinInput() {
    setState(() {
      if (minValueController.text == "0") {
        minErrorMessage = "0개는 기입하실 수 없습니다.";
      } else {
        minErrorMessage = "";
      }
    });
  }

  void _validateMaxInput() {
    setState(() {
      if (maxValueController.text == "0") {
        maxErrorMessage = "0개는 기입하실 수 없습니다.";
      } else {
        maxErrorMessage = "";
      }
    });
  }

  bool get isDisabled => minValueController.text == "0" || maxValueController.text == "0";

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
              disabled: isDisabled,
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
                        onChanged: (_) {
                          _validateMinInput();
                          setState(() {});
                        },
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
            if (minErrorMessage.isNotEmpty) ...[
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(minErrorMessage, size: FontSize.small, color: Colors.red),
            ],
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
                      onChanged: (_) => _validateMaxInput(),
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
          if (maxErrorMessage.isNotEmpty) ...[
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(maxErrorMessage, size: FontSize.small, color: Colors.red),
          ],
        ]),
      ),
    );
  }
}

class _CuisineOptionCategoryCard extends StatefulWidget {
  final MenuOptionCategoryModel category;

  const _CuisineOptionCategoryCard({super.key, required this.category});

  @override
  State<_CuisineOptionCategoryCard> createState() => _CuisineOptionCategoryCardState();
}

class _CuisineOptionCategoryCardState extends State<_CuisineOptionCategoryCard> {
  String get selectionType {
    if (widget.category.essentialStatus == 1) return "(필수)";
    return "(선택 최대 ${widget.category.maxChoice ?? 0}개)";
  }

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
    return MultipleInformationBox(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisineOptionCategoryEditScreen(category: widget.category)));
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SGTypography.body(widget.category.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          Icon(Icons.edit, size: FontSize.small),
        ]),
      ),
      ...widget.category.menuOptions
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.optionContent ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened
    ]);
  }
}

class CuisineOptionCategoryEditScreen extends StatefulWidget {
  final MenuOptionCategoryModel category;

  CuisineOptionCategoryEditScreen({super.key, required this.category});

  @override
  State<CuisineOptionCategoryEditScreen> createState() => _CuisineOptionCategoryEditScreenState();
}

class _CuisineOptionCategoryEditScreenState extends State<CuisineOptionCategoryEditScreen> {
  bool isSoldOut = false;

  Nutrition nutrition = Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

  late String categoryName = widget.category.menuOptionCategoryName;
  List<MenuOptionModel> options = [];

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
              ...widget.category.menuOptions
                  .mapIndexed((index, option) => [
                        SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                        MultipleInformationBox(children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => _CuisineOptionEditScreen(option: option)));
                              showFailDialogWithImage(mainTitle: "해당 옵션은 삭제된 옵션입니다.", subTitle: "");
                            },
                            child: Row(children: [
                              SGTypography.body(option.optionContent ?? "", size: FontSize.normal, weight: FontWeight.w600),
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
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NewCuisineOptionScreen(
                              onSubmitCuisineOption: (option) {
                                setState(() {
                                  options.add(option);
                                });
                              },
                            )));
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
                        SGTypography.body("옵션 추가하기", size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                      ])))),
            ])));
  }
}

class _CuisineOptionEditScreen extends StatefulWidget {
  final MenuOptionModel option;

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
  Nutrition nutrition = Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

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
                            value: widget.option.optionContent ?? "",
                            title: "옵션 변경",
                            onSubmit: (value) {
                              setState(() {
                                // widget.option.optionContent = value;
                              });
                            },
                            buttonText: "저장하기",
                            hintText: "옵션 이름을 입력해주세요",
                          )));
                },
                child: Row(children: [
                  SGTypography.body(widget.option.optionContent ?? "", size: FontSize.normal, weight: FontWeight.w600),
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
                    child: Center(child: SGTypography.body("가격 변경", size: FontSize.small, weight: FontWeight.w400, color: SGColors.gray4))),
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
                            onConfirm: (value, quantity, ctx) {
                              showSGDialog(
                                  context: ctx,
                                  childrenBuilder: (_ctx) => [
                                        Center(child: SGTypography.body("영양성분을\n정말 설정하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
            ]),
            SizedBox(height: SGSpacing.p4),
            GestureDetector(
              onTap: () {
                showSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                          Center(child: SGTypography.body("해당 옵션을\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, align: TextAlign.center, lineHeight: 1.25)),
                          SizedBox(height: SGSpacing.p5 / 2),
                          SGTypography.body("옵션 삭제 시 해당 옵션은 전부 삭제됩니다.", color: SGColors.gray4),
                          SizedBox(height: SGSpacing.p5),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showFailDialogWithImage(mainTitle: "진행 중인 주문에 선택된 옵션입니다.\n주문 완료 후 삭제 가능합니다.", subTitle: "");
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
                          ])
                        ]);
              },
              child: SGContainer(
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                color: SGColors.warningRed.withOpacity(0.08),
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Center(
                  child: SGTypography.body("옵션 삭제", size: FontSize.small, weight: FontWeight.w600, color: SGColors.warningRed),
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
      body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}
