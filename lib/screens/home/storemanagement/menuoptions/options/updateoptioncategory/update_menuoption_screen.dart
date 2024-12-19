import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/snackbar.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';

import '../../../../../../core/screens/price_field_edit_screen.dart';
import '../../../../../../main.dart';
import '../../model.dart';
import '../../updatenutrition/nutrition_card.dart';
import '../../updatenutrition/screen.dart';
import '../../provider.dart';

class UpdateMenuOptionModelScreen extends ConsumerStatefulWidget {
  final MenuOptionModel menuOptionModel;

  const UpdateMenuOptionModelScreen({super.key, required this.menuOptionModel});

  @override
  ConsumerState<UpdateMenuOptionModelScreen> createState() => _UpdateMenuOptionModelScreenState();
}

class _UpdateMenuOptionModelScreenState extends ConsumerState<UpdateMenuOptionModelScreen> {
  late MenuOptionModel menuOptionModel;
  NutritionModel nutrition = const NutritionModel();

  @override
  void initState() {
    super.initState();
    ref.read(menuOptionsNotifierProvider.notifier).getMenuInfo(widget.menuOptionModel.menuOptionId).then((nutrition) {
      setState(() {
        this.nutrition = nutrition;
      });
    });
    menuOptionModel = widget.menuOptionModel;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, menuOptionModel);
          return false; // true일 경우 pop 허용
        },
        child: Scaffold(
          appBar: AppBarWithLeftArrow(
            title: "옵션 관리",
            onTap: () => {
              Navigator.pop(context, menuOptionModel),
            },
          ),
          body: SGContainer(
              color: const Color(0xFFFAFAFA),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
              child: ListView(children: [
                // --------------------------- optionContent 수정 ---------------------------
                MultipleInformationBox(children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TextFieldEditScreen(
                                value: menuOptionModel.optionContent,
                                title: "옵션 변경",
                                onSubmit: (value) {
                                  provider.updateMenuOptionName(menuOptionModel.menuOptionId, value).then((success) {
                                    logger.d("updateMenuOptionName success $success $value");
                                    if (success) {
                                      setState(() {
                                        menuOptionModel = menuOptionModel.copyWith(optionContent: value);
                                      });
                                    }
                                    if (mounted) {
                                      showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
                                    }
                                  });
                                },
                                buttonText: "변경하기",
                                hintText: "옵션 이름을 입력해주세요",
                              )));
                    },
                    child: Row(children: [
                      SGTypography.body(menuOptionModel.optionContent, size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(width: SGSpacing.p1),
                      const Icon(Icons.edit, size: FontSize.small),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p5),

                  // --------------------------- 가격 수정 ---------------------------
                  DataTableRow(left: "가격", right: "${menuOptionModel.price.toKoreanCurrency}원"),
                  SizedBox(height: SGSpacing.p5),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PriceFieldEditScreen(
                                price: menuOptionModel.price,
                                title: "옵션 가격 변경",
                                buttonText: "변경하기",
                                hintText: "가격을 입력해주세요.",
                                onSubmit: (value) {
                                  provider.updateMenuOptionPrice(menuOptionModel.menuOptionId, value).then((success) {
                                    logger.d("updateMenuOptionPrice success $success $value");
                                    if (success) {
                                      setState(() {
                                        menuOptionModel = menuOptionModel.copyWith(price: value);
                                      });
                                      showGlobalSnackBarWithoutContext("성공적으로 변경되었습니다.");
                                    }
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

                // --------------------------- 품절 ---------------------------
                SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                  borderColor: SGColors.line2,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Row(children: [
                    SGTypography.body("품절", size: FontSize.normal),
                    const Spacer(),
                    SGSwitch(
                      value: menuOptionModel.soldOutStatus == 1,
                      onChanged: (value) {
                        provider.updateMenuOptionSoldOutStatus(menuOptionModel.menuOptionId, value ? 1 : 0).then(
                          (success) {
                            logger.d("updateMenuOptionCategorySoldOutStatus success $success $value");
                            if (success) {
                              setState(() {
                                menuOptionModel = menuOptionModel.copyWith(soldOutStatus: value ? 1 : 0);
                              });
                            }
                          },
                        );
                      },
                    ),
                  ]),
                ),
                SizedBox(height: SGSpacing.p8),

                // --------------------------- nutrition ---------------------------
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  NutritionCard(
                    nutrition: nutrition,
                    type: 1,
                    onTap: () {
                      final screenContext = context;
                      Navigator.of(screenContext).push(MaterialPageRoute(
                          builder: (nutritionScreenContext) => UpdateNutritionScreen(
                                title: "영양성분 설정",
                                nutrition: nutrition,
                                onConfirm: (nutrition, context) {
                                  showNutritionSGDialog(
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
                                                    provider.updateMenuOptionInfo(menuOptionModel.menuOptionId, nutrition).then(
                                                      (success) {
                                                        logger.d("updateMenuOptionInfo success $success $nutrition");
                                                        if (success) {
                                                          setState(() {
                                                            this.nutrition = nutrition;
                                                          });
                                                        }
                                                        if (mounted) {
                                                          Navigator.of(context).pop();
                                                          showGlobalSnackBar(nutritionScreenContext, "성공적으로 변경되었습니다.");
                                                        }
                                                      },
                                                    );
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

                // --------------------------- 옵션 삭제 ---------------------------
                GestureDetector(
                  onTap: () {
                    showDeleteOptionSGDialog(
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
                                      provider.deleteMenuOption(menuOptionModel).then(
                                        (responseStatusCode) {
                                          logger.d("updateMenuOptionInfo responseStatusCode $responseStatusCode");
                                          if (responseStatusCode == 200) {
                                            if (mounted) {
                                              showGlobalSnackBar(context, "성공적으로 삭제되었습니다.");
                                              Navigator.pop(context);
                                            }
                                          } else {
                                            if (responseStatusCode == 409) {
                                              showFailDialogWithImage(context: context, mainTitle: "진행 중인 주문에 선택된 옵션입니다.\n주문 완료 후 삭제 가능합니다.", subTitle: "");
                                            }
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
        ));
  }
}

void showDeleteOptionSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 210,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showNutritionSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 190,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}