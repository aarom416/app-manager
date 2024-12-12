import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../model.dart';
import '../../options/addcategory/screen.dart';

void showMenuOptionCategorySelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<MenuOptionCategoryModel> menuOptionCategories,
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
        menuOptionCategories: menuOptionCategories,
        onSelect: onSelect,
        selectedMenuOptionCategories: selectedMenuOptionCategories,
      );
    },
  );
}

class _MenuOptionCategorySelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<MenuOptionCategoryModel> menuOptionCategories;
  final void Function(List<MenuOptionCategoryModel>) onSelect;
  final List<MenuOptionCategoryModel> selectedMenuOptionCategories;

  const _MenuOptionCategorySelectionBottomSheet({
    required this.title,
    required this.menuOptionCategories,
    required this.onSelect,
    required this.selectedMenuOptionCategories,
  });

  @override
  State<_MenuOptionCategorySelectionBottomSheet> createState() => _MenuOptionCategorySelectionBottomSheetState();
}

class _MenuOptionCategorySelectionBottomSheetState extends State<_MenuOptionCategorySelectionBottomSheet> {
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
    List<MenuOptionCategoryModel> selectableMenuOptionCategories = widget.menuOptionCategories.where((menuOptionCategory) {
      return categoryNameQuery == "" || menuOptionCategory.menuOptionCategoryName.contains(categoryNameQuery);
    }).toList();

    return Container(
      height: MediaQuery.of(context).viewInsets.bottom,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SGContainer(
          color: Colors.transparent,
          padding: EdgeInsets.all(SGSpacing.p2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Container()),
              SGTypography.body(widget.title, size: FontSize.medium, weight: FontWeight.w700),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      child: IconButton(
                          iconSize: SGSpacing.p6,
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })),
                ],
              )),
            ],
          ),
        ),
        SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
          child: SGContainer(
              color: SGColors.gray1,
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
                            hintText: "옵션 카테고리명 검색",
                            hintStyle:
                                TextStyle(fontSize: FontSize.normal, color: SGColors.gray3, fontWeight: FontWeight.w400),
                            border: InputBorder.none),
                      onChanged: (categoryNameQuery) {
                        setState(() {
                          this.categoryNameQuery = categoryNameQuery;
                        });
                      },
                    )
                )
              ])),
        ),
        SizedBox(height: SGSpacing.p4),
        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(bottom: SGSpacing.p4),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (ctx, idx) => GestureDetector(
                      onTap: () {
                        // onSelect(options[idx].value);
                        // Navigator.of(context).pop();
                        if (selectedCuisineOptionCategoryIds.contains(selectableMenuOptionCategories[idx].menuOptionCategoryId)) {
                          setState(() {
                            selectedMenuOptionCategories.remove(selectableMenuOptionCategories[idx]);
                          });
                        } else {
                          setState(() {
                            selectedMenuOptionCategories.add(selectableMenuOptionCategories[idx]);
                          });
                          print(selectedCuisineOptionCategoryIds);
                        }
                      },
                      child: SGContainer(
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SGTypography.body(selectableMenuOptionCategories[idx].menuOptionCategoryName,
                                        color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                                    SizedBox(height: SGSpacing.p1),
                                    ...selectableMenuOptionCategories[idx].menuOptions
                                        .map((e) => [
                                              SizedBox(height: SGSpacing.p2),
                                              SGTypography.body("${e.optionContent} : ${e.price!.toKoreanCurrency}원",
                                                  color: SGColors.gray4, size: FontSize.small)
                                            ])
                                        .flattened
                                        .toList(),
                                  ],
                                ),
                              ],
                            ),
                            if (selectedCuisineOptionCategoryIds.contains(selectableMenuOptionCategories[idx].menuOptionCategoryId))
                              Image.asset("assets/images/checkbox-on.png", width: 24, height: 24)
                            else
                              Image.asset("assets/images/checkbox-off.png", width: 24, height: 24)
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (ctx, _) => SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                itemCount: selectableMenuOptionCategories.length),
          ),
        ),
        SizedBox(height: SGSpacing.p2),
        InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddOptionCategoryScreen()));
          },
          child: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
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
        ),
        SizedBox(height: SGSpacing.p4),
        SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: GestureDetector(
              onTap: () {
                widget.onSelect(selectedMenuOptionCategories);
                Navigator.of(context).pop();
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                  width: double.infinity,
                  color: selectedMenuOptionCategories.isEmpty ? SGColors.gray3 : SGColors.primary,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: SGTypography.body("추가하기",
                              color: Colors.white, weight: FontWeight.w700, size: FontSize.medium)),
                      if (selectedMenuOptionCategories.isNotEmpty) ...[
                        SizedBox(width: SGSpacing.p1),
                        CircleAvatar(
                            radius: SGSpacing.p5 / 2,
                            backgroundColor: SGColors.white,
                            child: Center(
                                child: SGTypography.body(selectedMenuOptionCategories.length.toString(),
                                    color: SGColors.primary)))
                      ]
                    ],
                  )),
            )),
        SizedBox(height: SGSpacing.p4),
      ]),
    );
  }
}
