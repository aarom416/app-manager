import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/menu_tab_bar.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/cuisine_option_category_screen.dart';
import 'package:singleeat/screens/cuisine_screen.dart';
import 'package:singleeat/screens/new_cuisine_category_screen.dart';
import 'package:singleeat/screens/new_cuisine_option_category_screen.dart';
import 'package:singleeat/screens/new_cuisine_screen.dart';
import 'package:singleeat/screens/update_cuisine_category_screen.dart';

class StoreManangementCuisineManagementScreen extends StatefulWidget {
  const StoreManangementCuisineManagementScreen({super.key});

  @override
  State<StoreManangementCuisineManagementScreen> createState() => _StoreManangementCuisineManagementScreenState();
}

class _StoreManangementCuisineManagementScreenState extends State<StoreManangementCuisineManagementScreen> {
  String currentTab = "메뉴 관리";
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      MenuTabBar(
          currentTab: currentTab,
          tabs: ['메뉴 관리', '옵션 관리'],
          onTabChanged: (tab) {
            setState(() {
              currentTab = tab;
            });
          }),
      if (currentTab == "메뉴 관리") _CuisineManagementScreen() else _CuisineOptionManagementScreen()
    ]);
  }
}

List<CuisineOptionCategory> categoryOptions = [
  CuisineOptionCategory(
      name: "곡물 베이스 선택",
      options: [
        CuisineOption(name: "곡물 베이스 선택", price: 0),
        CuisineOption(name: "오곡 베이스", price: 0),
      ],
      isEssential: true),
  CuisineOptionCategory(name: "토핑 선택", maximumSelection: 2, options: [
    CuisineOption(name: "훈제오리 토핑", price: 0),
    CuisineOption(name: "연어 토핑", price: 500),
    CuisineOption(name: "우삼겹 토핑", price: 3000),
  ]),
];

class _CuisineOptionManagementScreen extends StatefulWidget {
  _CuisineOptionManagementScreen({
    super.key,
  });

  @override
  State<_CuisineOptionManagementScreen> createState() => _CuisineOptionManagementScreenState();
}

class _CuisineOptionManagementScreenState extends State<_CuisineOptionManagementScreen> {
  List<SelectionOption<String>> options = [
    SelectionOption<String>(value: "판매 상태 전체", label: "판매 상태 전체"),
    SelectionOption<String>(value: "판매 중", label: "판매 중"),
    SelectionOption<String>(value: "품절", label: "품절"),
  ];

  String selectedOption = "판매 상태 전체";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: SGSpacing.p3),
      SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4),
          borderRadius: BorderRadius.circular(SGSpacing.p20),
          borderColor: SGColors.line1,
          child: Row(children: [
            Image.asset("assets/images/search.png", width: SGSpacing.p6, height: SGSpacing.p6),
            SizedBox(width: SGSpacing.p2),
            Expanded(
                child: TextField(
                    style: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5),
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "옵션명을 입력해주세요",
                        hintStyle:
                            TextStyle(fontSize: FontSize.normal, color: SGColors.gray5, fontWeight: FontWeight.w400),
                        border: InputBorder.none)))
          ])),
      SizedBox(height: SGSpacing.p4),
      Stack(alignment: Alignment.center, children: [
        SGContainer(
          height: SGSpacing.p9,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet(
                        context: context,
                        title: "정렬",
                        options: options,
                        onSelect: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                        selected: selectedOption);
                  },
                  child: SGContainer(
                      borderColor: SGColors.line2,
                      borderRadius: BorderRadius.circular(SGSpacing.p20),
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4)
                          .copyWith(right: SGSpacing.p3),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SGTypography.body(selectedOption,
                            size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray5),
                        SizedBox(width: SGSpacing.p1),
                        Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p4, height: SGSpacing.p4)
                      ]))),
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: ReloadButton(onReload: () {
              print("hello");
            }))
      ]),
      SizedBox(height: SGSpacing.p4),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCuisineOptionCategoryScreen()));
          },
          child: SGContainer(
              color: SGColors.white,
              borderRadius: BorderRadius.circular(SGSpacing.p3 / 2),
              borderColor: SGColors.line3,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p3),
              child: Row(children: [
                ColorFiltered(
                    colorFilter: ColorFilter.mode(SGColors.gray4, BlendMode.modulate),
                    child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("옵션 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4)
              ])),
        )
      ]),
      SizedBox(height: SGSpacing.p4),
      ...categoryOptions
          .map((category) => [
                _CuisineOptionCategoryCard(category: category),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              ])
          .flattened,
    ]);
  }
}

