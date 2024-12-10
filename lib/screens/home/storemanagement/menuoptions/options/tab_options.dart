import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../main.dart';
import '../model.dart';
import '../provider.dart';
import 'updateoptioncategory/screen.dart';
import 'addcategory/screen.dart';

class OptionsTab extends ConsumerStatefulWidget {
  const OptionsTab({super.key});

  @override
  ConsumerState<OptionsTab> createState() => _OptionsTabState();
}

class _OptionsTabState extends ConsumerState<OptionsTab> {
  List<SelectionOption<int>> soldOutStatusOptions = [
    SelectionOption<int>(value: -1, label: "판매 상태 전체"),
    SelectionOption<int>(value: 0, label: "판매 중"),
    SelectionOption<int>(value: 1, label: "품절"),
  ];

  late List<MenuOptionCategoryModel> optionCategoryList;
  late int selectedSoldOutStatusOptionValue;
  late String selectedSoldOutStatusOptionLabel;
  late String optionContentQuery;
  late TextEditingController optionContentQueryController;

  @override
  void initState() {
    super.initState();
    selectedSoldOutStatusOptionValue = soldOutStatusOptions[0].value;
    selectedSoldOutStatusOptionLabel = soldOutStatusOptions[0].label;
    optionContentQuery = "";
    optionContentQueryController = TextEditingController();
  }

  /// 검색조건, 정렬 option 에 따른 optionCategoryList
  List<MenuOptionCategoryModel> getFilteredOptionCategories() {
    return optionCategoryList
        .map((category) {
          // 메뉴 필터링
          final filteredOptions = category.menuOptions.where((option) {
            final isContentMatch = optionContentQuery == "" || option.optionContent.contains(optionContentQuery); // optionContentQuery은 like 필터
            final isSoldOutMatch = selectedSoldOutStatusOptionValue == -1 || option.soldOutStatus == selectedSoldOutStatusOptionValue; // -1이면 조건 무시
            return isContentMatch && isSoldOutMatch;
          }).toList();

          // 필터링된 옵션으로 새로운 category 생성
          return category.copyWith(menuOptions: filteredOptions);
        })
        .whereType<MenuOptionCategoryModel>() // null 제거
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);
    optionCategoryList = state.menuOptionCategoryDTOList;
    logger.d("optionContentQuery $optionContentQuery");
    logger.d("selectedSoldOutStatusOptionValue $selectedSoldOutStatusOptionValue");
    logger.d("selectedSoldOutStatusOptionLabel $selectedSoldOutStatusOptionLabel");
    List<MenuOptionCategoryModel> filterOptionCategories = getFilteredOptionCategories();
    logger.d("filterOptionCategories ${filterOptionCategories.toFormattedJson()}");

    return Column(children: [
      SizedBox(height: SGSpacing.p3),

      // --------------------------- 옵션명 검색 ---------------------------
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
              controller: optionContentQueryController,
              style: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5),
              decoration: InputDecoration(
                  isDense: true, hintText: "옵션명을 입력해주세요", hintStyle: TextStyle(fontSize: FontSize.normal, color: SGColors.gray5, fontWeight: FontWeight.w400), border: InputBorder.none),
              onChanged: (optionContentQuery) {
                setState(() {
                  this.optionContentQuery = optionContentQuery;
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
                            optionContentQuery = "";
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
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: ReloadButton(onReload: () {
              Future.microtask(() {
                ref.read(menuOptionsNotifierProvider.notifier).getMenuOptionInfo();
              });
            }))
      ]),
      SizedBox(height: SGSpacing.p4),

      // --------------------------- 옵션 카테고리 추가 button ---------------------------
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddOptionCategoryScreen()));
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

      // --------------------------- 단품 메뉴 list ---------------------------
      ...filterOptionCategories
          .map((optionCategory) => [
                _OptionCategoryCard(optionCategory: optionCategory, menuCategoryList: state.menuCategoryList),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              ])
          .flattened,
      SizedBox(height: SGSpacing.p10),
    ]);
  }
}

class _OptionCategoryCard extends StatefulWidget {
  final MenuOptionCategoryModel optionCategory;
  final List<MenuCategoryModel> menuCategoryList;

  const _OptionCategoryCard({super.key, required this.optionCategory, required this.menuCategoryList});

  @override
  State<_OptionCategoryCard> createState() => _OptionCategoryCardState();
}

class _OptionCategoryCardState extends State<_OptionCategoryCard> {
  late String selectionType;
  late List<MenuModel> appliedMenus;
  late bool isExpanded = false;
  late bool soldOut = false;

  @override
  void initState() {
    super.initState();
    selectionType = (widget.optionCategory.essentialStatus == 1) ? (soldOut ? "(품절)" : "(필수)") : "(선택 최대 ${widget.optionCategory.maxChoice}개)";
    appliedMenus = widget.menuCategoryList
        .expand((menuCategory) => menuCategory.menuList)
        .where((menu) => menu.menuCategoryOptions.any((option) => option.menuOptionCategoryId == widget.optionCategory.menuOptionCategoryId)) // 조건 필터링
        .toSet() // 중복 제거
        .toList();
    isExpanded = false;
    soldOut = widget.optionCategory.menuOptions.any((option) => option.soldOutStatus == 1);
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateOptionCategoryScreen()));
            },
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SGTypography.body(widget.optionCategory.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body(selectionType, size: FontSize.small, color: soldOut ? SGColors.gray2 : SGColors.primary, weight: FontWeight.w600),
              SizedBox(width: SGSpacing.p1),
              const Icon(Icons.edit, size: FontSize.small),
            ]),
          ),
        ],
      ),
      ...widget.optionCategory.menuOptions
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
            SGTypography.body("이 옵션을 사용하는 메뉴 ${appliedMenus.length}개", size: FontSize.small),
            Spacer(),
            appliedMenus.length > 1
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: SGTypography.body(
                      isExpanded ? "접기" : "펼치기",
                      color: SGColors.primary,
                      weight: FontWeight.w500,
                      size: FontSize.small,
                    ),
                  )
                : const SizedBox.shrink(),
          ]),
          SizedBox(height: SGSpacing.p05),
          if (isExpanded) ...[
            SizedBox(height: SGSpacing.p05),
            ...appliedMenus
                .map((menu) => [
                      SizedBox(height: SGSpacing.p2),
                      SGTypography.body(menu.menuName, size: FontSize.small, color: SGColors.gray4),
                    ])
                .flattened,
          ] else if (appliedMenus.isNotEmpty) ...[
            SizedBox(height: SGSpacing.p2),
            SGTypography.body(appliedMenus.map((menu) => menu.menuName).join(", "), size: FontSize.small, color: SGColors.gray4),
          ]
        ]),
      )
    ]);
  }
}
