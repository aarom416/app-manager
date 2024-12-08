import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_step_indicator.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../cuisine_selection_bottom_sheet.dart';
import '../model.dart';
import '../new_cuisine_option_screen.dart';

final selectableCuisines = [
  MenuModel(
    menuId: 1,
    menuName: "김치찌개",
    price: 8000,
    menuDescription: "맛있는 김치찌개",
    menuPictureURL: "https://via.placeholder.com/150",
  ),
  MenuModel(
    menuId: 2,
    menuName: "된장찌개",
    price: 8000,
    menuDescription: "맛있는 된장찌개",
    menuPictureURL: "https://via.placeholder.com/150",
  ),
  MenuModel(
    menuId: 3,
    menuName: "부대찌개",
    price: 8000,
    menuDescription: "맛있는 부대찌개",
    menuPictureURL: "https://via.placeholder.com/150",
  ),
  MenuModel(
    menuId: 4,
    menuName: "김치찌개",
    price: 8000,
    menuDescription: "맛있는 김치찌개",
    menuPictureURL: "https://via.placeholder.com/150",
  ),
];

class NewCuisineOptionCategoryScreen extends StatefulWidget {
  const NewCuisineOptionCategoryScreen({super.key});

  @override
  State<NewCuisineOptionCategoryScreen> createState() => _NewCuisineOptionCategoryScreenState();
}

class _NewCuisineOptionCategoryScreenState extends State<NewCuisineOptionCategoryScreen> {
  PageController pageController = PageController();

  List<MenuModel> cuisines = [];

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(controller: pageController, physics: NeverScrollableScrollPhysics(), children: [
      _NewCuisineOptionCategoryNameStepScreen(onPrev: () {
        Navigator.of(context).pop();
      }, onNext: () {
        animateToPage(1);
      }),
      _NewCuisineOptionsStepScreen(onPrev: () {
        animateToPage(0);
      }, onNext: () {
        animateToPage(2);
      }),
      _NewCuisionOptionCategoryQuantityEditScreen(onPrev: () {
        animateToPage(1);
      }, onNext: () {
        animateToPage(3);
      }),
      _SelectCuisinesStepScreen(
          onPrev: () {
            animateToPage(2);
          },
          onNext: () {
            animateToPage(4);
          },
          onCuisinesSelected: (cuisines) {
            setState(() {
              this.cuisines = cuisines;
            });
          },
          cuisines: cuisines),
      _ConfirmCuisineOptionCategoryScreen(
          onPrev: () {
            animateToPage(3);
          },
          onNext: () {
            Navigator.of(context).pop();
          },
          cuisines: cuisines),
    ]));
  }
}

class _NewCuisineOptionCategoryNameStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  _NewCuisineOptionCategoryNameStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisineOptionCategoryNameStepScreen> createState() => _NewCuisineOptionCategoryNameStepScreenState();
}

class _NewCuisineOptionCategoryNameStepScreenState extends State<_NewCuisineOptionCategoryNameStepScreen> {
  String menuName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 카테고리 추가", currentStep: 1, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                disabled: menuName.isEmpty,
                onPressed: () {
                  widget.onNext();
                },
                label: "다음")),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션 카테고리명 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          menuName = value;
                        });
                      },
                      style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintStyle:
                            TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                        hintText: "Ex) 2인 샐러드 포케 세트",
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                )),
              ],
            )));
  }
}

class _NewCuisineOptionsStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  _NewCuisineOptionsStepScreen({super.key, required this.onNext, required this.onPrev});

  @override
  State<_NewCuisineOptionsStepScreen> createState() => _NewCuisineOptionsStepScreenState();
}

class _NewCuisineOptionsStepScreenState extends State<_NewCuisineOptionsStepScreen> {
  List<MenuOptionModel> options = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 카테고리 추가", currentStep: 2, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (options.isEmpty) return;
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: options.isEmpty ? SGColors.gray3 : SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("다음",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션을 설정해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                ...options
                    .mapIndexed((index, option) => [
                          __CuisineOptionCard(
                              option: option,
                              onRemove: (option) {
                                setState(() {
                                  options = [...options.sublist(0, index), ...options.sublist(index + 1)];
                                });
                              }),
                          SizedBox(height: SGSpacing.p3)
                        ])
                    .flattened,
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewCuisineOptionScreen(
                                onSubmitCuisineOption: (option) {
                                  setState(() {
                                    options.add(option);
                                  });
                                },
                              )));
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
                          SGTypography.body("새 옵션 설정",
                              size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                        ])))),
              ],
            )));
  }
}

