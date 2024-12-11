import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
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
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/options/updateoptioncategory/update_menuoptions_screen.dart';

import '../../../../../../core/screens/numeric_range_edit_screen.dart';
import '../../../../../../main.dart';
import '../../model.dart';
import '../../nutrition/nutrition_card.dart';
import '../../provider.dart';

final List<MenuModel> cuisines = [
  MenuModel(
    menuName: "참치 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
    ],
  ),
  MenuModel(
    menuName: "연어 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
    ],
  ),
  MenuModel(
    menuName: "닭가슴살 샐러드",
    price: 13000,
    menuDescription: "곡물 베이스는 기본입니다.",
    menuPictureURL: "https://via.placeholder.com/150",
    menuCategoryOptions: [
      MenuOptionCategoryModel(menuOptionCategoryName: "추가 옵션", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
      MenuOptionCategoryModel(menuOptionCategoryName: "소스", menuOptions: [
        MenuOptionModel(),
        MenuOptionModel(),
        MenuOptionModel(),
      ]),
    ],
  )
];

class UpdateOptionCategoryScreen extends ConsumerStatefulWidget {
  final MenuOptionCategoryModel optionCategoryModel;

  const UpdateOptionCategoryScreen({super.key, required this.optionCategoryModel});

  @override
  ConsumerState<UpdateOptionCategoryScreen> createState() => _UpdateOptionCategoryScreenState();
}

class _UpdateOptionCategoryScreenState extends ConsumerState<UpdateOptionCategoryScreen> {
  late MenuOptionCategoryModel optionCategoryModel;

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
                    provider.updateMenuOptionCategorySoldOutStatus(optionCategoryModel.menuOptionCategoryId, value ? 1 : 0).then((success) {
                      logger.d("updateMenuOptionCategorySoldOutStatus success $success $value");
                      if (success) {
                        setState(() {
                          optionCategoryModel = optionCategoryModel.copyWith(menuOptions: optionCategoryModel.menuOptions.map((menuOption) => menuOption.copyWith(soldOutStatus: value ? 1 : 0)).toList());
                          logger.d("updateMenuOptionCategorySoldOutStatus success setState ${optionCategoryModel.toFormattedJson()}");
                        });
                      }
                    });
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => _EditRelatedCuisineScreen(cuisines: cuisines)));
              },
              child: Row(
                children: [
                  SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p2),
                  Icon(Icons.edit, size: FontSize.small),
                ],
              ),
            ),
            ...cuisines
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
                                Navigator.of(ctx).pop();
                                Navigator.of(context).pop();
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

class _EditRelatedCuisineScreen extends StatefulWidget {
  final List<MenuModel> cuisines;

  const _EditRelatedCuisineScreen({
    super.key,
    required this.cuisines,
  });

  @override
  State<_EditRelatedCuisineScreen> createState() => _EditRelatedCuisineScreenState();
}

