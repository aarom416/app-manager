import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../model.dart';
import '../provider.dart';
import 'menu_category_card.dart';
import 'newmenucategory/screen.dart';
import 'newmenu/screen.dart';

class MenuTab extends ConsumerStatefulWidget {
  const MenuTab({super.key});

  @override
  ConsumerState<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends ConsumerState<MenuTab> {
  List<SelectionOption<int>> soldOutStatusOptions = [
    SelectionOption<int>(value: -1, label: "판매 상태 전체"),
    SelectionOption<int>(value: 0, label: "판매 중"),
    SelectionOption<int>(value: 1, label: "품절"),
  ];

  late List<MenuCategoryModel> menuCategoryList;
  late int selectedSoldOutStatusOptionValue;
  late String selectedSoldOutStatusOptionLabel;
  late String selectedMenuCategoryName;
  late String menuNameQuery;
  late TextEditingController menuNameQueryController;

  @override
  void initState() {
    super.initState();
    menuCategoryList = [
      MenuCategoryModel(menuCategoryName: "단품 메뉴", menuDescription: "곡물 베이스는 기본입니다.", menuList: [
        MenuModel(
          menuName: "참치 샐러드",
          price: 13000,
          menuDescription: "곡물 베이스는 기본입니다.",
          menuPictureURL: "https://via.placeholder.com/150",
          soldOutStatus: 0,
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
          soldOutStatus: 1,
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
          soldOutStatus: 0,
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
      ]),
      MenuCategoryModel(menuCategoryName: "1인 샐러드 세트", menuDescription: "곡물 베이스는 기본입니다.", menuList: [
        MenuModel(
          menuName: "연어 샐러드",
          price: 13000,
          menuDescription: "곡물 베이스는 기본입니다.",
          menuPictureURL: "https://via.placeholder.com/150",
          soldOutStatus: 1,
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
          soldOutStatus: 1,
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
      ]),
      MenuCategoryModel(menuCategoryName: "다이어트 풀코스", menuDescription: "곡물 베이스는 기본입니다.", menuList: [
        MenuModel(
          menuName: "연어 샐러드",
          price: 13000,
          menuDescription: "곡물 베이스는 기본입니다.",
          menuPictureURL: "https://via.placeholder.com/150",
          soldOutStatus: 0,
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
          soldOutStatus: 0,
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
      ]),
    ];
    selectedSoldOutStatusOptionValue = soldOutStatusOptions[0].value;
    selectedSoldOutStatusOptionLabel = soldOutStatusOptions[0].label;
    selectedMenuCategoryName = "";
    menuNameQuery = "";
    menuNameQueryController = TextEditingController();
  }

  List<MenuCategoryModel> getFilteredMenuCategories() {
    return menuCategoryList
        .map((category) {
          // menuCategoryName은 equals로 필터
          final isCategoryNameMatch = selectedMenuCategoryName == "" || category.menuCategoryName == selectedMenuCategoryName;

          // 메뉴 필터링
          final filteredMenus = category.menuList.where((menu) {
            final isNameMatch = menuNameQuery == "" || menu.menuName.contains(menuNameQuery); // menuName은 like 필터
            final isSoldOutMatch = selectedSoldOutStatusOptionValue == -1 || menu.soldOutStatus == selectedSoldOutStatusOptionValue; // -1이면 조건 무시
            return isNameMatch && isSoldOutMatch;
          }).toList();

          // 필터링된 메뉴로 새로운 category 생성
          if (isCategoryNameMatch && filteredMenus.isNotEmpty) {
            return category.copyWith(menuList: filteredMenus);
          }
          return null;
        })
        .whereType<MenuCategoryModel>() // null 제거
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);

    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    print("menuNameQuery $menuNameQuery");
    print("selectedSoldOutStatusOptionValue $selectedSoldOutStatusOptionValue");
    print("selectedMenuCategoryName $selectedMenuCategoryName");
    print("selectedSoldOutStatusOptionLabel $selectedSoldOutStatusOptionLabel");

    List<MenuCategoryModel> filterMenuCategories = getFilteredMenuCategories();
    print("filterMenuCategories $filterMenuCategories");

    return Column(children: [
      SizedBox(height: SGSpacing.p3),

      // --------------------------- 메뉴명 검색 ---------------------------
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
                    controller: menuNameQueryController,
                    style: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5),
                    decoration: InputDecoration(isDense: true, hintText: "메뉴명 검색", hintStyle: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5, fontWeight: FontWeight.w400), border: InputBorder.none),
                    onChanged: (menuNameQuery) {
                      setState(() {
                        this.menuNameQuery = menuNameQuery;
                      });
                    }))
          ])),

      SizedBox(height: SGSpacing.p4),

      // --------------------------- 정렬 option ---------------------------
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
                        options: soldOutStatusOptions,
                        onSelect: (selectedSoldOutStatusOptionValue) {
                          setState(() {
                            this.selectedSoldOutStatusOptionValue = selectedSoldOutStatusOptionValue;
                            selectedSoldOutStatusOptionLabel = soldOutStatusOptions.firstWhere((selectionOption) => selectionOption.value == selectedSoldOutStatusOptionValue).label;
                            menuNameQuery = "";
                          });
                        },
                        selected: selectedSoldOutStatusOptionValue);
                  },
                  child: SGContainer(
                      borderColor: SGColors.line2,
                      borderRadius: BorderRadius.circular(SGSpacing.p20),
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4).copyWith(right: SGSpacing.p3),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SGTypography.body(selectedSoldOutStatusOptionLabel, size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray5),
                        SizedBox(width: SGSpacing.p1),
                        Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p4, height: SGSpacing.p4)
                      ]))),
              ...menuCategoryList
                  .map((cuisineCategory) => [
                        SizedBox(width: SGSpacing.p2),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMenuCategoryName = selectedMenuCategoryName == cuisineCategory.menuCategoryName ? "" : cuisineCategory.menuCategoryName;
                            });
                          },
                          child: SGContainer(
                              borderColor: selectedMenuCategoryName == cuisineCategory.menuCategoryName ? SGColors.primary.withOpacity(0.1) : SGColors.line2,
                              borderRadius: BorderRadius.circular(SGSpacing.p20),
                              color: selectedMenuCategoryName == cuisineCategory.menuCategoryName ? SGColors.primary.withOpacity(0.08) : SGColors.white,
                              padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4),
                              child: Center(
                                child: SGTypography.body(cuisineCategory.menuCategoryName, size: FontSize.small, weight: FontWeight.w500, color: selectedMenuCategoryName == cuisineCategory.menuCategoryName ? SGColors.primary : SGColors.gray5),
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
              setState(() {
                selectedSoldOutStatusOptionValue = soldOutStatusOptions[0].value;
                selectedSoldOutStatusOptionLabel = soldOutStatusOptions[0].label;
                selectedMenuCategoryName = "";
                menuNameQuery = "";
                menuNameQueryController.text = "";
              });
            }))
      ]),

      SizedBox(height: SGSpacing.p4),

      // --------------------------- 메뉴 카테고리 추가, 메뉴 추가 button ---------------------------
      Row(children: [
        Expanded(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewMenuCategoryScreen()));
          },
          child: SGContainer(
              color: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
              borderRadius: BorderRadius.circular(SGSpacing.p2),
              child: Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ColorFiltered(colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn), child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p2),
                SGTypography.body("메뉴 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.white)
              ]))),
        )),
        SizedBox(width: SGSpacing.p2),
        Expanded(
            child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewMenuScreen()));
          },
          child: SGContainer(
              color: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
              borderRadius: BorderRadius.circular(SGSpacing.p2),
              child: Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ColorFiltered(colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn), child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p2),
                SGTypography.body("메뉴 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.white)
              ]))),
        )),
      ]),

      SizedBox(height: SGSpacing.p5),

      // --------------------------- 단품 메뉴 list ---------------------------
      ...filterMenuCategories.map((menuCategory) => MenuCategoryCard(menuCategory: menuCategory)),

      SizedBox(height: SGSpacing.p10),
    ]);
  }
}