class __CuisineOptionCard extends StatelessWidget {
  final MenuOptionModel option;
  final Function(MenuOptionModel) onRemove;

  __CuisineOptionCard({
    super.key,
    required this.option,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.asset("assets/images/accordion.png", width: SGSpacing.p4, height: SGSpacing.p4),
      SizedBox(width: SGSpacing.p2),
      Expanded(
        child: SGContainer(
            color: SGColors.white,
            padding: EdgeInsets.all(SGSpacing.p4),
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            boxShadow: SGBoxShadow.large,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SGTypography.body(option.optionContent, size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p3),
                    SGTypography.body("${(option.price ?? 0).toKoreanCurrency}원",
                        size: FontSize.small, weight: FontWeight.w400),
                  ],
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      onRemove(option);
                    },
                    child: SGContainer(
                      borderWidth: 0,
                      width: SGSpacing.p5,
                      height: SGSpacing.p5,
                      borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                      color: SGColors.warningRed,
                      child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16)),
                    )),
              ],
            )),
      ),
    ]);
  }
}

class _NewCuisionOptionCategoryQuantityEditScreen extends StatefulWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;
  _NewCuisionOptionCategoryQuantityEditScreen({
    super.key,
    required this.onPrev,
    required this.onNext,
  });

  @override
  State<_NewCuisionOptionCategoryQuantityEditScreen> createState() =>
      _NewCuisionOptionCategoryQuantityEditScreenState();
}

class _NewCuisionOptionCategoryQuantityEditScreenState extends State<_NewCuisionOptionCategoryQuantityEditScreen> {
  TextEditingController minValueController = TextEditingController(text: "1");
  TextEditingController maxValueController = TextEditingController(text: "1");

  bool isEssential = false;

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithStepIndicator(title: "옵션 카테고리 추가", currentStep: 3, totalStep: 5, onTap: widget.onPrev),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  widget.onPrev();
                },
                child: SGContainer(
                    color: SGColors.gray3,
                    padding: EdgeInsets.all(SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이전",
                            size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
              )),
              SizedBox(width: SGSpacing.p3),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  widget.onNext();
                },
                child: SGContainer(
                    color: SGColors.primary,
                    padding: EdgeInsets.all(SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("다음",
                            size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
              )),
            ],
          )),
      body: SGContainer(
        borderWidth: 0,
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          SGTypography.body("옵션 필수 여부를 설정해주세요.", weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p4),
          SGContainer(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
              borderColor: SGColors.line2,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("필수 옵션", size: FontSize.normal),
                Spacer(),
                SGSwitch(
                  value: isEssential,
                  onChanged: (value) {
                    setState(() {
                      isEssential = value;
                    });
                  },
                ),
              ])),
          SizedBox(height: SGSpacing.p3),
          SGTypography.body("메뉴 주문 시 옵션을 필수로 선택해야 해요.", color: SGColors.gray4),
          SizedBox(height: SGSpacing.p8),
          SGTypography.body("옵션 선택 개수를 설정해주세요.", weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p4),
          if (isEssential) ...[
            SGTypography.body("최소", size: FontSize.small, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: minValueController,
                        style: baseStyle.copyWith(color: SGColors.black),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          isCollapsed: true,
                          hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                  ),
                  SGTypography.body("개", size: FontSize.small, color: SGColors.gray4),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p3),
          ],
          SGTypography.body("최대", size: FontSize.small, color: SGColors.gray4),
          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
          SGContainer(
            color: Colors.white,
            borderColor: SGColors.line3,
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: maxValueController,
                      style: baseStyle.copyWith(color: SGColors.black),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(SGSpacing.p4),
                        isCollapsed: true,
                        hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                ),
                SGTypography.body("개", size: FontSize.small, color: SGColors.gray4),
                SizedBox(width: SGSpacing.p4),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _SelectCuisinesStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final List<MenuModel> cuisines;
  final Function(List<MenuModel>) onCuisinesSelected;
  _SelectCuisinesStepScreen(
      {super.key,
      required this.onNext,
      required this.onPrev,
      required this.onCuisinesSelected,
      required this.cuisines});

  @override
  State<_SelectCuisinesStepScreen> createState() => _SelectCuisinesStepScreenState();
}