class _EditRelatedCuisineScreenState extends State<_EditRelatedCuisineScreen> {
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
                          Navigator.pop(ctx);
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
                  // widget.onSubmit(controller.text);
                  // Navigator.of(context).pop();
                },
                label: "변경하기")),
        body: SGContainer(
            borderWidth: 0,
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("옵션 카테고리 사용 메뉴", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("고객은 해당 메뉴 주문 시 다음 옵션 카테고리를\n선택할 수 있습니다.", color: SGColors.gray4),
              SizedBox(height: SGSpacing.p3),
              ...widget.cuisines
                  .mapIndexed((index, cuisine) => [
                        _SelectedCuisineCard(cuisine: cuisine, onRemove: () {}),
                        SizedBox(height: SGSpacing.p5 / 2),
                      ])
                  .flattened,
              GestureDetector(
                  onTap: () {},
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

class _SelectedCuisineCard extends StatelessWidget {
  final MenuModel cuisine;
  final VoidCallback onRemove;

  const _SelectedCuisineCard({Key? key, required this.cuisine, required this.onRemove}) : super(key: key);

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

class _CuisineOptionEditScreen extends StatefulWidget {
  final MenuOptionModel option;

  _CuisineOptionEditScreen({
    super.key,
    required this.option,
  });

  @override
  State<_CuisineOptionEditScreen> createState() => _CuisineOptionEditScreenState();
}

class _CuisineOptionEditScreenState extends State<_CuisineOptionEditScreen> {
  late String menuPrice = "${(widget.option.price ?? 0).toKoreanCurrency}원";
  bool isSoldOut = false;
  NutritionModel nutrition = NutritionModel(calories: 432, protein: 10, fat: 3, carbohydrate: 12, sugar: 12, natrium: 120, saturatedFat: 8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "옵션 관리"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            MultipleInformationBox(children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextFieldEditScreen(
                            value: widget.option.optionContent ?? "",
                            title: "옵션 변경",
                            onSubmit: (value) {
                              setState(() {
                                // widget.option.optionContent = value;
                              });
                            },
                            buttonText: "저장하기",
                            hintText: "옵션 이름을 입력해주세요",
                          )));
                },
                child: Row(children: [
                  SGTypography.body(widget.option.optionContent ?? "", size: FontSize.normal, weight: FontWeight.w600),
                  SizedBox(width: SGSpacing.p1),
                  Icon(Icons.edit, size: FontSize.small),
                ]),
              ),
              SizedBox(height: SGSpacing.p5),
              DataTableRow(left: "가격", right: "$menuPrice"),
              SizedBox(height: SGSpacing.p5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TextFieldEditScreen(
                            value: menuPrice,
                            title: "옵션 가격 변경",
                            buttonText: "변경하기",
                            hintText: "가격을 입력해주세요.",
                            onSubmit: (value) {
                              setState(() {
                                menuPrice = value;
                              });
                            },
                          )));
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    borderColor: SGColors.line3,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(SGSpacing.p3 / 2),
                    child: Center(child: SGTypography.body("가격 변경", size: FontSize.small, weight: FontWeight.w400, color: SGColors.gray4))),
              )
            ]),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
              borderColor: SGColors.line2,
              color: Colors.white,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("품절", size: FontSize.normal),
                const Spacer(),
                SGSwitch(
                    value: isSoldOut,
                    onChanged: (value) {
                      setState(() {
                        isSoldOut = value;
                      });
                    }),
              ]),
            ),
            SizedBox(height: SGSpacing.p8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              NutritionCard(
                nutrition: nutrition,
                onTap: () {
                  final screenContext = context;
                  Navigator.of(screenContext).push(MaterialPageRoute(
                      builder: (nutritionScreenContext) => _NutritionEditScreen(
                            nutrition: nutrition,
                            onConfirm: (value, quantity, ctx) {
                              showSGDialog(
                                  context: ctx,
                                  childrenBuilder: (_ctx) => [
                                        Center(child: SGTypography.body("영양성분을\n정말 설정하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                                        SizedBox(height: SGSpacing.p5),
                                        Row(children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(_ctx).pop();
                                              },
                                              child: SGContainer(
                                                color: SGColors.gray3,
                                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                                child: Center(
                                                  child: SGTypography.body("취소", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: SGSpacing.p2),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(ctx).pop();
                                                Navigator.of(nutritionScreenContext).pop();
                                              },
                                              child: SGContainer(
                                                color: SGColors.primary,
                                                padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                                borderRadius: BorderRadius.circular(SGSpacing.p3),
                                                child: Center(
                                                  child: SGTypography.body("확인", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                      ]);
                            },
                          )));
                },
              ),
            ]),
            SizedBox(height: SGSpacing.p4),
            GestureDetector(
              onTap: () {
                showSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                          Center(child: SGTypography.body("해당 옵션을\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, align: TextAlign.center, lineHeight: 1.25)),
                          SizedBox(height: SGSpacing.p5 / 2),
                          SGTypography.body("옵션 삭제 시 해당 옵션은 전부 삭제됩니다.", color: SGColors.gray4),
                          SizedBox(height: SGSpacing.p5),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showFailDialogWithImage(context: context, mainTitle: "진행 중인 주문에 선택된 옵션입니다.\n주문 완료 후 삭제 가능합니다.", subTitle: "");
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
                          ])
                        ]);
              },
              child: SGContainer(
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                color: SGColors.warningRed.withOpacity(0.08),
                padding: EdgeInsets.all(SGSpacing.p4),
                child: Center(
                  child: SGTypography.body("옵션 삭제", size: FontSize.small, weight: FontWeight.w600, color: SGColors.warningRed),
                ),
              ),
            ),
            SizedBox(height: SGSpacing.p32),
          ])),
    );
  }
}

class _NutritionEditScreen extends StatefulWidget {
  NutritionModel nutrition;
  Function(NutritionModel, int, BuildContext) onConfirm;

  _NutritionEditScreen({super.key, required this.nutrition, required this.onConfirm});

  @override
  State<_NutritionEditScreen> createState() => _NutritionEditScreenState();
}

class _NutritionEditScreenState extends State<_NutritionEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 수정"),
      // body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}

class _MenuOptionCategoryCard extends StatefulWidget {
  final MenuOptionCategoryModel optionCategoryModel;

  const _MenuOptionCategoryCard({super.key, required this.optionCategoryModel});

  @override
  State<_MenuOptionCategoryCard> createState() => _MenuOptionCategoryCardState();
}

class _MenuOptionCategoryCardState extends State<_MenuOptionCategoryCard> {
  String get selectionType {
    if (widget.optionCategoryModel.essentialStatus == 1) return "(필수)";
    return "(선택 최대 ${widget.optionCategoryModel.maxChoice ?? 0}개)";
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateMenuOptionsScreen(menuOptionCategoryModel: widget.optionCategoryModel)));
        },
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SGTypography.body(widget.optionCategoryModel.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          SGTypography.body(selectionType, size: FontSize.small, color: SGColors.primary, weight: FontWeight.w600),
          SizedBox(width: SGSpacing.p1),
          const Icon(Icons.edit, size: FontSize.small),
        ]),
      ),
      ...widget.optionCategoryModel.menuOptions
          .mapIndexed((index, option) => [
                if (index == 0) SizedBox(height: SGSpacing.p5) else SizedBox(height: SGSpacing.p4),
                DataTableRow(left: option.optionContent ?? "", right: "${(option.price ?? 0).toKoreanCurrency}원"),
              ])
          .flattened
    ]);
  }
}