class _CuisineOptionCategoryCard extends StatefulWidget {
  final CuisineOptionCategory category;

  const _CuisineOptionCategoryCard({super.key, required this.category});

  @override
  State<_CuisineOptionCategoryCard> createState() => _CuisineOptionCategoryCardState();
}

class _CuisineOptionCategoryCardState extends State<_CuisineOptionCategoryCard> {
  String get selectionType {
    if (widget.category.isEssential) return "(필수)";
    return "(선택 최대 ${widget.category.maximumSelection ?? 0}개)";
  }

  bool isExpanded = false;

  List<String> hardcodedMenus = ["연어 샐러드", "훈제 오리 샐러드", "탄단지 샐러드"];

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisineOptionCategoryScreen()));
            },
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SGTypography.body(widget.category.name, size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              Icon(Icons.edit, size: FontSize.small),
            ]),
          ),
          Spacer(),
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
                              },
                              child: SGContainer(
                                color: SGColors.gray3,
                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                child: Center(
                                  child: SGTypography.body("취소",
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
                                  child: SGTypography.body("확인",
                                      size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ]);
            },
            child: SGContainer(
                borderColor: SGColors.line2,
                borderRadius: BorderRadius.circular(SGSpacing.p20),
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p1 + SGSpacing.p05, horizontal: SGSpacing.p2),
                child: SGTypography.body("옵션삭제", color: SGColors.gray4, weight: FontWeight.w400)),
          ),
        ],
      ),
      ...widget.category.options
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.name ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened,
      SizedBox(height: SGSpacing.p5),
      SGContainer(
        borderRadius: BorderRadius.circular(SGSpacing.p2),
        color: SGColors.gray1,
        padding: EdgeInsets.symmetric(vertical: SGSpacing.p3 + SGSpacing.p05, horizontal: SGSpacing.p4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SGTypography.body("이 옵션을 사용하는 메뉴 2개", size: FontSize.small),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: SGTypography.body(isExpanded ? "접기" : "펼치기",
                  color: SGColors.primary, weight: FontWeight.w500, size: FontSize.small),
            ),
          ]),
          SizedBox(height: SGSpacing.p05),
          if (isExpanded) ...[
            SizedBox(height: SGSpacing.p05),
            ...hardcodedMenus
                .map((menu) => [
                      SizedBox(height: SGSpacing.p2),
                      SGTypography.body(menu, size: FontSize.small, color: SGColors.gray4),
                    ])
                .flattened,
          ] else ...[
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(hardcodedMenus.sublist(0, 2).join(", "), size: FontSize.small, color: SGColors.gray4),
          ]
        ]),
      )
    ]);
  }
}

class _CuisineManagementScreen extends StatefulWidget {
  const _CuisineManagementScreen({
    super.key,
  });

  @override
  State<_CuisineManagementScreen> createState() => _CuisineManagementScreenState();
}

class _CuisineManagementScreenState extends State<_CuisineManagementScreen> {
  List<SelectionOption<String>> options = [
    SelectionOption<String>(value: "판매 상태 전체", label: "판매 상태 전체"),
    SelectionOption<String>(value: "판매 중", label: "판매 중"),
    SelectionOption<String>(value: "품절", label: "품절"),
  ];

  String selectedOption = "판매 상태 전체";
  String selectedCuisineCategory = "";

