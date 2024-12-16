import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../model.dart';
import '../../options/addcategory/screen.dart';
import '../../provider.dart';

void showMenuOptionCategorySelectionBottomSheet({
  required BuildContext context,
  required String title,
  required void Function(List<MenuOptionCategoryModel>) onSelect,
  required List<MenuOptionCategoryModel> selectedMenuOptionCategories,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return _MenuOptionCategorySelectionBottomSheet(
        title: title,
        onSelect: onSelect,
        selectedMenuOptionCategories: selectedMenuOptionCategories,
      );
    },
  );
}

class _MenuOptionCategorySelectionBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final void Function(List<MenuOptionCategoryModel>) onSelect;
  final List<MenuOptionCategoryModel> selectedMenuOptionCategories;

  const _MenuOptionCategorySelectionBottomSheet({
    required this.title,
    required this.onSelect,
    required this.selectedMenuOptionCategories,
  });

  @override
  ConsumerState<_MenuOptionCategorySelectionBottomSheet> createState() => _MenuOptionCategorySelectionBottomSheetState();
}

class _MenuOptionCategorySelectionBottomSheetState extends ConsumerState<_MenuOptionCategorySelectionBottomSheet> {
  late List<MenuOptionCategoryModel> selectedMenuOptionCategories;
  late String categoryNameQuery;

  List<int?> get selectedCuisineOptionCategoryIds => selectedMenuOptionCategories.map((e) => e.menuOptionCategoryId).toList();

