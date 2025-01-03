import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_step_indicator.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/snackbar.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../../core/components/numeric_textfield.dart';
import '../../../../../../main.dart';
import '../../menu/menu_model_card.dart';
import '../../menu/menu_selection_bottom_sheet.dart';
import '../../model.dart';
import '../../provider.dart';
import '../addoption/screen.dart';

class AddOptionCategoryScreen extends ConsumerStatefulWidget {
  const AddOptionCategoryScreen({super.key});

  @override
  ConsumerState<AddOptionCategoryScreen> createState() =>
      _AddOptionCategoryScreenState();
}

class _AddOptionCategoryScreenState
    extends ConsumerState<AddOptionCategoryScreen> {
  PageController pageController = PageController();

  String menuOptionCategoryName = "";
  List<MenuOptionModel> selectedMenuOptions = [];
  int essentialStatus = 0;
  int minChoice = 0;
  int maxChoice = 0;
  List<MenuModel> appliedMenus = [];

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  Widget build(BuildContext context) {
    final MenuOptionsState state = ref.watch(menuOptionsNotifierProvider);
    final MenuOptionsNotifier provider =
        ref.read(menuOptionsNotifierProvider.notifier);

    return Scaffold(
      body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _Page_0_OptionCategoryName(
              menuOptionCategoryName: menuOptionCategoryName,
              onPrev: () => Navigator.of(context).pop(),
              onNext: () => animateToPage(1),
              onEditFunction: (menuOptionCategoryName) {
                setState(() {
                  this.menuOptionCategoryName = menuOptionCategoryName;
                });
              },
            ),
            _Page_1_MenuOptions(
              selectedMenuOptions: selectedMenuOptions,
              onPrev: () => animateToPage(0),
              onNext: () => animateToPage(2),
              onEditFunction: (selectedMenuOptions) {
                setState(() {
                  this.selectedMenuOptions = selectedMenuOptions;
                });
              },
            ),
            _Page_2_OptionEssential(
              essentialStatus: essentialStatus,
              minChoice: minChoice,
              maxChoice: maxChoice,
              selectedMenuOptionLength: selectedMenuOptions.length,
              onPrev: () => animateToPage(1),
              onNext: () => animateToPage(3),
              onEditFunction: (essentialStatus, minChoice, maxChoice) {
                setState(() {
                  this.essentialStatus = essentialStatus;
                  this.minChoice = minChoice;
                  this.maxChoice = maxChoice;
                });
              },
            ),
            _Page_3_AppliedMenus(
              storeMenuDTOList: state.storeMenuDTOList,
              appliedMenus: appliedMenus,
              onPrev: () => animateToPage(2),
              onNext: () => animateToPage(4),
              onEditFunction: (appliedMenus) {
                setState(() {
                  this.appliedMenus = appliedMenus;
                });
              },
            ),
            _Page_4_ConfirmAddition(
              menuOptionCategoryName: menuOptionCategoryName,
              selectedMenuOptions: selectedMenuOptions,
              essentialStatus: essentialStatus,
              minChoice: minChoice,
              maxChoice: maxChoice,
              appliedMenus: appliedMenus,
              onPrev: () => animateToPage(3),
              onEditFunction: (appliedMenus) {
                setState(() {
                  this.appliedMenus = appliedMenus;
                });
              },
              onNext: () => {
                provider
                    .createOptionCategory(
                  context,
                  menuOptionCategoryName,
                  selectedMenuOptions,
                  essentialStatus,
                  minChoice,
                  maxChoice,
                  appliedMenus,
                )
                    .then(
                  (success) {
                    logger
                        .d("updateMenuOptionCategoryUseMenu success $success");
                    if (success) {
                      if (mounted) {
                        showGlobalSnackBar(context, "성공적으로 등록되었습니다.");
                      }
                    }
                  },
                )
              },
            ),
          ]),
    );
  }
}

class _Page_0_OptionCategoryName extends StatefulWidget {
  final String menuOptionCategoryName;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(String) onEditFunction;

