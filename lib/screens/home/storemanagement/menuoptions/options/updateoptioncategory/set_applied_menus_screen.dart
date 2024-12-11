import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../menu_selection_bottom_sheet.dart';
import '../../model.dart';

class SetAppliedMenusScreen extends StatefulWidget {
  final List<MenuModel> storeMenuDTOList;
  final List<MenuModel> appliedMenus;
  final Function(List<MenuModel>) onConfirm;

  const SetAppliedMenusScreen({
    super.key,
    required this.storeMenuDTOList,
    required this.appliedMenus,
    required this.onConfirm,
  });

  @override
  State<SetAppliedMenusScreen> createState() => _SetAppliedMenusScreenState();
}

class _SetAppliedMenusScreenState extends State<SetAppliedMenusScreen> {
  late List<MenuModel> appliedMenus;

  @override
  void initState() {
    super.initState();
    appliedMenus = widget.appliedMenus;
  }

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
                          widget.onConfirm(appliedMenus);
                          Navigator.pop(ctx);
                          Navigator.of(context).pop();
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
                },
                label: "변경하기")),
        body: SGContainer(
            borderWidth: 0,
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("고객은 해당 메뉴 주문 시 다음 옵션 카테고리를\n선택할 수 있습니다.", color: SGColors.gray4),
              SizedBox(height: SGSpacing.p3),
              ...appliedMenus
                  .mapIndexed((index, cuisine) => [
                        _MenuModelCard(
                            cuisine: cuisine,
                            onRemove: () {
                              final updatedAppliedMenus = List<MenuModel>.from(appliedMenus);
                              updatedAppliedMenus.removeAt(index);
                              setState(() {
                                appliedMenus = updatedAppliedMenus;
                              });
                            }),
                        SizedBox(height: SGSpacing.p5 / 2),
                      ])
                  .flattened,
              GestureDetector(
                  onTap: () {
                    showSelectableMenuModelsBottomSheet(
                        context: context,
                        title: "메뉴 추가",
                        menuModels: widget.storeMenuDTOList,
                        onSelect: (selectedMenuList) {
                          setState(() {
                            appliedMenus = selectedMenuList.toList()..sort((a, b) => a.menuName.compareTo(b.menuName));
                          });
                        },
                        selectedMenus: appliedMenus);
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
                        SGTypography.body("메뉴 추가하기", size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                      ])))),
            ])));
  }
}

class _MenuModelCard extends StatelessWidget {
  final MenuModel cuisine;
  final VoidCallback onRemove;

  const _MenuModelCard({super.key, required this.cuisine, required this.onRemove});

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

