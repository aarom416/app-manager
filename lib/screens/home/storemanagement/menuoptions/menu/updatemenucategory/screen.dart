import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/snackbar.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../../../main.dart';
import '../../model.dart';
import '../../provider.dart';

class UpdateMenuCategoryScreen extends ConsumerStatefulWidget {
  final MenuCategoryModel menuCategoryModel;

  const UpdateMenuCategoryScreen({super.key, required this.menuCategoryModel});

  @override
  ConsumerState<UpdateMenuCategoryScreen> createState() => _UpdateMenuCategoryScreenState();
}

class _UpdateMenuCategoryScreenState extends ConsumerState<UpdateMenuCategoryScreen> {
  final int MENU_CATEGORY_DESCRIPTION_INPUT_MAX = 100;
  late TextEditingController menuCategoryDescriptionController;
  late String menuCategoryDescription;

  late TextEditingController menuCategoryNameController;
  late String menuCategoryName;

  int maxLength = 100;

  @override
  void initState() {
    super.initState();
    menuCategoryDescriptionController = TextEditingController(text: widget.menuCategoryModel.menuIntroduction);
    menuCategoryDescription = widget.menuCategoryModel.menuIntroduction;
    menuCategoryNameController = TextEditingController(text: widget.menuCategoryModel.menuCategoryName);
    menuCategoryName = widget.menuCategoryModel.menuCategoryName;
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarWithLeftArrow(title: "메뉴 카테고리 변경"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
            onPressed: () {
              // 변경 사항이 있을 경우에만 업데이트 실행
              if (menuCategoryName != widget.menuCategoryModel.menuCategoryName ||
                  menuCategoryDescription != widget.menuCategoryModel.menuIntroduction) {
                provider.updateMenuCategoryName(MenuCategoryModel(
                  storeMenuCategoryId: widget.menuCategoryModel.storeMenuCategoryId,
                  menuCategoryName: menuCategoryName,
                  menuIntroduction: menuCategoryDescription,
                ));

                showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
              }
            },
            disabled: menuCategoryName.isEmpty ||
                (menuCategoryDescription == widget.menuCategoryModel.menuIntroduction &&
                    menuCategoryName == widget.menuCategoryModel.menuCategoryName),
            label: "변경하기",
          ),
        ),

        body: SGContainer(
            width: double.infinity,
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [

              SGTypography.body("메뉴 카테고리명", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: TextField(
                    controller: menuCategoryNameController,
                    style: TextStyle(fontSize: FontSize.small, color: SGColors.black),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50), // 최대 입력 길이 제한
                    ],
                    onChanged: (inputValue) {
                      setState(() {
                        menuCategoryName = inputValue;
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      isCollapsed: true,
                      hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                      hintText: "메뉴 카테고리명을 입력해주세요.",
                      border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                    )),
              )),
              SizedBox(height: SGSpacing.p6),
              SGTypography.body("카테고리 설명", size: FontSize.normal, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                color: Colors.white,
                borderColor: SGColors.line3,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Stack(alignment: Alignment.bottomRight, children: [
                  TextField(
                      controller: menuCategoryDescriptionController,
                      maxLines: 5,
                      style: const TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small).copyWith(color: SGColors.black),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(MENU_CATEGORY_DESCRIPTION_INPUT_MAX), // 최대 입력 길이 제한
                      ],
                      onChanged: (inputValue) {
                        setState(() {
                          menuCategoryDescription = inputValue;
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(SGSpacing.p4),
                        isCollapsed: true,
                        hintText: "카테고리 설명을 입력해주세요.",
                        hintStyle: const TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small).copyWith(color: SGColors.gray3),
                        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                      )),
                  SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        SGTypography.body(
                          "${menuCategoryDescription.length}",
                        ),
                        SGTypography.body(
                          "/$MENU_CATEGORY_DESCRIPTION_INPUT_MAX",
                          color: SGColors.gray3,
                        ),
                      ]))
                ]),
              )),
              SizedBox(height: SGSpacing.p4),
              GestureDetector(
                onTap: () {
                  showSGDialog(
                      context: context,
                      childrenBuilder: (ctx) => [
                            Center(child: SGTypography.body("메뉴 카테고리를\n정말 삭제하시겠습니까?", size: FontSize.large, weight: FontWeight.w700, align: TextAlign.center, lineHeight: 1.25)),
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                            SGTypography.body("메뉴 카테고리 내 메뉴도 전부 삭제됩니다.", color: SGColors.gray4),
                            SizedBox(height: SGSpacing.p5),
                            Row(children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    provider.deleteMenuCategory(context, MenuCategoryModel(
                                      storeMenuCategoryId: widget.menuCategoryModel.storeMenuCategoryId,
                                      menuCategoryName: menuCategoryName,
                                    )).then((resultFailResponseModel) {
                                      if (resultFailResponseModel.errorCode.isEmpty) {
                                        showGlobalSnackBar(ctx, "성공적으로 삭제되었습니다.");
                                        Navigator.of(ctx).pop();
                                      } else {
                                        Navigator.pop(context);
                                        // 실패 시 Dialog를 띄우도록 처리
                                        showFailDialogWithImage(
                                          context: context,
                                          mainTitle: resultFailResponseModel.errorMessage,
                                          onTapFunction: () {
                                            Navigator.pop(context);
                                          },
                                        );
                                      }
                                    });

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
                    child: SGTypography.body("가게 메뉴 카테고리 삭제", size: FontSize.small, weight: FontWeight.w600, color: SGColors.warningRed),
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
