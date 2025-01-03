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
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/menu/updatemenucategory/screen.dart';

import '../../../../../core/components/multiple_information_box.dart';
import '../../../../../main.dart';
import '../model.dart';
import '../provider.dart';
import 'addmenu/screen.dart';
import 'addmenucategory/screen.dart';
import 'updatemenu/screen.dart';

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

  late int selectedSoldOutStatusOptionValue;
  late String selectedSoldOutStatusOptionLabel;
  late String selectedMenuCategoryName;
  late String menuNameQuery;
  late TextEditingController menuNameQueryController;

  @override
  void initState() {
    super.initState();
    selectedSoldOutStatusOptionValue = soldOutStatusOptions[0].value;
    selectedSoldOutStatusOptionLabel = soldOutStatusOptions[0].label;
    selectedMenuCategoryName = "";
    menuNameQuery = "";
    menuNameQueryController = TextEditingController();
  }

  /// 검색조건, 정렬 option 에 따른 menuCategoryList
  List<MenuCategoryModel> getFilteredMenuCategories(List<MenuCategoryModel> menuCategoryList) {
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
          if (isCategoryNameMatch) {
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
    final List<MenuCategoryModel> filterMenuCategories = getFilteredMenuCategories(state.menuCategoryList);

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
              },
            ))
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
              ...state.menuCategoryList
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
              logger.i("hello");
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddMenuCategoryScreen()));
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddMenuScreen()));
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
      ...filterMenuCategories.map((menuCategory) => _MenuCategoryCard(menuCategory: menuCategory)),
      SizedBox(height: SGSpacing.p10),
    ]);
  }
}

class _MenuCategoryCard extends StatelessWidget {
  final MenuCategoryModel menuCategory;

  const _MenuCategoryCard({super.key, required this.menuCategory});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      MultipleInformationBox(children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateMenuCategoryScreen(menuCategoryModel: menuCategory)));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 231,
                    child: SGTypography.body(
                      menuCategory.menuCategoryName,
                      size: FontSize.normal,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.edit, size: FontSize.small),
                ],
              ),
              SizedBox(
                height: SGSpacing.p2,
              ),
              Container(
                width: 231,
                child: SGTypography.body(
                  menuCategory.menuIntroduction,
                  size: FontSize.small,
                  color: SGColors.gray4,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        ...menuCategory.menuList.mapIndexed((idx, menu) => Column(mainAxisSize: MainAxisSize.min, children: [
              if (idx != 0) ...[
                SizedBox(height: SGSpacing.p4),
                Divider(height: 1, color: SGColors.line1, thickness: 1),
              ],
              SizedBox(height: SGSpacing.p4),
              GestureDetector(
                onTap: () {
                  // showFailDialogWithImage(
                  //   context: context,
                  //   mainTitle: "해당 메뉴는 삭제된 메뉴입니다.",
                  //   onTapFunction: () {
                  //     Navigator.pop(context); // 현재 다이얼로그를 닫음
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => const UpdateMenuScreen()),
                  //     );
                  //   },
                  //   onNonEmptySubTitleTapFunction: () {
                  //     Navigator.pop(context); // 현재 다이얼로그를 닫음
                  //   },
                  // );
                  // logger.d("onTap menuModel ${menu.toFormattedJson()}");

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdateMenuScreen(menuCategoryId: menu.storeMenuCategoryId, menuId: menu.menuId)),
                  );
                },
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(SGSpacing.p4),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                       menu.menuPictureURL.isEmpty ?
                          Container(
                            width: SGSpacing.p18,
                            height: SGSpacing.p18,
                            child: Image.asset("assets/images/default_poke.png")
                          ) :  Image.network(
                              menu.menuPictureURL,
                              width: SGSpacing.p18,
                              height: SGSpacing.p18,
                              fit: BoxFit.cover,
                            ),
                          if (menu.soldOutStatus == 1)
                            Container(
                              width: SGSpacing.p18,
                              height: SGSpacing.p18,
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
                      ],
                    ),
                  ),
                  SizedBox(width: SGSpacing.p4),
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 161, child: SGTypography.body(menu.menuName, size: FontSize.normal, weight: FontWeight.w700, overflow: TextOverflow.ellipsis)),
                    SizedBox(height: SGSpacing.p2),
                    SGTypography.body("${menu.price.toKoreanCurrency}원", size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                  ]),
                ]),
              ),
            ]))
      ]),
      SizedBox(height: SGSpacing.p3),
    ]);
  }
}
