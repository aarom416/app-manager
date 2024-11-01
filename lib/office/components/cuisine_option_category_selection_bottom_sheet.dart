import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/new_cuisine_option_category_screen.dart';
import 'package:singleeat/screens/new_cuisine_screen.dart';

void showCuisineOptionCategorySelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<CuisineOptionCategory> cuisineOptionCategories,
  required void Function(List<CuisineOptionCategory>) onSelect,
  required List<CuisineOptionCategory> selectedCuisineOptionCatagories,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return _CuisineOptionCategorySelectionBottomSheet(
        title: title,
        cuisineOptionCategories: cuisineOptionCategories,
        onSelect: onSelect,
        selectedCuisineOptionCatagories: selectedCuisineOptionCatagories,
      );
    },
  );
}

class _CuisineOptionCategorySelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<CuisineOptionCategory> cuisineOptionCategories;
  final void Function(List<CuisineOptionCategory>) onSelect;
  final List<CuisineOptionCategory> selectedCuisineOptionCatagories;

  const _CuisineOptionCategorySelectionBottomSheet({
    super.key,
    required this.title,
    required this.cuisineOptionCategories,
    required this.onSelect,
    required this.selectedCuisineOptionCatagories,
  });

  @override
  State<_CuisineOptionCategorySelectionBottomSheet> createState() => _CuisineOptionCategorySelectionBottomSheetState();
}

class _CuisineOptionCategorySelectionBottomSheetState extends State<_CuisineOptionCategorySelectionBottomSheet> {
  late List<CuisineOptionCategory> selectedCuisineOptionCatagories;

  List<int?> get selectedCuisineOptionCategoryIds => selectedCuisineOptionCatagories.map((e) => e.id).toList();

  @override
  void initState() {
    super.initState();
    selectedCuisineOptionCatagories = widget.selectedCuisineOptionCatagories;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
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
                          border: InputBorder.none)))
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
                      if (selectedCuisineOptionCategoryIds.contains(widget.cuisineOptionCategories[idx].id)) {
                        setState(() {
                          selectedCuisineOptionCatagories.remove(widget.cuisineOptionCategories[idx]);
                        });
                      } else {
                        setState(() {
                          selectedCuisineOptionCatagories.add(widget.cuisineOptionCategories[idx]);
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
                                  SGTypography.body(widget.cuisineOptionCategories[idx].name,
                                      color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                                  SizedBox(height: SGSpacing.p1),
                                  ...widget.cuisineOptionCategories[idx].options
                                      .map((e) => [
                                            SizedBox(height: SGSpacing.p2),
                                            SGTypography.body("${e.name} : ${e.price!.toKoreanCurrency}원",
                                                color: SGColors.gray4, size: FontSize.small)
                                          ])
                                      .flattened
                                      .toList(),
                                ],
                              ),
                            ],
                          ),
                          if (selectedCuisineOptionCategoryIds.contains(widget.cuisineOptionCategories[idx].id))
                            Image.asset("assets/images/checkbox-on.png", width: 24, height: 24)
                          else
                            Image.asset("assets/images/checkbox-off.png", width: 24, height: 24)
                        ],
                      ),
                    ),
                  ),
              separatorBuilder: (ctx, _) => SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              itemCount: widget.cuisineOptionCategories.length),
        ),
      ),
      SizedBox(height: SGSpacing.p2),
      InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewCuisineOptionCategoryScreen()));
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
              widget.onSelect(selectedCuisineOptionCatagories);
              Navigator.of(context).pop();
            },
            child: SGContainer(
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                width: double.infinity,
                color: selectedCuisineOptionCatagories.isEmpty ? SGColors.gray3 : SGColors.primary,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SGTypography.body("추가하기",
                            color: Colors.white, weight: FontWeight.w700, size: FontSize.medium)),
                    if (selectedCuisineOptionCatagories.isNotEmpty) ...[
                      SizedBox(width: SGSpacing.p1),
                      CircleAvatar(
                          radius: SGSpacing.p5 / 2,
                          backgroundColor: SGColors.white,
                          child: Center(
                              child: SGTypography.body(selectedCuisineOptionCatagories.length.toString(),
                                  color: SGColors.primary)))
                    ]
                  ],
                )),
          )),
      SizedBox(height: SGSpacing.p4),
    ]);
  }
}
