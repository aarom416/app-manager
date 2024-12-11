import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/options/updateoptioncategory/set_applied_menus_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/options/updateoptioncategory/update_menuoptions_screen.dart';

import '../../../../../../core/screens/numeric_range_edit_screen.dart';
import '../../../../../../main.dart';
import '../../model.dart';
import '../../provider.dart';

class UpdateOptionCategoryScreen extends ConsumerStatefulWidget {
  final MenuOptionCategoryModel optionCategoryModel;

  const UpdateOptionCategoryScreen({super.key, required this.optionCategoryModel});

  @override
  ConsumerState<UpdateOptionCategoryScreen> createState() => _UpdateOptionCategoryScreenState();
}

class _UpdateOptionCategoryScreenState extends ConsumerState<UpdateOptionCategoryScreen> {
  late MenuOptionCategoryModel optionCategoryModel;
  late List<MenuModel> appliedMenus = [];

  @override
  void initState() {
    super.initState();
    optionCategoryModel = widget.optionCategoryModel;
  }

  bool get soldOut {
    return optionCategoryModel.menuOptions.any((option) => option.soldOutStatus == 1);
  }

  String get selectionType {
    return (optionCategoryModel.essentialStatus == 1) ? "(필수)" : "(선택 최대 ${optionCategoryModel.maxChoice}개)";
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);
    appliedMenus = state.menuCategoryList.expand((menuCategory) => menuCategory.menuList).where((menu) => menu.menuCategoryOptions.any((option) => option.menuOptionCategoryId == optionCategoryModel.menuOptionCategoryId)).toSet().toList();