  @override
  void initState() {
    super.initState();
    selectedMenuOptionCategories = widget.selectedMenuOptionCategories;
    categoryNameQuery = "";
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    List<MenuOptionCategoryModel> selectableMenuOptionCategories = state.menuOptionCategoryDTOList.where((menuOptionCategory) {
      return categoryNameQuery == "" || menuOptionCategory.menuOptionCategoryName.contains(categoryNameQuery);
    }).toList();

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constrains) {
        return Container(
          constraints: BoxConstraints(
            minHeight: screenHeight * 0.6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SGContainer(
                color: Colors.transparent,
                padding: EdgeInsets.all(SGSpacing.p2 * (screenWidth / 375)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Container()),
                    SGTypography.body(
                      widget.title,
                      size: FontSize.medium * (screenWidth / 375),
                      weight: FontWeight.w700,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: IconButton(
                              iconSize: SGSpacing.p6 * (screenWidth / 375),
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SGContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: SGSpacing.p4 * (screenWidth / 375),
                ),
                child: SGContainer(
                  color: SGColors.gray1,
                  padding: EdgeInsets.symmetric(
                    vertical: SGSpacing.p2 * (screenHeight / 812),
                    horizontal: SGSpacing.p4 * (screenWidth / 375),
                  ),
                  borderRadius: BorderRadius.circular(SGSpacing.p20 * (screenWidth / 375)),
                  borderColor: SGColors.line1,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/search.png",
                        width: SGSpacing.p6 * (screenWidth / 375),
                        height: SGSpacing.p6 * (screenWidth / 375),
                      ),
                      SizedBox(width: SGSpacing.p2 * (screenWidth / 375)),
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                            fontSize: FontSize.normal * (screenWidth / 375),
                            color: SGColors.gray5,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "옵션 카테고리명 검색",
                            hintStyle: TextStyle(
                              fontSize: FontSize.normal * (screenWidth / 375),
                              color: SGColors.gray3,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (categoryNameQuery) {
                            setState(() {
                              this.categoryNameQuery = categoryNameQuery;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: SGSpacing.p4 * (screenHeight / 812)),
              Container(
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.5, // 반응형 높이
                ),
                child: SGContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4 * (screenWidth / 375),
                  ).copyWith(
                    bottom: SGSpacing.p4 * (screenHeight / 812),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (ctx, idx) => GestureDetector(
                      onTap: () {
                        if (selectedCuisineOptionCategoryIds.contains(
                          selectableMenuOptionCategories[idx].menuOptionCategoryId,
                        )) {
                          setState(() {
                            selectedMenuOptionCategories.remove(
                              selectableMenuOptionCategories[idx],
                            );
                          });
                        } else {
                          setState(() {
                            selectedMenuOptionCategories.add(
                              selectableMenuOptionCategories[idx],
                            );
                          });
                        }
                      },
                      child: SGContainer(
                        color: SGColors.white,
                        borderRadius: BorderRadius.circular(
                          SGSpacing.p4 * (screenWidth / 375),
                        ),
                        boxShadow: SGBoxShadow.large,
                        padding: EdgeInsets.symmetric(
                          vertical: SGSpacing.p4 * (screenHeight / 812),
                          horizontal: SGSpacing.p4 * (screenWidth / 375),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SGTypography.body(
                                      selectableMenuOptionCategories[idx]
                                          .menuOptionCategoryName,
                                      color: SGColors.black,
                                      size: FontSize.normal * (screenWidth / 375),
                                      weight: FontWeight.w700,
                                    ),
                                    SizedBox(height: SGSpacing.p1 * (screenHeight / 812)),
                                    ...selectableMenuOptionCategories[idx]
                                        .menuOptions
                                        .map(
                                          (e) => SGTypography.body(
                                        "${e.optionContent} : ${e.price!.toKoreanCurrency}원",
                                        color: SGColors.gray4,
                                        size: FontSize.small * (screenWidth / 375),
                                      ),
                                    )
                                        .toList(),
                                  ],
                                ),
                              ],
                            ),
                            if (selectedCuisineOptionCategoryIds.contains(
                              selectableMenuOptionCategories[idx]
                                  .menuOptionCategoryId,
                            ))
                              Image.asset(
                                "assets/images/checkbox-on.png",
                                width: 24 * (screenWidth / 375),
                                height: 24 * (screenWidth / 375),
                              )
                            else
                              Image.asset(
                                "assets/images/checkbox-off.png",
                                width: 24 * (screenWidth / 375),
                                height: 24 * (screenWidth / 375),
                              ),
                          ],
                        ),
                      ),
                    ),
                    separatorBuilder: (ctx, _) => SizedBox(
                      height: (SGSpacing.p2 + SGSpacing.p05) * (screenHeight / 812),
                    ),
                    itemCount: selectableMenuOptionCategories.length,
                  ),
                ),
              ),
              SizedBox(height: SGSpacing.p2 * (screenHeight / 812)),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddOptionCategoryScreen(),
                    ),
                  );
                },
                child: SGContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4 * (screenWidth / 375),
                  ),
                  child: SGContainer(
                    color: SGColors.white,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(
                      SGSpacing.p2 * (screenWidth / 375),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4 * (screenWidth / 375),
                      vertical: SGSpacing.p3 * (screenHeight / 812),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/plus.png",
                            width: 12 * (screenWidth / 375),
                            height: 12 * (screenWidth / 375),
                          ),
                          SizedBox(width: SGSpacing.p2 * (screenWidth / 375)),
                          SGTypography.body(
                            "옵션 카테고리 추가",
                            size: FontSize.small * (screenWidth / 375),
                            color: SGColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SGSpacing.p4 * (screenHeight / 812)),
              SGContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: SGSpacing.p4 * (screenWidth / 375),
                ),
                child: GestureDetector(
                  onTap: () {
                    widget.onSelect(selectedMenuOptionCategories);
                    Navigator.of(context).pop();
                  },
                  child: SGContainer(
                    padding: EdgeInsets.symmetric(
                      vertical: SGSpacing.p5 * (screenHeight / 812),
                    ),
                    width: double.infinity,
                    color: selectedMenuOptionCategories.isEmpty
                        ? SGColors.gray3
                        : SGColors.primary,
                    borderRadius: BorderRadius.circular(
                      SGSpacing.p3 * (screenWidth / 375),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SGTypography.body(
                            "추가하기",
                            color: Colors.white,
                            weight: FontWeight.w700,
                            size: FontSize.medium * (screenWidth / 375),
                          ),
                        ),
                        if (selectedMenuOptionCategories.isNotEmpty) ...[
                          SizedBox(width: SGSpacing.p1 * (screenWidth / 375)),
                          CircleAvatar(
                            radius: SGSpacing.p5 * (screenHeight / 812) / 2,
                            backgroundColor: SGColors.white,
                            child: Center(
                              child: SGTypography.body(
                                selectedMenuOptionCategories.length.toString(),
                                color: SGColors.primary,
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: SGSpacing.p6 * (screenHeight / 812)),
            ],
          ),
        );
      },
    );
  }
}