  const _Page_0_OptionCategoryName(
      {required this.menuOptionCategoryName,
      required this.onNext,
      required this.onPrev,
      required this.onEditFunction});

  @override
  State<_Page_0_OptionCategoryName> createState() =>
      _Page_0_OptionCategoryNameState();
}

class _Page_0_OptionCategoryNameState
    extends State<_Page_0_OptionCategoryName> {
  late String menuOptionCategoryName;
  late TextEditingController menuOptionCategoryNameController;

  @override
  void initState() {
    super.initState();
    menuOptionCategoryName = widget.menuOptionCategoryName;
    menuOptionCategoryNameController =
        TextEditingController(text: menuOptionCategoryName);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBarWithStepIndicator(
              title: "옵션 카테고리 추가",
              currentStep: 1,
              totalStep: 5,
              onTap: widget.onPrev),
          floatingActionButton: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                  maxHeight: 58),
              child: SGActionButton(
                  disabled: menuOptionCategoryName.isEmpty,
                  onPressed: () {
                    if (menuOptionCategoryName.isNotEmpty) {
                      widget.onEditFunction(menuOptionCategoryName);
                      FocusScope.of(context).unfocus();
                      widget.onNext();
                    }
                  },
                  label: "다음")),
          body: SGContainer(
              color: const Color(0xFFFAFAFA),
              padding: EdgeInsets.symmetric(
                  horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
              child: ListView(
                children: [
                  SGTypography.body("옵션 카테고리명을 입력해주세요.",
                      size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p3),
                  SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: TextField(
                        controller: menuOptionCategoryNameController,
                        onChanged: (value) {
                          setState(() {
                            menuOptionCategoryName = value;
                          });
                        },
                        style: TextStyle(
                            fontSize: FontSize.small, color: SGColors.gray5),
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintStyle: TextStyle(
                              color: SGColors.gray3,
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400),
                          hintText: "Ex) 2인 샐러드 포케 세트",
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none),
                        )),
                  )),
                ],
              ))),
    );
  }
}

class _Page_1_MenuOptions extends StatefulWidget {
  final List<MenuOptionModel> selectedMenuOptions;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(List<MenuOptionModel>) onEditFunction;

  const _Page_1_MenuOptions(
      {required this.selectedMenuOptions,
      required this.onNext,
      required this.onPrev,
      required this.onEditFunction});

  @override
  State<_Page_1_MenuOptions> createState() => _Page_1_MenuOptionsState();
}

class _Page_1_MenuOptionsState extends State<_Page_1_MenuOptions> {
  late List<MenuOptionModel> selectedMenuOptions;

