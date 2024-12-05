import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:singleeat/screens/home/storemanagement/menu/options/cuisine_option_category_screen.dart';
import 'package:singleeat/screens/cuisine_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/new_cuisine_category_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/options/new_cuisine_option_category_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/new_cuisine_screen.dart';
import 'package:singleeat/screens/update_cuisine_category_screen.dart';



class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {

  @override
  void initState() {
    Future.microtask(() {
    //  ref.read(operationNotifierProvider.notifier).getOperationInfo();
    });
  }

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
                    SGTypography.body ("메뉴 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.white)
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
          .map((cuisineCategory) => _MenuCategoryCard(cuisineCategory: cuisineCategory)),
      SizedBox(height: SGSpacing.p10),
    ]);
  }
}

class _MenuCategoryCard extends StatefulWidget {
  final CuisineCategory cuisineCategory;

  _MenuCategoryCard({
    super.key,
    required this.cuisineCategory,
  });

  @override
  State<_MenuCategoryCard> createState() => _MenuCategoryCardState();
}

class _MenuCategoryCardState extends State<_MenuCategoryCard> {

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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisineScreen()));
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
    return Column(mainAxisSize: MainAxisSize.min, children: [
      MultipleInformationBox(children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => UpdateCuisineCategoryScreen(category: widget.cuisineCategory)));
          },
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            SGTypography.body(widget.cuisineCategory.name, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(width: SGSpacing.p1),
            const Icon(Icons.edit, size: FontSize.small),
          ]),
        ),
        ...widget.cuisineCategory.cuisines.mapIndexed((idx, cuisine) => Column(mainAxisSize: MainAxisSize.min, children: [
              if (idx != 0) ...[
                SizedBox(height: SGSpacing.p4),
                Divider(height: 1, color: SGColors.line1, thickness: 1),
              ],
              SizedBox(height: SGSpacing.p4),
              GestureDetector(
                onTap: () {
                  showFailDialogWithImage(mainTitle: "해당 메뉴는 삭제된 메뉴입니다.", subTitle: "");
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
