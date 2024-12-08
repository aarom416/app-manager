import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../model.dart';
import 'cuisine_option_category_screen.dart';
import 'new_cuisine_option_category_screen.dart';

List<MenuOptionCategoryModel> categoryOptions = [
  MenuOptionCategoryModel(
      menuOptionCategoryName: "곡물 베이스 선택",
      menuOptions: [
        MenuOptionModel(optionContent: "곡물 베이스 선택", price: 0),
        MenuOptionModel(optionContent: "오곡 베이스", price: 0),
      ],
      essentialStatus: 1),
  MenuOptionCategoryModel(menuOptionCategoryName: "토핑 선택", maxChoice: 2, menuOptions: [
    MenuOptionModel(optionContent: "훈제오리 토핑", price: 0),
    MenuOptionModel(optionContent: "연어 토핑", price: 500),
    MenuOptionModel(optionContent: "우삼겹 토핑", price: 3000),
  ]),
];

class OptionsTab extends StatefulWidget {
  OptionsTab({
    super.key,
  });

  @override
  State<OptionsTab> createState() => _OptionsTabState();
}

class _OptionsTabState extends State<OptionsTab> {
  List<SelectionOption<String>> options = [
    SelectionOption<String>(value: "판매 상태 전체", label: "판매 상태 전체"),
    SelectionOption<String>(value: "판매 중", label: "판매 중"),
    SelectionOption<String>(value: "품절", label: "품절"),
  ];

  String selectedOption = "판매 상태 전체";

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
                    decoration: InputDecoration(isDense: true, hintText: "옵션명을 입력해주세요", hintStyle: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5, fontWeight: FontWeight.w400), border: InputBorder.none)))
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
                          });
                        },
                        selected: selectedOption);
                  },
                  child: SGContainer(
                      borderColor: SGColors.line2,
                      borderRadius: BorderRadius.circular(SGSpacing.p20),
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p4).copyWith(right: SGSpacing.p3),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SGTypography.body(selectedOption, size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray5),
                        SizedBox(width: SGSpacing.p1),
                        Image.asset("assets/images/dropdown-arrow.png", width: SGSpacing.p4, height: SGSpacing.p4)
                      ]))),
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
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewCuisineOptionCategoryScreen()));
          },
          child: SGContainer(
              color: SGColors.white,
              borderRadius: BorderRadius.circular(SGSpacing.p3 / 2),
              borderColor: SGColors.line3,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p2, horizontal: SGSpacing.p3),
              child: Row(children: [
                ColorFiltered(colorFilter: ColorFilter.mode(SGColors.gray4, BlendMode.modulate), child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3)),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("옵션 카테고리 추가", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4)
              ])),
        )
      ]),
      SizedBox(height: SGSpacing.p4),
      ...categoryOptions
          .map((category) => [
                _OptionCategoryCard(category: category),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              ])
          .flattened,
    ]);
  }
}

class _OptionCategoryCard extends StatefulWidget {
  final MenuOptionCategoryModel category;

  const _OptionCategoryCard({super.key, required this.category});

  @override
  State<_OptionCategoryCard> createState() => _OptionCategoryCardState();
}

class _OptionCategoryCardState extends State<_OptionCategoryCard> {
  String get selectionType {
    if (widget.category.essentialStatus == 1) return "(필수)";
    return "(선택 최대 ${widget.category.maxChoice ?? 0}개)";
  }

  bool isExpanded = false;

  List<String> hardcodedMenus = ["연어 샐러드", "훈제 오리 샐러드", "탄단지 샐러드"];

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuisineOptionCategoryScreen()));
            },
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SGTypography.body(widget.category.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              Icon(Icons.edit, size: FontSize.small),
            ]),
          ),
        ],
      ),
      ...widget.category.menuOptions
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.optionContent ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened,
      SizedBox(height: SGSpacing.p5),
      SGContainer(
        borderRadius: BorderRadius.circular(SGSpacing.p2),
        color: SGColors.gray1,
        padding: EdgeInsets.symmetric(vertical: SGSpacing.p3 + SGSpacing.p05, horizontal: SGSpacing.p4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            SGTypography.body("이 옵션을 사용하는 메뉴 2개", size: FontSize.small),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: SGTypography.body(isExpanded ? "접기" : "펼치기", color: SGColors.primary, weight: FontWeight.w500, size: FontSize.small),
            ),
          ]),
          SizedBox(height: SGSpacing.p05),
          if (isExpanded) ...[
            SizedBox(height: SGSpacing.p05),
            ...hardcodedMenus
                .map((menu) => [
                      SizedBox(height: SGSpacing.p2),
                      SGTypography.body(menu, size: FontSize.small, color: SGColors.gray4),
                    ])
                .flattened,
          ] else ...[
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(hardcodedMenus.sublist(0, 2).join(", "), size: FontSize.small, color: SGColors.gray4),
          ]
        ]),
      )
    ]);
  }
}
