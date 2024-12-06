import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import 'model.dart';


class UpdateCuisineCategoryScreen extends StatefulWidget {
  final MenuCategoryModel category;
  const UpdateCuisineCategoryScreen({super.key, required this.category});

  @override
  State<UpdateCuisineCategoryScreen> createState() => _UpdateCuisineCategoryScreenState();
}

class _UpdateCuisineCategoryScreenState extends State<UpdateCuisineCategoryScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;

  late String name = widget.category.menuCategoryName;
  late String description = widget.category.menuDescription;


  TextEditingController controller = TextEditingController();
  String value = '';

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);
  int maxLength = 100;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.menuCategoryName);
    descriptionController = TextEditingController(text: widget.category.menuDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "메뉴 카테고리 변경"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              disabled: name.isEmpty || description.isEmpty,
              label: "변경하기")),
      body: SGContainer(
          width: double.infinity,
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            SGTypography.body("메뉴 카테고리명", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: FontSize.small, color: SGColors.black),
                  onChanged: (value) {
                    setState(() {
                      name = value;
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
                        controller: descriptionController,
                        maxLines: 5,
                        style: baseStyle.copyWith(color: SGColors.black),
                        onChanged: (value) {
                          setState(() {
                            if (maxLength != null && value.length > maxLength!) {
                              descriptionController.text = value.substring(0, maxLength!);
                              descriptionController.selection = TextSelection.fromPosition(TextPosition(offset: maxLength!));
                              return;
                            }
                            this.value = value;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(SGSpacing.p4),
                          isCollapsed: true,
                          hintText: "카테고리 설명을 입력해주세요.",
                          hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        )),
                    if (maxLength != null)
                      SGContainer(
                          padding: EdgeInsets.all(SGSpacing.p4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            SGTypography.body(
                              "${value.length}",
                            ),
                            SGTypography.body(
                              "/100",
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
                          Center(
                              child: SGTypography.body("메뉴 카테고리를\n정말 삭제하시겠습니까?",
                                  size: FontSize.large,
                                  weight: FontWeight.w700,
                                  align: TextAlign.center,
                                  lineHeight: 1.25)),
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                          SGTypography.body("메뉴 카테고리 내 메뉴도 전부 삭제됩니다.", color: SGColors.gray4),
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
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
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
                                    child: SGTypography.body("취소",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
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
                  child: SGTypography.body("가게 메뉴 카테고리 삭제",
                      size: FontSize.small, weight: FontWeight.w600, color: SGColors.warningRed),
                ),
              ),
            )
          ])),
    );
  }
}
