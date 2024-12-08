import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/cuisine_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/menu/updatemenucategory/screen.dart';

import '../model.dart';

class MenuCategoryCard extends StatelessWidget {

  final MenuCategoryModel menuCategory;

  const MenuCategoryCard({super.key, required this.menuCategory});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      MultipleInformationBox(children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateMenuCategoryScreen(menuCategoryModel: menuCategory)));
          },
          child: Row(mainAxisSize: MainAxisSize.max, children: [
            SGTypography.body(menuCategory.menuCategoryName, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(width: SGSpacing.p1),
            const Icon(Icons.edit, size: FontSize.small),
          ]),
        ),
        ...menuCategory.menuList.mapIndexed((idx, cuisine) => Column(mainAxisSize: MainAxisSize.min, children: [
              if (idx != 0) ...[
                SizedBox(height: SGSpacing.p4),
                Divider(height: 1, color: SGColors.line1, thickness: 1),
              ],
              SizedBox(height: SGSpacing.p4),
              GestureDetector(
                onTap: () {
                  showFailDialogWithImage(
                    context: context,
                    mainTitle: "해당 메뉴는 삭제된 메뉴입니다.",
                    onTapFunction: () {
                      Navigator.pop(context); // 현재 다이얼로그를 닫음
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CuisineScreen()),
                      );
                    },
                    onNonEmptySubTitleTapFunction: () {
                      Navigator.pop(context); // 현재 다이얼로그를 닫음
                    },
                  );
                },
                child: Row(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(SGSpacing.p4), child: Image.network(cuisine.menuPictureURL, width: SGSpacing.p18, height: SGSpacing.p18)),
                  SizedBox(width: SGSpacing.p4),
                  Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SGTypography.body(cuisine.menuName, size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p2),
                    SGTypography.body("${cuisine.price.toKoreanCurrency}원", size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                  ]),
                ]),
              ),
            ]))
      ]),
      SizedBox(height: SGSpacing.p3),
    ]);
  }
}