  @override
  void initState() {
    super.initState();
    selectedMenuOptions = widget.selectedMenuOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithStepIndicator(
        title: "옵션 카테고리 추가",
        currentStep: 2,
        totalStep: 5,
        onTap: widget.onPrev,
      ),
      floatingActionButton: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
          maxHeight: 58,
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.onPrev,
                child: SGContainer(
                  color: SGColors.gray3,
                  padding: EdgeInsets.all(SGSpacing.p4),
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Center(
                    child: SGTypography.body(
                      "이전",
                      size: FontSize.large,
                      color: SGColors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: SGSpacing.p3),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (selectedMenuOptions.isNotEmpty) widget.onNext();
                },
                child: SGContainer(
                  color: selectedMenuOptions.isEmpty
                      ? SGColors.gray3
                      : SGColors.primary,
                  padding: EdgeInsets.all(SGSpacing.p4),
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Center(
                    child: SGTypography.body(
                      "다음",
                      size: FontSize.large,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(
          horizontal: SGSpacing.p4,
          vertical: SGSpacing.p6,
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: SGTypography.body(
                "옵션을 설정해주세요.",
                size: FontSize.normal,
                weight: FontWeight.w700,
              ),
            ),
            SizedBox(height: SGSpacing.p3),
            Expanded(
              child: ReorderableListView.builder(
                proxyDecorator: (child, index, animation) {
                  return Material(
                    color: Colors.transparent,
                    child: Transform.scale(
                      scale: 1.1,
                      child: child,
                    ),
                  );
                },
                physics: const BouncingScrollPhysics(),
                itemCount: selectedMenuOptions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    key: ValueKey(selectedMenuOptions[index].optionContent),
                    padding: EdgeInsets.only(bottom: SGSpacing.p2),
                    child: Row(
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              "assets/images/accordion.png",
                              width: SGSpacing.p4,
                              height: SGSpacing.p4,
                            ),
                          ),
                        ),
                        SizedBox(width: SGSpacing.p2),
                        Expanded(
                          child: __MenuOptionCard(
                            menuOption: selectedMenuOptions[index],
                            onRemove: (_) {
                              setState(() {
                                selectedMenuOptions.removeAt(index);
                              });
                              widget.onEditFunction(selectedMenuOptions);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                footer: Padding(
                  padding:
                      EdgeInsets.only(top: SGSpacing.p4, bottom: SGSpacing.p4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddOptionScreen(
                                menuOptionCategoryId: -1,
                                onSubmit: (menuOptionModel) {
                                  setState(() {
                                    selectedMenuOptions.add(menuOptionModel);
                                  });
                                  widget.onEditFunction(selectedMenuOptions);
                                },
                              )));
                    },
                    child: SGContainer(
                      color: SGColors.white,
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      borderColor: SGColors.primary,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/plus.png",
                              width: SGSpacing.p3,
                              height: SGSpacing.p3,
                            ),
                            SizedBox(width: SGSpacing.p2),
                            SGTypography.body(
                              "새 옵션 설정",
                              size: FontSize.small,
                              weight: FontWeight.w500,
                              color: SGColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    if (oldIndex < selectedMenuOptions.length) {
                      final item = selectedMenuOptions.removeAt(oldIndex);
                      selectedMenuOptions.insert(newIndex, item);
                    }
                  });
                  widget.onEditFunction(selectedMenuOptions);
                },
              ),
            ),
            SizedBox(height: SGSpacing.p24),
          ],
        ),
      ),
    );
  }
}

class __MenuOptionCard extends StatelessWidget {
  final MenuOptionModel menuOption;
  final Function(MenuOptionModel) onRemove;

  const __MenuOptionCard({
    super.key,
    required this.menuOption,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
                    SGTypography.body(menuOption.optionContent,
                        size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(height: SGSpacing.p3),
                    SGTypography.body("${menuOption.price.toKoreanCurrency}원",
                        size: FontSize.small, weight: FontWeight.w400),
                  ],
                ),
                Spacer(),
                GestureDetector(
                    onTap: () {
                      onRemove(menuOption);
                    },
                    child: SGContainer(
                      borderWidth: 0,
                      width: SGSpacing.p5,
                      height: SGSpacing.p5,
                      borderRadius:
                          BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                      color: SGColors.warningRed,
                      child: Center(
                          child: Image.asset('assets/images/minus-white.png',
                              width: 16, height: 16)),
                    )),
              ],
            )),
      ),
    ]);
  }
}

class _Page_2_OptionEssential extends StatefulWidget {
  final int essentialStatus;
  final int minChoice;
  final int maxChoice;
  final int selectedMenuOptionLength;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Function(int, int, int) onEditFunction;

  const _Page_2_OptionEssential({
    required this.essentialStatus,
    required this.minChoice,
    required this.maxChoice,
    required this.selectedMenuOptionLength,
    required this.onPrev,
    required this.onNext,
    required this.onEditFunction,
  });

  @override
  State<_Page_2_OptionEssential> createState() =>
      _Page_2_OptionEssentialState();
}

class _Page_2_OptionEssentialState extends State<_Page_2_OptionEssential> {
  late int essentialStatus;
  late int minChoice;
  late int maxChoice;

