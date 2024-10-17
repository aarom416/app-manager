import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/app_bar_with_step_indicator.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/formatter.dart';
import 'package:singleeat/office/components/nutrition_card.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/nutrition_form.dart';

class NewCuisineOptionScreen extends StatefulWidget {
  final Function(CuisineOption) onSubmitCuisineOption;
  const NewCuisineOptionScreen({super.key, required this.onSubmitCuisineOption});

  @override
  State<NewCuisineOptionScreen> createState() => _NewCuisineOptionScreenState();
}

class _NewCuisineOptionScreenState extends State<NewCuisineOptionScreen> {
  PageController pageController = PageController();

  CuisineOption option = CuisineOption(name: "", price: 0);

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(controller: pageController, physics: NeverScrollableScrollPhysics(), children: [
      _NewCuisineOptionNameStepScreen(onPrev: () {
        Navigator.of(context).pop();
      }, onNext: () {
        animateToPage(1);
      }, onSubmit: (value) {
        setState(() {
          option = value;
        });
      }),
      _NewCuisineOptionNutritionStepScreen(onPrev: () {
        animateToPage(0);
      }, onNext: () {
        widget.onSubmitCuisineOption(option);
        Navigator.of(context).pop();
      }),
    ]));
  }
}

class _NewCuisineOptionNameStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(CuisineOption) onSubmit;
  _NewCuisineOptionNameStepScreen({super.key, required this.onNext, required this.onPrev, required this.onSubmit});

  @override
  State<_NewCuisineOptionNameStepScreen> createState() => _NewCuisineOptionNameStepScreenState();
}

class _NewCuisineOptionNameStepScreenState extends State<_NewCuisineOptionNameStepScreen> {
  String optionName = "";
  String optionPrice = "";

  bool get isFormValid => optionName.isNotEmpty && optionPrice.isNotEmpty;

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
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large, color: SGColors.white, weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    if (!isFormValid) return;
                    widget.onSubmit(CuisineOption(name: optionName, price: int.parse(optionPrice.replaceAll(",", ""))));
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: isFormValid ? SGColors.primary : SGColors.gray3,
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
                SGTypography.body("옵션명 설정해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: TextField(
                      onChanged: (value) {
                        setState(() {
                          optionName = value;
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
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                optionPrice = value;
                              });
                            },
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              comparableNumericInputFormatter(1000000000)
                            ],
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "0",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                      SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                    ],
                  ),
                )),
              ],
            )));
  }
}

class _NewCuisineOptionNutritionStepScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _NewCuisineOptionNutritionStepScreen({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<_NewCuisineOptionNutritionStepScreen> createState() => _NewCuisineOptionNutritionStepScreenState();
}

class _NewCuisineOptionNutritionStepScreenState extends State<_NewCuisineOptionNutritionStepScreen> {
  Nutrition nutrition =
      Nutrition(calories: 432, protein: 10, fat: 3, carbohydrate: 12, glucose: 12, sodium: 120, saturatedFat: 8);

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
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션의 영양성분을 입력해주세요.", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p3),
                NutritionCard(
                  nutrition: nutrition,
                  onTap: () {
                    final nutritionScreenContext = context;
                    Navigator.of(nutritionScreenContext).push(MaterialPageRoute(
                        builder: (context) => _NutritionInputScreen(
                              nutrition: nutrition,
                              onConfirm: (value, ctx) {
                                showSGDialog(
                                    context: ctx,
                                    childrenBuilder: (_ctx) => [
                                          Center(
                                              child: SGTypography.body("영양성분을\n정말 설정하시겠습니까?",
                                                  size: FontSize.large,
                                                  weight: FontWeight.w700,
                                                  lineHeight: 1.25,
                                                  align: TextAlign.center)),
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
                                                    child: SGTypography.body("취소",
                                                        size: FontSize.normal,
                                                        weight: FontWeight.w700,
                                                        color: SGColors.white),
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
                                                    child: SGTypography.body("확인",
                                                        size: FontSize.normal,
                                                        weight: FontWeight.w700,
                                                        color: SGColors.white),
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

class _NutritionInputScreen extends StatefulWidget {
  Nutrition nutrition;
  Function(Nutrition, BuildContext) onConfirm;

  _NutritionInputScreen({super.key, required this.nutrition, required this.onConfirm});

  @override
  State<_NutritionInputScreen> createState() => _NutritionInputScreenState();
}

class _NutritionInputScreenState extends State<_NutritionInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영양성분 설정"),
      body: NutritionForm(nutrition: widget.nutrition, onChanged: widget.onConfirm),
    );
  }
}
