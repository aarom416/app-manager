import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import 'model.dart';


void showCuisineSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<MenuModel> cuisines,
  required void Function(List<MenuModel>) onSelect,
  required List<MenuModel> selectedCuisines,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return _CuisineSelectionBottomSheet(
        title: title,
        cuisines: cuisines,
        onSelect: onSelect,
        selectedCuisines: selectedCuisines,
      );
    },
  );
}

class _CuisineSelectionBottomSheet extends StatefulWidget {
  final String title;
  final List<MenuModel> cuisines;
  final void Function(List<MenuModel>) onSelect;
  final List<MenuModel> selectedCuisines;

  const _CuisineSelectionBottomSheet({
    super.key,
    required this.title,
    required this.cuisines,
    required this.onSelect,
    required this.selectedCuisines,
  });

  @override
  State<_CuisineSelectionBottomSheet> createState() => _CuisineSelectionBottomSheetState();
}

class _CuisineSelectionBottomSheetState extends State<_CuisineSelectionBottomSheet> {
  late List<MenuModel> selectedCuisines;

  List<int?> get selectedCuisineIds => selectedCuisines.map((e) => e.menuId).toList();

  @override
  void initState() {
    super.initState();
    selectedCuisines = widget.selectedCuisines;
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
                          hintText: "메뉴명 검색",
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
                      if (selectedCuisineIds.contains(widget.cuisines[idx].menuId)) {
                        setState(() {
                          selectedCuisines.remove(widget.cuisines[idx]);
                        });
                      } else {
                        setState(() {
                          selectedCuisines.add(widget.cuisines[idx]);
                        });
                        print(selectedCuisineIds);
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
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(SGSpacing.p4),
                                  child: Image.network(widget.cuisines[idx].menuPictureURL,
                                      width: SGSpacing.p18, height: SGSpacing.p18)),
                              SizedBox(width: SGSpacing.p3),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SGTypography.body(widget.cuisines[idx].menuName,
                                      color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                                  SizedBox(height: SGSpacing.p2),
                                  SGTypography.body("${widget.cuisines[idx].price.toKoreanCurrency}원",
                                      color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),
                          if (selectedCuisineIds.contains(widget.cuisines[idx].menuId))
                            Image.asset("assets/images/checkbox-on.png", width: 24, height: 24)
                          else
                            Image.asset("assets/images/checkbox-off.png", width: 24, height: 24)
                        ],
                      ),
                    ),
                  ),
              separatorBuilder: (ctx, _) => SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              itemCount: widget.cuisines.length),
        ),
      ),
      SizedBox(height: SGSpacing.p2),
      SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
          child: GestureDetector(
            onTap: () {
              widget.onSelect(selectedCuisines);
              Navigator.of(context).pop();
            },
            child: SGContainer(
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                width: double.infinity,
                color: selectedCuisines.isEmpty ? SGColors.gray3 : SGColors.primary,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: SGTypography.body("추가하기",
                            color: Colors.white, weight: FontWeight.w700, size: FontSize.medium)),
                    if (selectedCuisines.isNotEmpty) ...[
                      SizedBox(width: SGSpacing.p1),
                      CircleAvatar(
                          radius: SGSpacing.p5 / 2,
                          backgroundColor: SGColors.white,
                          child: Center(
                              child: SGTypography.body(selectedCuisines.length.toString(), color: SGColors.primary)))
                    ]
                  ],
                )),
          )),
      SizedBox(height: SGSpacing.p4),
    ]);
  }
}