  @override
  void initState() {
    super.initState();
    essentialStatus = widget.essentialStatus;
    minChoice = widget.minChoice;
    maxChoice = widget.maxChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithStepIndicator(
          title: "옵션 카테고리 추가",
          currentStep: 3,
          totalStep: 5,
          onTap: widget.onPrev),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  widget.onEditFunction(essentialStatus, minChoice, maxChoice);
                  widget.onPrev();
                },
                child: SGContainer(
                    color: SGColors.gray3,
                    padding: EdgeInsets.all(SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이전",
                            size: FontSize.large,
                            color: SGColors.white,
                            weight: FontWeight.w700))),
              )),
              SizedBox(width: SGSpacing.p3),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  if (((essentialStatus == 0 && maxChoice >= 0) ||
                          (essentialStatus == 1 && maxChoice > 0)) &&
                      (minChoice <= widget.selectedMenuOptionLength &&
                          minChoice <= maxChoice) &&
                      maxChoice <= widget.selectedMenuOptionLength) {
                    widget.onEditFunction(
                        essentialStatus, minChoice, maxChoice);
                    widget.onNext();
                    FocusScope.of(context).unfocus();
                  }
                },
                child: SGContainer(
                    color: (((essentialStatus == 0 && maxChoice >= 0) ||
                                (essentialStatus == 1 && maxChoice > 0)) &&
                            (minChoice <= widget.selectedMenuOptionLength &&
                                minChoice <= maxChoice) &&
                            maxChoice <= widget.selectedMenuOptionLength)
                        ? SGColors.primary
                        : SGColors.gray3,
                    padding: EdgeInsets.all(SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body(
                      "다음",
                      size: FontSize.large,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ))),
              )),
            ],
          )),
      body: SGContainer(
        borderWidth: 0,
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(children: [
          SGTypography.body("옵션 필수 여부를 설정해주세요.",
              weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p4),
          SGContainer(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                  horizontal: SGSpacing.p4,
                  vertical: SGSpacing.p3 + SGSpacing.p05),
              borderColor: SGColors.line2,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(children: [
                SGTypography.body("필수 옵션", size: FontSize.normal),
                const Spacer(),
                SGSwitch(
                  value: essentialStatus == 1,
                  onChanged: (value) {
                    setState(() {
                      essentialStatus = value ? 1 : 0;
                      minChoice = value ? 1 : 0;
                    });
                  },
                ),
              ])),
          SizedBox(height: SGSpacing.p3),
          SGTypography.body("메뉴 주문 시 옵션을 필수로 선택해야 해요.", color: SGColors.gray4),
          SizedBox(height: SGSpacing.p8),
          SGTypography.body("옵션 선택 개수를 설정해주세요.",
              weight: FontWeight.w700, size: FontSize.normal),
          SizedBox(height: SGSpacing.p4),
          if (essentialStatus == 1) ...[
            SGTypography.body("최소",
                size: FontSize.small, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: NumericTextField(
                      key: const ValueKey('minChoice'),
                      readOnly: true,
                      initialValue: minChoice,
                      style: const TextStyle(
                              fontFamily: "Pretendard",
                              fontSize: FontSize.small)
                          .copyWith(color: SGColors.black),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(SGSpacing.p4),
                        isCollapsed: true,
                        hintStyle: TextStyle(
                            color: SGColors.gray3,
                            fontSize: FontSize.small,
                            fontWeight: FontWeight.w400),
                        hintText: minChoice.toKoreanCurrency,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onValueChanged: (minChoice) {
                        setState(() {
                          this.minChoice = minChoice;
                        });
                      },
                    ),
                  ),
                  SGTypography.body("개",
                      size: FontSize.small, color: SGColors.gray4),
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
                  child: NumericTextField(
                    key: const ValueKey('maxChoice'),
                    initialValue: maxChoice,
                    style: const TextStyle(
                            fontFamily: "Pretendard", fontSize: FontSize.small)
                        .copyWith(color: SGColors.black),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(SGSpacing.p4),
                      isCollapsed: true,
                      hintStyle: TextStyle(
                          color: SGColors.gray3,
                          fontSize: FontSize.small,
                          fontWeight: FontWeight.w400),
                      hintText: maxChoice.toKoreanCurrency,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none),
                    ),
                    onValueChanged: (maxChoice) {
                      setState(() {
                        this.maxChoice = maxChoice;
                      });
                    },
                  ),
                ),
                SGTypography.body("개",
                    size: FontSize.small, color: SGColors.gray4),
                SizedBox(width: SGSpacing.p4),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Page_3_AppliedMenus extends StatefulWidget {
  final List<MenuModel> storeMenuDTOList;
  final List<MenuModel> appliedMenus;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(List<MenuModel>) onEditFunction;

  const _Page_3_AppliedMenus(
      {required this.storeMenuDTOList,
      required this.appliedMenus,
      required this.onNext,
      required this.onPrev,
      required this.onEditFunction});

  @override
  State<_Page_3_AppliedMenus> createState() => _Page_3_AppliedMenusState();
}

