import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../../core/components/dialog.dart';
import '../../cuisine_selection_bottom_sheet.dart';
import '../../model.dart';

class NewMenuCategoryScreen extends StatefulWidget {
  const NewMenuCategoryScreen({super.key});

  @override
  State<NewMenuCategoryScreen> createState() => _NewMenuCategoryScreenState();
}

final cuisines = [
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

class _NewMenuCategoryScreenState extends State<NewMenuCategoryScreen> {
  MenuCategoryModel category = MenuCategoryModel(
    menuCategoryName: "",
    menuDescription: "",
    menuList: [],
  );

  bool get isCuisineSelected => category.menuList.isNotEmpty;

  TextEditingController controller = TextEditingController();
  String value = '';

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);
  int maxLength = 100;

  @override
  void initState() {
    super.initState();
  }
  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          if (subTitle.isEmpty) ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p6),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
              },
              child: SGContainer(
                color: SGColors.primary,
                width: double.infinity,
                borderColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                    child: SGTypography.body("확인",
                        color: SGColors.white,
                        weight: FontWeight.w700,
                        size: FontSize.normal)),
              ),
            )
          ] else ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p4),
            Center(
                child: SGTypography.body(subTitle,
                    color: SGColors.gray4,
                    size: FontSize.small,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p6),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
              },
              child: SGContainer(
                color: SGColors.primary,
                width: double.infinity,
                borderColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                    child: SGTypography.body("확인",
                        color: SGColors.white,
                        weight: FontWeight.w700,
                        size: FontSize.normal)),
              ),
            )
          ]
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "메뉴 카테고리 추가"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                showFailDialogWithImage(mainTitle: "메뉴 카테고리 추가 실패", subTitle: "삭제된 메뉴가 포함되어있습니다.\n다시 한 번 시도해주세요.");
              },
              label: "추가하기")),
      body: SGContainer(
        width: double.infinity,
        color: Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            SGTypography.body("메뉴 카테고리명", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: TextField(
                  style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
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
                        controller: controller,
                        maxLines: 5,
                        style: baseStyle.copyWith(color: SGColors.black),
                        onChanged: (value) {
                          setState(() {
                            if (maxLength != null && value.length > maxLength!) {
                              controller.text = value.substring(0, maxLength!);
                              controller.selection = TextSelection.fromPosition(TextPosition(offset: maxLength!));
                              return;
                            }
                            this.value = value;
                          });
                        },
                        decoration: InputDecoration(
                          // vertically stretched suffix Icon
                          // suffixIcon: SGContainer(
                          //     width: SGSpacing.p16,
                          //     height: SGSpacing.p28 - SGSpacing.p2,
                          //     color: SGColors.success,
                          //     child: Column(children: [Icon(Icons.visibility)])),
                          //
                          // suffixIconConstraints: BoxConstraints(minHeight: 0),
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
            // TODO 입력
            SizedBox(height: SGSpacing.p6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SGTypography.body("메뉴", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("${category.menuList.length}",
                    size: FontSize.small, weight: FontWeight.w700, color: SGColors.gray3),
              ],
            ),
            SizedBox(height: SGSpacing.p3),
            ...[
              ...category.menuList.map((cuisine) {
                return [
                  _SelectedCuisineCard(
                    cuisine: cuisine,
                    onRemove: () {
                      // setState(() {
                      //   category =
                      //       category.copyWith(cuisines: category.menuList.where((c) => c.menuId != cuisine.menuId).toList());
                      // });
                    },
                  ),
                  SizedBox(height: SGSpacing.p3)
                ];
              }).flattened
            ].toList(),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                showCuisineSelectionBottomSheet(
                    context: context,
                    title: "메뉴 추가",
                    cuisines: cuisines,
                    onSelect: (selectedCuisines) {
                      // final sortedCuisines = selectedCuisines.toList()..sort((a, b) => a.menuId!.compareTo(b.menuId!));
                      // setState(() {
                      //   category = category.copyWith(cuisines: sortedCuisines);
                      // });
                    },
                    selectedCuisines: category.menuList);
              },
              child: SGContainer(
                  color: !isCuisineSelected ? SGColors.primary : SGColors.white,
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                  borderRadius: BorderRadius.circular(SGSpacing.p2),
                  borderColor: SGColors.primary,
                  child: Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (!isCuisineSelected)
                      ColorFiltered(
                          colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn),
                          child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3))
                    else
                      Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3),
                    SizedBox(width: SGSpacing.p2),
                    SGTypography.body("메뉴 추가",
                        size: FontSize.small,
                        weight: FontWeight.w500,
                        color: isCuisineSelected ? SGColors.primary : SGColors.white)
                  ]))),
            ),
            SizedBox(height: SGSpacing.p20),
          ],
        ),
      ),
    );
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
