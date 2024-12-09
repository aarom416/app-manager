import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../menu_selection_bottom_sheet.dart';
import '../../model.dart';
import '../../provider.dart';

class AddMenuCategoryScreen extends ConsumerStatefulWidget {
  const AddMenuCategoryScreen({super.key});

  @override
  ConsumerState<AddMenuCategoryScreen> createState() => _AddMenuCategoryScreenState();
}

class _AddMenuCategoryScreenState extends ConsumerState<AddMenuCategoryScreen> {
  List<MenuModel> selectedMenuList = [];

  bool get isMenuSelected => selectedMenuList.isNotEmpty;

  final int MENU_CATEGORY_DESCRIPTION_INPUT_MAX = 100;
  TextEditingController menuCategoryDescriptionController = TextEditingController();
  String menuCategoryDescription = '';

  TextEditingController menuCategoryNameController = TextEditingController();
  String menuCategoryName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider = ref.read(menuOptionsNotifierProvider.notifier);
    // logger.i("selectedMenuList.toFormattedJson ${selectedMenuList.toFormattedJson()}");

    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "메뉴 카테고리 추가"),

      // --------------------------- 하단 추가하기 버튼 ---------------------------
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                // todo !!정의된 삭제된 메뉴 판단기준이 발견되지 않음.
                // showFailDialogWithImage(context: context, mainTitle: "해당 메뉴는 삭제된 메뉴입니다.", subTitle: "삭제된 메뉴가 포함되어있습니다.\n다시 한 번 시도해주세요.");
                provider.createMenuCategory(MenuCategoryModel(
                  menuCategoryName: menuCategoryName,
                  menuDescription: menuCategoryDescription,
                  menuList: selectedMenuList,
                ));
                Navigator.of(context).pop();
              },
              label: "추가하기",
              disabled: menuCategoryDescription == '' || menuCategoryName == '' || selectedMenuList.isEmpty)),

      body: SGContainer(
        width: double.infinity,
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            // --------------------------- 메뉴 카테고리명 입력 ---------------------------
            SGTypography.body("메뉴 카테고리명", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: TextField(
                  controller: menuCategoryNameController,
                  style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
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

            // --------------------------- 메뉴 카테고리 설명 입력 ---------------------------
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

            SizedBox(height: SGSpacing.p6),

            // --------------------------- selected 메뉴 리스트 ---------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SGTypography.body("메뉴", size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("${selectedMenuList.length}", size: FontSize.small, weight: FontWeight.w700, color: SGColors.gray3),
              ],
            ),
            SizedBox(height: SGSpacing.p3),
            ...selectedMenuList.map((menuModel) {
              return [
                _SelectedMenuCard(
                  menuModel: menuModel,
                  onRemove: () {
                    setState(() {
                      selectedMenuList.removeWhere((menuModel_) => menuModel_.menuId == menuModel.menuId);
                    });
                  },
                ),
                SizedBox(height: SGSpacing.p3)
              ];
            }).flattened,

            SizedBox(height: SGSpacing.p3),

            // --------------------------- selectable 메뉴 리스트 ---------------------------
            GestureDetector(
              onTap: () {
                showSelectableMenuModelsBottomSheet(
                    context: context,
                    title: "메뉴 추가",
                    menuModels: state.storeMenuDTOList,
                    onSelect: (selectedMenuList) {
                      setState(() {
                        this.selectedMenuList = selectedMenuList.toList()..sort((a, b) => a.menuName.compareTo(b.menuName));
                      });
                    },
                    selectedMenus: selectedMenuList);
              },
              child: SGContainer(
                  color: !isMenuSelected ? SGColors.primary : SGColors.white,
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                  borderRadius: BorderRadius.circular(SGSpacing.p2),
                  borderColor: SGColors.primary,
                  child: Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    if (!isMenuSelected)
                      ColorFiltered(colorFilter: ColorFilter.mode(SGColors.white, BlendMode.srcIn), child: Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3))
                    else
                      Image.asset("assets/images/plus.png", width: SGSpacing.p3, height: SGSpacing.p3),
                    SizedBox(width: SGSpacing.p2),
                    SGTypography.body("메뉴 추가", size: FontSize.small, weight: FontWeight.w500, color: isMenuSelected ? SGColors.primary : SGColors.white)
                  ]))),
            ),

            SizedBox(height: SGSpacing.p20),
          ],
        ),
      ),
    );
  }
}

class _SelectedMenuCard extends StatelessWidget {
  final MenuModel menuModel;
  final VoidCallback onRemove;

  const _SelectedMenuCard({super.key, required this.menuModel, required this.onRemove});

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
              ClipRRect(borderRadius: BorderRadius.circular(SGSpacing.p4), child: Image.network(menuModel.menuPictureURL, width: SGSpacing.p18, height: SGSpacing.p18)),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body(menuModel.menuName, color: SGColors.black, size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("${menuModel.price.toKoreanCurrency}원", color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
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