  List<CuisineCategory> cuisineCategories = [
    CuisineCategory(name: "단품 메뉴", description: "곡물 베이스는 기본입니다.", cuisines: [
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
    ]),
    CuisineCategory(name: "1인 샐러드 세트", description: "곡물 베이스는 기본입니다.", cuisines: [
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
    ]),
    CuisineCategory(name: "다이어트 풀코스", description: "곡물 베이스는 기본입니다.", cuisines: [
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
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: SGSpacing.p3),
      SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4),
          borderRadius: BorderRadius.circular(SGSpacing.p20),
          borderColor: SGColors.line1,
          child: Row(children: [
            Image.asset("assets/images/search.png", width: SGSpacing.p6, height: SGSpacing.p6),
            SizedBox(width: SGSpacing.p2),
            Expanded(
                child: TextField(
                    style: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5),
                    decoration: InputDecoration(
                        isDense: true,
                        hintText: "메뉴명 검색",
                        hintStyle:
                            TextStyle(fontSize: FontSize.normal, color: SGColors.gray5, fontWeight: FontWeight.w400),
                        border: InputBorder.none)))
          ])),
      SizedBox(height: SGSpacing.p4),
      Stack(alignment: Alignment.center, children: [
        SGContainer(
          height: SGSpacing.p9,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet(
                        context: context,
                        title: "정렬",
                        options: options,
                        onSelect: (value) {
                          setState(() {
                            selectedOption = value;
                            selectedCuisineCategory = "";
                          });
                        },
                        selected: selectedOption);
                  },
                  child: SGContainer(
                      borderColor: SGColors.line2,
                      borderRadius: BorderRadius.circular(SGSpacing.p20),
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4)
                          .copyWith(right: SGSpacing.p3),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SGTypography.body(selectedOption,
                            size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray5),
                        SizedBox(width: SGSpacing.p1),
                        Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p4, height: SGSpacing.p4)
                      ]))),
              ...cuisineCategories
                  .map((cuisineCategory) => [
                        SizedBox(width: SGSpacing.p2),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCuisineCategory = cuisineCategory.name;
                            });
                          },
                          child: SGContainer(
                              borderColor: selectedCuisineCategory == cuisineCategory.name
                                  ? SGColors.primary.withOpacity(0.1)
                                  : SGColors.line2,
                              borderRadius: BorderRadius.circular(SGSpacing.p20),
                              color: selectedCuisineCategory == cuisineCategory.name
                                  ? SGColors.primary.withOpacity(0.08)
                                  : SGColors.white,
                              padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4),
                              child: Center(
                                child: SGTypography.body(cuisineCategory.name,
                                    size: FontSize.small,
                                    weight: FontWeight.w500,
                                    color: selectedCuisineCategory == cuisineCategory.name
                                        ? SGColors.primary
                                        : SGColors.gray5),
                              )),
                        )
                      ])
                  .flattened,
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: ReloadButton(onReload: () {
              print("hello");
            }))
      ]),
      SizedBox(height: SGSpacing.p4),
      Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCuisineCategoryScreen()));
          },
          child: SGContainer(
              color: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
              borderRadius: BorderRadius.circular(SGSpacing.p2),
              child: Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ColorFiltered(
                    colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn),
                    child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p2),
                SGTypography.body("메뉴 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.white)
              ]))),
        )),
        SizedBox(width: SGSpacing.p2),
        Expanded(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCuisineScreen()));
          },
          child: SGContainer(
              color: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
              borderRadius: BorderRadius.circular(SGSpacing.p2),
              child: Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ColorFiltered(
                    colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn),
                    child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p2),
                SGTypography.body("메뉴 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.white)
              ]))),
        )),
      ]),
      SizedBox(height: SGSpacing.p5),
      ...cuisineCategories
          .where((cuisineCategory) => cuisineCategory.name.contains(selectedCuisineCategory))
          .map((cuisineCategory) => _CuisineCategoryCard(cuisineCategory: cuisineCategory)),
      SizedBox(height: SGSpacing.p10),
    ]);
  }
}

class _CuisineCategoryCard extends StatelessWidget {
  final CuisineCategory cuisineCategory;

  _CuisineCategoryCard({
    super.key,
    required this.cuisineCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      MultipleInformationBox(children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UpdateCuisineCategoryScreen(category: cuisineCategory)));
          },
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            SGTypography.body(cuisineCategory.name, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(width: SGSpacing.p1),
            const Icon(Icons.edit, size: FontSize.small),
          ]),
        ),
        ...cuisineCategory.cuisines.mapIndexed((idx, cuisine) => Column(mainAxisSize: MainAxisSize.min, children: [
              if (idx != 0) ...[
                SizedBox(height: SGSpacing.p4),
                Divider(height: 1, color: SGColors.line1, thickness: 1),
              ],
              SizedBox(height: SGSpacing.p4),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisineScreen()));
                },
                child: Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(SGSpacing.p4),
                      child: Image.network(cuisine.image, width: SGSpacing.p18, height: SGSpacing.p18)),
                  SizedBox(width: SGSpacing.p4),
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SGTypography.body(cuisine.name, size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p2),
                    SGTypography.body("${cuisine.price.toKoreanCurrency}원",
                        size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                  ]),
                ]),
              ),
            ]))
      ]),
      SizedBox(height: SGSpacing.p3),
    ]);
  }
}
