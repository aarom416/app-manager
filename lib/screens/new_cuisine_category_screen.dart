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
import 'package:singleeat/office/components/cuisine_selection_bottom_sheet.dart';
import 'package:singleeat/office/models/cuisine_model.dart';

class NewCuisineCategoryScreen extends StatefulWidget {
  const NewCuisineCategoryScreen({super.key});

  @override
  State<NewCuisineCategoryScreen> createState() => _NewCuisineCategoryScreenState();
}

final cuisines = [
  Cuisine(
    id: 1,
    name: "김치찌개",
    price: 8000,
    description: "맛있는 김치찌개",
    image: "https://via.placeholder.com/150",
  ),
  Cuisine(
    id: 2,
    name: "된장찌개",
    price: 8000,
    description: "맛있는 된장찌개",
    image: "https://via.placeholder.com/150",
  ),
  Cuisine(
    id: 3,
    name: "부대찌개",
    price: 8000,
    description: "맛있는 부대찌개",
    image: "https://via.placeholder.com/150",
  ),
  Cuisine(
    id: 4,
    name: "김치찌개",
    price: 8000,
    description: "맛있는 김치찌개",
    image: "https://via.placeholder.com/150",
  ),
];

class _NewCuisineCategoryScreenState extends State<NewCuisineCategoryScreen> {
  CuisineCategory category = CuisineCategory(
    name: "",
    description: "",
    cuisines: [],
  );

  bool get isCuisineSelected => category.cuisines.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "메뉴 카테고리 추가"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p2),
              child: TextField(
                maxLines: 5,
                style: TextStyle(
                  color: SGColors.black,
                  fontSize: FontSize.small,
                ),
                decoration: InputDecoration(
                  hintText: "카테고리 설명을 입력해주세요.",
                  hintStyle: TextStyle(
                    color: SGColors.gray3,
                    fontSize: FontSize.small,
                  ),
                  border: InputBorder.none,
                ),
              ),
            )),
            // TODO 입력
            SizedBox(height: SGSpacing.p6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SGTypography.body("메뉴", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("${category.cuisines.length}",
                    size: FontSize.small, weight: FontWeight.w700, color: SGColors.gray3),
              ],
            ),
            SizedBox(height: SGSpacing.p3),
            ...[
              ...category.cuisines.map((cuisine) {
                return [
                  _SelectedCuisineCard(
                    cuisine: cuisine,
                    onRemove: () {
                      setState(() {
                        category =
                            category.copyWith(cuisines: category.cuisines.where((c) => c.id != cuisine.id).toList());
                      });
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
                      final sortedCuisines = selectedCuisines.toList()..sort((a, b) => a.id!.compareTo(b.id!));
                      setState(() {
                        category = category.copyWith(cuisines: sortedCuisines);
                      });
                    },
                    selectedCuisines: category.cuisines);
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
  final Cuisine cuisine;
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
                  child: Image.network(cuisine.image, width: SGSpacing.p18, height: SGSpacing.p18)),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(cuisine.name,
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
