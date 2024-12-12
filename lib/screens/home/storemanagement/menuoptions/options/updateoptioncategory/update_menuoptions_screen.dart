import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/dynamic.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/screens/text_field_edit_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/options/updateoptioncategory/update_menuoption_screen.dart';

import '../../../../../../main.dart';
import '../../model.dart';
import '../addoption/screen.dart';
import '../../provider.dart';

class UpdateMenuOptionsScreen extends ConsumerStatefulWidget {
  final MenuOptionCategoryModel menuOptionCategoryModel;

  const UpdateMenuOptionsScreen({super.key, required this.menuOptionCategoryModel});

  @override
  ConsumerState<UpdateMenuOptionsScreen> createState() => _UpdateMenuOptionsScreenState();
}

class _UpdateMenuOptionsScreenState extends ConsumerState<UpdateMenuOptionsScreen> {
  late MenuOptionCategoryModel menuOptionCategoryModel;

  @override
  void initState() {
    super.initState();
    menuOptionCategoryModel = widget.menuOptionCategoryModel;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, menuOptionCategoryModel);
          return false; // true일 경우 pop 허용
        },
        child: Scaffold(
            appBar: AppBarWithLeftArrow(
              title: "옵션 관리",
              onTap: () => {
                Navigator.pop(context, menuOptionCategoryModel),
              },
            ),
            body: SGContainer(
                color: const Color(0xFFFAFAFA),
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
                child: ListView(children: [
                  // --------------------------- menuOptionCategoryName 수정 ---------------------------
                  MultipleInformationBox(children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TextFieldEditScreen(
                                  value: menuOptionCategoryModel.menuOptionCategoryName,
                                  title: "옵션 카테고리 변경",
                                  onSubmit: (value) {
                                    provider.updateMenuOptionCategoryName(menuOptionCategoryModel.menuOptionCategoryId, value).then((success) {
                                      logger.d("updateMenuOptionCategoryName success $success $value");
                                      if (success) {
                                        setState(() {
                                          menuOptionCategoryModel = menuOptionCategoryModel.copyWith(menuOptionCategoryName: value);
                                        });
                                      }
                                      if (mounted) {
                                        Navigator.pop(context, menuOptionCategoryModel);
                                      }
                                    });
                                  },
                                  buttonText: "저장하기",
                                  hintText: "옵션 카테고리 이름을 입력해주세요",
                                )));
                      },
                      child: Row(children: [
                        SGTypography.body(menuOptionCategoryModel.menuOptionCategoryName, size: FontSize.normal, weight: FontWeight.w600),
                        SizedBox(width: SGSpacing.p1),
                        const Icon(Icons.edit, size: FontSize.small),
                      ]),
                    )
                  ]),
                  SizedBox(height: SGSpacing.p5),

                  // --------------------------- menuOptions 수정 ---------------------------
                  ...menuOptionCategoryModel.menuOptions
                      .mapIndexed((index, menuOptionModel) => [
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                            MultipleInformationBox(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final updatedMenuOptionModel = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateMenuOptionModelScreen(
                                          menuOptionModel: menuOptionModel,
                                        ),
                                      ),
                                    );
                                    if (updatedMenuOptionModel != null && mounted) {
                                      setState(() {
                                        List<MenuOptionModel> menuOptions_ = List.from(menuOptionCategoryModel.menuOptions);
                                        menuOptions_[index] = updatedMenuOptionModel;
                                        menuOptionCategoryModel = menuOptionCategoryModel.copyWith(menuOptions: menuOptions_);
                                      });
                                    }
                                    // showFailDialogWithImage(context: context, mainTitle: "해당 옵션은 삭제된 옵션입니다.", subTitle: "");
                                  },
                                  child: Row(children: [
                                    SGTypography.body(menuOptionModel.optionContent, size: FontSize.normal, weight: FontWeight.w600),
                                    SizedBox(width: SGSpacing.p1),
                                    const Icon(Icons.edit, size: FontSize.small),
                                  ]),
                                ),
                                SizedBox(height: SGSpacing.p5),
                                DataTableRow(left: "가격", right: "${(menuOptionModel.price ?? 0).toKoreanCurrency}원"),
                              ],
                            ),
                          ])
                      .flattened,
                  SizedBox(height: SGSpacing.p5),

                  // --------------------------- 옵션 추가하기 버튼 ---------------------------
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddOptionScreen(
                                  onSubmit: (menuOptionModel) {
                                    logger.d("onSubmit option ${menuOptionModel.toFormattedJson()}");
                                    // todo 옵션추가 api
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
                            SGTypography.body("옵션 추가하기", size: FontSize.small, weight: FontWeight.w500, color: SGColors.primary)
                          ])))),
                ]))));
  }
}