class _SelectCuisinesStepScreenState extends State<_SelectCuisinesStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 카테고리 추가", currentStep: 4, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (widget.cuisines.isEmpty) return;

                    widget.onNext();
                  },
                  child: SGContainer(
                      color: widget.cuisines.isEmpty ? SGColors.gray3 : SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("다음",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션을 포함할 메뉴를 선택해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                if (widget.cuisines.isEmpty) ...[
                  SizedBox(height: SGSpacing.p3),
                  GestureDetector(
                      onTap: () {
                        _selectCuisine(context);
                      },
                      child: SGContainer(
                          color: SGColors.white,
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                          borderRadius: BorderRadius.circular(SGSpacing.p2),
                          borderColor: SGColors.primary,
                          child: Center(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            SGTypography.body("메뉴 선택하기",
                                size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                          ]))))
                ] else ...[
                  ...widget.cuisines
                      .mapIndexed(
                        (index, cuisine) => [
                          SizedBox(height: SGSpacing.p3),
                          _SelectedCuisineCard(
                              cuisine: cuisine,
                              onRemove: () {
                                widget.onCuisinesSelected(
                                    [...widget.cuisines.sublist(0, index), ...widget.cuisines.sublist(index + 1)]);
                              })
                        ],
                      )
                      .flattened,
                  SizedBox(height: SGSpacing.p3),
                  GestureDetector(
                      onTap: () {
                        _selectCuisine(context);
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
                            SGTypography.body("메뉴 추가하기",
                                size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                          ]))))
                ]
              ],
            )));
  }

  void _selectCuisine(BuildContext context) {
    return showCuisineSelectionBottomSheet(
        context: context,
        title: "메뉴 추가",
        cuisines: selectableCuisines,
        onSelect: (selectedCuisines) {
          // final sortedCuisines = selectedCuisines.toList()..sort((a, b) => a.menuId!.compareTo(b.menuId!));
          // widget.onCuisinesSelected(sortedCuisines);
        },
        selectedCuisines: widget.cuisines);
  }
}

class _ConfirmCuisineOptionCategoryScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final List<MenuModel> cuisines;
  _ConfirmCuisineOptionCategoryScreen({super.key, required this.onNext, required this.onPrev, required this.cuisines});

  @override
  State<_ConfirmCuisineOptionCategoryScreen> createState() => _ConfirmCuisineOptionCategoryScreenState();
}

class _ConfirmCuisineOptionCategoryScreenState extends State<_ConfirmCuisineOptionCategoryScreen> {
  bool isEssential = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 카테고리 추가", currentStep: 5, totalStep: 5, onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("카테고리 추가하기",
                              size: FontSize.medium, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("마지막으로 한 번 더 확인해주세요.", size: FontSize.large, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p8),
                SGTypography.body("옵션 카테고리명", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("2인 샐러드 포케 세트",
                          size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray5),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("옵션명", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("훈제오리 토핑",
                          size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray5),
                      Spacer(),
                      SGTypography.body("3,000원",
                          size: FontSize.normal, weight: FontWeight.w500, color: SGColors.gray4),
                    ])),
                SGContainer(),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("필수 여부", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("필수 옵션", size: FontSize.normal),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("선택 개수", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body("최소 1개, 최대 1개",
                          size: FontSize.normal, weight: FontWeight.w400, color: SGColors.gray5),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("이 옵션을 포함하는 메뉴", size: FontSize.normal, weight: FontWeight.w700),
                ...widget.cuisines
                    .mapIndexed(
                      (index, cuisine) => [
                        SizedBox(height: SGSpacing.p3),
                        _SelectedCuisineCard(
                          cuisine: cuisine,
                        )
                      ],
                    )
                    .flattened,
                SizedBox(height: SGSpacing.p32),
              ],
            )));
  }
}

class _SelectedCuisineCard extends StatelessWidget {
  final MenuModel cuisine;
  VoidCallback? onRemove;

  _SelectedCuisineCard({Key? key, required this.cuisine, this.onRemove}) : super(key: key);

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
              ClipRRect(
                  borderRadius: BorderRadius.circular(SGSpacing.p4),
                  child: Image.network(cuisine.menuPictureURL, width: SGSpacing.p18, height: SGSpacing.p18)),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(cuisine.menuName,
                      color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("${cuisine.price.toKoreanCurrency}원",
                      color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
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
