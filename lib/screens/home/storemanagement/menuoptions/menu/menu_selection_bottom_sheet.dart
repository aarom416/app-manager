import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../model.dart';

void showSelectableMenuModelsBottomSheet({
  required BuildContext context,
  required String title,
  required List<MenuModel> menuModels,
  required void Function(List<MenuModel>) onSelect,
  required List<MenuModel> selectedMenus,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return _SelectableMenuModelsBottomSheet(
        title: title,
        menuModels: menuModels,
        onSelect: onSelect,
        selectedMenus: selectedMenus,
      );
    },
  );
}

class _SelectableMenuModelsBottomSheet extends StatefulWidget {
  final String title;
  final List<MenuModel> menuModels;
  final void Function(List<MenuModel>) onSelect;
  final List<MenuModel> selectedMenus;

  const _SelectableMenuModelsBottomSheet({
    super.key,
    required this.title,
    required this.menuModels,
    required this.onSelect,
    required this.selectedMenus,
  });

  @override
  State<_SelectableMenuModelsBottomSheet> createState() => _SelectableMenuModelsBottomSheetState();
}

class _SelectableMenuModelsBottomSheetState extends State<_SelectableMenuModelsBottomSheet> {
  late List<MenuModel> selectedMenus;
  late String menuNameQuery;

  List<int?> get selectedCuisineIds => selectedMenus.map((e) => e.menuId).toList();

  @override
  void initState() {
    super.initState();
    selectedMenus = widget.selectedMenus;
    menuNameQuery = "";
  }

  @override
  Widget build(BuildContext context) {
    List<MenuModel> selectableMenus = widget.menuModels.where((menu) {
      return menuNameQuery == "" || menu.menuName.contains(menuNameQuery);
    }).toList();

    return Container(
      height: SGSpacing.p32 * 4 + SGSpacing.p18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  decoration: InputDecoration(isDense: true, hintText: "메뉴명 검색", hintStyle: TextStyle(fontSize: FontSize.normal, color: SGColors.gray3, fontWeight: FontWeight.w400), border: InputBorder.none),
                  onChanged: (menuNameQuery) {
                    setState(() {
                      this.menuNameQuery = menuNameQuery;
                    });
                  },
                ))
              ])),
        ),
        SizedBox(height: SGSpacing.p4),
        Container(
          height: SGSpacing.p24 * 3 + SGSpacing.p12,
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(bottom: SGSpacing.p4),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (ctx, idx) => GestureDetector(
                      onTap: () {
                        // onSelect(options[idx].value);
                        // Navigator.of(context).pop();
                        if (selectedCuisineIds.contains(selectableMenus[idx].menuId)) {
                          setState(() {
                            selectedMenus.remove(selectableMenus[idx]);
                          });
                        } else {
                          setState(() {
                            selectedMenus.add(selectableMenus[idx]);
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
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(SGSpacing.p4),
                                      child: selectableMenus[idx].menuPictureURL.isEmpty ?
                                      Container(
                                          width: SGSpacing.p18,
                                          height: SGSpacing.p18,
                                          child: Image.asset("assets/images/default_poke.png")
                                      ) :  Image.network(
                                        selectableMenus[idx].menuPictureURL,
                                        width: SGSpacing.p18,
                                        height: SGSpacing.p18,
                                        fit: BoxFit.cover,
                                      )
                                    ),
                                  if (selectableMenus[idx].soldOutStatus == 1)
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
                                SizedBox(width: SGSpacing.p3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width <= 320 ? 120 : 159,
                                      child: SGTypography.body(
                                        selectableMenus[idx].menuName,
                                        color: SGColors.black,
                                        size: FontSize.normal,
                                        weight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: SGSpacing.p2),
                                    Container(
                                      width: MediaQuery.of(context).size.width <= 320 ? 120 : 159,
                                      child: SGTypography.body(
                                        "${selectableMenus[idx].price.toKoreanCurrency}원",
                                        color: SGColors.gray4,
                                        size: FontSize.normal,
                                        weight: FontWeight.w400,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (selectedCuisineIds.contains(selectableMenus[idx].menuId)) Image.asset("assets/images/checkbox-on.png", width: 24, height: 24) else Image.asset("assets/images/checkbox-off.png", width: 24, height: 24)
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (ctx, _) => SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                itemCount: selectableMenus.length),
          ),
        ),
        SizedBox(height: SGSpacing.p2),
        SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: GestureDetector(
              onTap: () {
                widget.onSelect(selectedMenus);
                Navigator.of(context).pop();
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                  width: double.infinity,
                  color: selectedMenus.isEmpty ? SGColors.gray3 : SGColors.primary,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: SGTypography.body("추가하기", color: Colors.white, weight: FontWeight.w700, size: FontSize.medium)),
                      if (selectedMenus.isNotEmpty) ...[
                        SizedBox(width: SGSpacing.p1),
                        CircleAvatar(radius: SGSpacing.p5 / 2, backgroundColor: SGColors.white, child: Center(child: SGTypography.body(selectedMenus.length.toString(), color: SGColors.primary)))
                      ]
                    ],
                  )),
            )),
      ]),
    );
  }
}