class _Page_3_AppliedMenusState extends State<_Page_3_AppliedMenus> {
  late List<MenuModel> appliedMenus;

  @override
  void initState() {
    super.initState();
    appliedMenus = widget.appliedMenus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(
            title: "옵션 카테고리 추가",
            currentStep: 4,
            totalStep: 5,
            onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onEditFunction(appliedMenus);
                    widget.onPrev();
                  },
                  child: SGContainer(
                      color: SGColors.gray3,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body("이전",
                              size: FontSize.large,
                              color: SGColors.white,
                              weight: FontWeight.w700))),
                )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    widget.onEditFunction(appliedMenus);
                    widget.onNext();
                  },
                  child: SGContainer(
                      color: SGColors.primary,
                      padding: EdgeInsets.all(SGSpacing.p4),
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body(
                        "다음",
                        size: FontSize.large,
                        color: SGColors.white,
                        weight: FontWeight.w700,
                      ))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("옵션을 포함할 메뉴를 선택해주세요.",
                    size: FontSize.normal, weight: FontWeight.w700),
                if (widget.appliedMenus.isEmpty) ...[
                  SizedBox(height: SGSpacing.p3),
                  GestureDetector(
                      onTap: () {
                        _showSelectableMenuModelsBottomSheet(context);
                      },
                      child: SGContainer(
                          color: SGColors.white,
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                          borderRadius: BorderRadius.circular(SGSpacing.p2),
                          borderColor: SGColors.primary,
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                SGTypography.body("메뉴 선택하기",
                                    size: FontSize.small,
                                    weight: FontWeight.w500,
                                    color: SGColors.primary)
                              ]))))
                ] else ...[
                  ...appliedMenus
                      .mapIndexed(
                        (index, menuModel) => [
                          SizedBox(height: SGSpacing.p3),
                          MenuModelCard(
                              menuModel: menuModel,
                              onRemove: () {
                                final updatedAppliedMenus =
                                    List<MenuModel>.from(appliedMenus);
                                updatedAppliedMenus.removeAt(index);
                                setState(() {
                                  appliedMenus = updatedAppliedMenus;
                                });
                              }),
                        ],
                      )
                      .flattened,
                  SizedBox(height: SGSpacing.p3),
                  GestureDetector(
                      onTap: () {
                        _showSelectableMenuModelsBottomSheet(context);
                      },
                      child: SGContainer(
                          color: SGColors.white,
                          padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                          borderRadius: BorderRadius.circular(SGSpacing.p2),
                          borderColor: SGColors.primary,
                          child: Center(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Image.asset("assets/images/plus.png",
                                    width: SGSpacing.p3, height: SGSpacing.p3),
                                SizedBox(width: SGSpacing.p2),
                                SGTypography.body("메뉴 추가하기",
                                    size: FontSize.small,
                                    weight: FontWeight.w500,
                                    color: SGColors.primary)
                              ]))))
                ]
              ],
            )));
  }

  void _showSelectableMenuModelsBottomSheet(BuildContext context) {
    return showSelectableMenuModelsBottomSheet(
        context: context,
        title: "메뉴 추가",
        menuModels: widget.storeMenuDTOList,
        onSelect: (selectedMenuList) {
          setState(() {
            appliedMenus = selectedMenuList.toList()
              ..sort((a, b) => a.menuName.compareTo(b.menuName));
          });
        },
        selectedMenus: appliedMenus);
  }
}