    return Scaffold(
      key: ValueKey(state.menuOptionsDataModel.toFormattedJson()),
      appBar: AppBarWithLeftArrow(title: "옵션 카테고리 관리"),
      body: SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          SGTypography.body("곡물 베이스 선택", weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p3),
          MultipleInformationBox(children: [
            // --------------------------- 옵션 필수 여부 ---------------------------
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SGTypography.body("옵션 필수 여부", size: FontSize.normal, weight: FontWeight.w600),
              const Spacer(),
              SGSwitch(
                value: optionCategoryModel.essentialStatus == 1,
                onChanged: (value) {
                  provider.updateMenuOptionCategoryEssential(optionCategoryModel.menuOptionCategoryId, value ? 1 : 0).then((success) {
                    logger.d("updateMenuOptionCategoryEssential success $success $value");
                    if (success) {
                      setState(() {
                        optionCategoryModel = optionCategoryModel.copyWith(essentialStatus: value ? 1 : 0);
                      });
                    }
                  });
                },
              ),
            ]),
            SizedBox(height: SGSpacing.p3 + SGSpacing.p05),

            // --------------------------- 옵션 선택 개수 설정 ---------------------------
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NumericRangeEditScreen(
                          title: "옵션 선택 개수 설정",
                          description: "옵션 선택 개수를 설정해주세요.",
                          minValue: optionCategoryModel.minChoice,
                          maxValue: optionCategoryModel.maxChoice,
                          onConfirm: (minValue, maxValue) {
                            provider
                                .updateMenuOptionCategoryMaxChoice(
                              optionCategoryModel.menuOptionCategoryId,
                              minValue,
                              maxValue,
                            )
                                .then((success) {
                              logger.i("updateMenuOptionCategoryMaxChoice success minValue $minValue, maxValue $maxValue");
                              if (success) {
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            });
                          },
                        )));
              },
              child: SGContainer(
                borderColor: SGColors.line2,
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                child: Row(children: [
                  SGTypography.body("옵션 선택 개수 설정", size: FontSize.small),
                  SizedBox(width: SGSpacing.p1),
                  Icon(Icons.edit, size: FontSize.small),
                  Spacer(),
                  SGTypography.body("최소${optionCategoryModel.minChoice}개, 최대 ${optionCategoryModel.maxChoice}개", size: FontSize.small)
                ]),
              ),
            ),
          ]), // end of 곡물 베이스 선택

          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

          // --------------------------- 품절 ---------------------------
          SGContainer(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
              borderColor: SGColors.line2,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("품절", size: FontSize.normal),
                const Spacer(),
                SGSwitch(
                  value: soldOut,
                  onChanged: (value) {
                    provider.updateMenuOptionCategorySoldOutStatus(optionCategoryModel.menuOptionCategoryId, value ? 1 : 0).then(
                      (success) {
                        logger.d("updateMenuOptionCategorySoldOutStatus success $success $value");
                        if (success) {
                          setState(() {
                            optionCategoryModel = optionCategoryModel.copyWith(menuOptions: optionCategoryModel.menuOptions.map((menuOption) => menuOption.copyWith(soldOutStatus: value ? 1 : 0)).toList());
                            logger.d("updateMenuOptionCategorySoldOutStatus success setState ${optionCategoryModel.toFormattedJson()}");
                          });
                        }
                      },
                    );
                  },
                ),
              ])),
          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

          // --------------------------- MenuOptionCategoryModel 편집 ---------------------------
          MultipleInformationBox(
            children: [
              GestureDetector(
                onTap: () async {
                  final updatedOptionCategoryModel = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateMenuOptionsScreen(
                        menuOptionCategoryModel: widget.optionCategoryModel,
                      ),
                    ),
                  );
                  if (updatedOptionCategoryModel != null && mounted) {
                    setState(() {
                      optionCategoryModel = updatedOptionCategoryModel;
                    });
                  }
                },
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  SGTypography.body(optionCategoryModel.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p1),
                  SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p1),
                  const Icon(Icons.edit, size: FontSize.small),
                ]),
              ),
              ...optionCategoryModel.menuOptions
                  .mapIndexed((index, option) => [
                        if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                        DataTableRow(left: option.optionContent ?? "", right: "${option.price.toKoreanCurrency}원"),
                      ])
                  .flattened
            ],
          ),
          SizedBox(height: SGSpacing.p7 + SGSpacing.p05),

          // --------------------------- 옵션 카테고리 사용 메뉴 ---------------------------
          MultipleInformationBox(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SetAppliedMenusScreen(
                          storeMenuDTOList: state.storeMenuDTOList,
                          appliedMenus: appliedMenus,
                          onConfirm: (appliedMenus) => {
                            provider.updateMenuOptionCategoryUseMenu(optionCategoryModel.menuOptionCategoryId,this.appliedMenus, appliedMenus).then(
                              (success) {
                                logger.d("updateMenuOptionCategoryUseMenu success $success");
                                if (success) {
                                  setState(() {
                                    this.appliedMenus = appliedMenus;
                                    logger.d("updateMenuOptionCategorySoldOutStatus success setState ${optionCategoryModel.toFormattedJson()}");
                                  });
                                }
                              },
                            )
                          },
                        )));
              },
              child: Row(
                children: [
                  SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p2),
                  const Icon(Icons.edit, size: FontSize.small),
                ],
              ),
            ),
            ...appliedMenus
                .mapIndexed((index, cuisine) => [
                      if (index == 0)
                        SizedBox(height: SGSpacing.p4)
                      else ...[
                        SizedBox(height: SGSpacing.p4),
                        Divider(thickness: 1, height: 1, color: SGColors.line1),
                        SizedBox(height: SGSpacing.p4),
                      ],
                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          child: Image.network(
                            cuisine.menuPictureURL,
                            width: SGSpacing.p18,
                            height: SGSpacing.p18,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: SGSpacing.p4),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SGTypography.body(cuisine.menuName, size: FontSize.normal, weight: FontWeight.w700),
                          SizedBox(height: SGSpacing.p2),
                          SGTypography.body("${cuisine.price.toKoreanCurrency}원", size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray4),
                        ])
                      ])
                    ])
                .flattened
          ]),
          SizedBox(height: SGSpacing.p4),

          // --------------------------- 옵션 카테고리 삭제 ---------------------------
          GestureDetector(
            onTap: () {
              showSGDialog(
                  context: context,
                  childrenBuilder: (ctx) => [
                        Center(child: SGTypography.body("옵션 카테고리를\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                        SizedBox(height: SGSpacing.p5 / 2),
                        SGTypography.body("옵션 카테고리 내 옵션도 전부 삭제됩니다.", color: SGColors.gray4),
                        SizedBox(height: SGSpacing.p5),
                        Row(children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                provider.deleteMenuOptionCategory(optionCategoryModel).then(
                                  (success) {
                                    logger.d("deleteMenuOptionCategory success $success");
                                    if (mounted) {
                                      Navigator.of(ctx).pop();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                );
                              },
                              child: SGContainer(
                                color: SGColors.gray3,
                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                child: Center(
                                  child: SGTypography.body("확인", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: SGSpacing.p2),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(ctx).pop();
                              },
                              child: SGContainer(
                                color: SGColors.primary,
                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                child: Center(
                                  child: SGTypography.body("취소", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ]);
            },
            child: SGContainer(
                color: SGColors.warningRed.withOpacity(0.08),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p2),
                child: Center(
                  child: SGTypography.body("옵션 카테고리 삭제", color: SGColors.warningRed, weight: FontWeight.w600, size: FontSize.small),
                )),
          ),
          SizedBox(height: SGSpacing.p32),
        ]),
      ),
    );
  }
}
