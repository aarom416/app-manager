import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_step_indicator.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../../core/components/numeric_textfield.dart';
import '../../model.dart';
import '../../nutrition/nutrition_card.dart';
import '../../nutrition/screen.dart';

class AddOptionScreen extends StatefulWidget {
  final Function(MenuOptionModel) onSubmit;

  const AddOptionScreen({super.key, required this.onSubmit});

  @override
  State<AddOptionScreen> createState() => _AddOptionScreenState();
}

class _AddOptionScreenState extends State<AddOptionScreen> {
  PageController pageController = PageController();

  MenuOptionModel menuOptionModel = const MenuOptionModel();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(controller: pageController, physics: const NeverScrollableScrollPhysics(), children: [
      _Page_0_OptionName(
        menuOptionModel: menuOptionModel,
        onPrev: () => Navigator.pop(context),
        onNext: () => animateToPage(1),
        onSubmit: (value) {
          setState(() {
            menuOptionModel = value;
          });
        },
      ),
      _Page_1_Nutrition(
        menuOptionModel: menuOptionModel,
        onPrev: () => animateToPage(0),
        onNext: () {
          widget.onSubmit(menuOptionModel);
          Navigator.of(context).pop();
        },
        onSubmit: (value) {
          widget.onSubmit(value);
        },
      ),
    ]));
  }
}

class _Page_0_OptionName extends StatefulWidget {
  final MenuOptionModel menuOptionModel;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(MenuOptionModel) onSubmit;

  _Page_0_OptionName({required this.menuOptionModel, required this.onNext, required this.onPrev, required this.onSubmit});

  @override
  State<_Page_0_OptionName> createState() => _Page_0_OptionNameState();
}

class _Page_0_OptionNameState extends State<_Page_0_OptionName> {
  late MenuOptionModel menuOptionModel;
  late TextEditingController optionContentController;

  bool get isFormValid => menuOptionModel.optionContent.isNotEmpty;

  @override
  void initState() {
    super.initState();
    menuOptionModel = widget.menuOptionModel;
    optionContentController = TextEditingController(text: menuOptionModel.optionContent);
  }

  @override
  void dispose() {
    optionContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 추가", currentStep: 1, totalStep: 2, onTap: widget.onPrev),
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
                      child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (!isFormValid) return;
                    widget.onSubmit(menuOptionModel);
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: isFormValid ? SGColors.primary : SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(child: SGTypography.body("다음", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션명 설정해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: TextField(
                      controller: optionContentController,
                      onChanged: (value) {
                        setState(() {
                          menuOptionModel = menuOptionModel.copyWith(optionContent: value);
                        });
                      },
                      style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                      decoration: InputDecoration(
                        isDense: true,
                        isCollapsed: true,
                        hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                        hintText: "Ex) 2인 샐러드 포케 세트",
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                )),
                SizedBox(height: SGSpacing.p6),
                SGTypography.body("가격을 설정해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: NumericTextField(
                          initialValue: menuOptionModel.price,
                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,
                            hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                            hintText: menuOptionModel.price.toKoreanCurrency,
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onValueChanged: (price) {
                            setState(() {
                              menuOptionModel = menuOptionModel.copyWith(price: price);
                            });
                          },
                        ),
                      ),
                      SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                    ],
                  ),
                )),
              ],
            )));
  }
}

class _Page_1_Nutrition extends StatefulWidget {
  final MenuOptionModel menuOptionModel;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(MenuOptionModel) onSubmit;

  const _Page_1_Nutrition({required this.menuOptionModel, required this.onNext, required this.onPrev, required this.onSubmit});

  @override
  State<_Page_1_Nutrition> createState() => _Page_1_NutritionState();
}

class _Page_1_NutritionState extends State<_Page_1_Nutrition> {
  late MenuOptionModel menuOptionModel;

  @override
  void initState() {
    super.initState();
    menuOptionModel = widget.menuOptionModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(title: "옵션 추가", currentStep: 2, totalStep: 2, onTap: widget.onPrev),
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
                      child: Center(child: SGTypography.body("이전", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
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
                      child: Center(child: SGTypography.body("다음", size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션의 영양성분을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                NutritionCard(
                  nutrition: menuOptionModel.nutrition,
                  onTap: () {
                    final nutritionScreenContext = context;
                    Navigator.of(nutritionScreenContext).push(MaterialPageRoute(
                        builder: (context) => NutritionInputScreen(
                              title: "영양성분 설정",
                              nutrition: menuOptionModel.nutrition,
                              onConfirm: (nutrition, context) {
                                showSGDialog(
                                    context: context,
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
                                                  widget.onSubmit(menuOptionModel.copyWith(nutrition: nutrition));
                                                  Navigator.of(context).pop();
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
                )
              ],
            )));
  }
}