class _Page_4_ConfirmAddition extends StatefulWidget {
  final String menuOptionCategoryName;
  final List<MenuOptionModel> selectedMenuOptions;
  final int essentialStatus;
  final int minChoice;
  final int maxChoice;
  final List<MenuModel> appliedMenus;
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Function(List<MenuModel>) onEditFunction;

  const _Page_4_ConfirmAddition({
    required this.menuOptionCategoryName,
    required this.selectedMenuOptions,
    required this.essentialStatus,
    required this.minChoice,
    required this.maxChoice,
    required this.appliedMenus,
    required this.onNext,
    required this.onPrev,
    required this.onEditFunction,
  });

  @override
  State<_Page_4_ConfirmAddition> createState() =>
      _Page_4_ConfirmAdditionState();
}

class _Page_4_ConfirmAdditionState extends State<_Page_4_ConfirmAddition> {
  late List<MenuModel> appliedMenus;

  @override
  void initState() {
    super.initState();
    appliedMenus = widget.appliedMenus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithStepIndicator(
            title: "옵션 카테고리 추가",
            currentStep: 5,
            totalStep: 5,
            onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                maxHeight: 58),
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
                              size: FontSize.large,
                              color: SGColors.white,
                              weight: FontWeight.w700))),
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
                          child: SGTypography.body("카테고리 추가",
                              size: FontSize.medium,
                              color: SGColors.white,
                              weight: FontWeight.w700))),
                )),
              ],
            )),
        body: SGContainer(
            color: const Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(
              children: [
                SGTypography.body("마지막으로 한 번 더 확인해주세요.",
                    size: FontSize.large, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p8),
                SGTypography.body("옵션 카테고리명",
                    size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body(widget.menuOptionCategoryName,
                          size: FontSize.normal,
                          weight: FontWeight.w400,
                          color: SGColors.gray5),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body(
                  "옵션명",
                  size: FontSize.normal,
                  weight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  borderColor: SGColors.line3,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  child: Column(
                    children: widget.selectedMenuOptions.map((menuOption) {
                      return Row(
                        children: [
                          SGTypography.body(menuOption.optionContent,
                              size: FontSize.normal,
                              weight: FontWeight.w400,
                              color: SGColors.gray5),
                          const Spacer(),
                          SGTypography.body(
                              "${menuOption.price.toKoreanCurrency}원",
                              size: FontSize.normal,
                              weight: FontWeight.w500,
                              color: SGColors.gray4),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                SGContainer(),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("필수 여부",
                    size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body(
                          widget.essentialStatus == 1 ? "필수 옵션" : "필수 아님",
                          size: FontSize.normal),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("선택 개수",
                    size: FontSize.normal, weight: FontWeight.w700),
                SizedBox(height: SGSpacing.p5 / 2),
                SGContainer(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Row(children: [
                      SGTypography.body(
                          "최소 ${widget.minChoice}개, 최대 ${widget.maxChoice}개",
                          size: FontSize.normal,
                          weight: FontWeight.w400,
                          color: SGColors.gray5),
                    ])),
                SizedBox(height: SGSpacing.p15 / 2),
                SGTypography.body("이 옵션을 포함하는 메뉴",
                    size: FontSize.normal, weight: FontWeight.w700),
                ...appliedMenus
                    .mapIndexed(
                      (index, menuModel) => [
                        SizedBox(height: SGSpacing.p3),
                        MenuModelCard(
                            menuModel: menuModel,
                            onRemove: () {
                              final updatedAppliedMenus =
                                  List<MenuModel>.from(appliedMenus);
                              updatedAppliedMenus.removeAt(index);
                              widget.onEditFunction(updatedAppliedMenus);

                              setState(() {
                                // appliedMenus = updatedAppliedMenus;
                              });
                            }),
                      ],
                    )
                    .flattened,
                SizedBox(height: SGSpacing.p32),
              ],
            )));
  }
}
