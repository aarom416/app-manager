import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/store_registration_form_provider.dart';

class StoreRegistrationFormScreen extends ConsumerStatefulWidget {
  const StoreRegistrationFormScreen({
    super.key,
  });

  @override
  ConsumerState<StoreRegistrationFormScreen> createState() =>
      _StoreRegistrationFormScreenState();
}

class _StoreRegistrationFormScreenState
    extends ConsumerState<StoreRegistrationFormScreen> {
  TextEditingController businessRegistrationController =
      TextEditingController();
  TextEditingController representativeNameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();

  String representativeName = '';
  String storeName = '';
  String storeAddress = '';
  String businessType = '';
  String storeNumber = '';
  String category = "";
  List<String> selectedCategories = [];

  List<SelectionOption<String>> categoryOptions = [
    SelectionOption(label: "샐러드", value: "샐러드"),
    SelectionOption(label: "포케", value: "포케"),
    SelectionOption(label: "샌드위치", value: "샌드위치"),
    SelectionOption(label: "카페", value: "카페"),
    SelectionOption(label: "베이커리", value: "베이커리"),
    SelectionOption(label: "버거", value: "버거"),
  ];

  List<SelectionOption<String>> businessTypeOptions = [
    SelectionOption(label: "일반 과세자", value: "일반 과세자"),
    SelectionOption(label: "간이 과세자", value: "간이 과세자"),
    SelectionOption(label: "법인 과세자", value: "법인 과세자"),
    SelectionOption(label: "부가가치세 면세 사업자", value: "부가가치세 면세 사업자"),
    SelectionOption(label: "면세 법인 사업자", value: "면세 법인 사업자"),
  ];

  bool essentialTermChecked = false;

  bool get isFormValid => essentialTermChecked;

  @override
  Widget build(BuildContext context) {
    ref.listen(storeRegistrationFormNotifierProvider, (previous, next) {
      if (previous?.status != next.status) {
        switch (next.status) {
          case StoreRegistrationFormStatus.init:
            break;
          case StoreRegistrationFormStatus.success:
            ref
                .read(goRouterProvider)
                .go(AppRoutes.signupComplete, extra: UniqueKey());
            break;
          case StoreRegistrationFormStatus.error:
            break;
        }
      }
    });

    final state = ref.watch(storeRegistrationFormNotifierProvider);
    final provider = ref.read(storeRegistrationFormNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: "싱그릿 식단 연구소",
            onTap: () {
              ref.read(goRouterProvider).go(AppRoutes.login);
            }),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            SGTypography.body("식단 연구소 입점 신청서",
                size: FontSize.xlarge,
                weight: FontWeight.w700,
                color: SGColors.black),
            SizedBox(height: SGSpacing.p5),
            SGTypography.body("안녕하세요 싱그릿입니다.\n가게 입점을 위해 다음의 정보를 입력해 주세요.",
                size: FontSize.normal,
                weight: FontWeight.w400,
                color: SGColors.gray5,
                lineHeight: 1.15),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body(
                "가게 입점 신청서 작성 후, 싱그릿 담당자가\n가게 입점 절차 진행을 위해 연락 드립니다.",
                size: FontSize.normal,
                weight: FontWeight.w400,
                color: SGColors.gray5,
                lineHeight: 1.15),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body(
                "작성 중 어려움이 있으시면 고객센터(1600-7723)로\n연락 주시면 친절하게 도와드리겠습니다.",
                size: FontSize.normal,
                weight: FontWeight.w400,
                color: SGColors.gray5,
                lineHeight: 1.15),
            SizedBox(height: SGSpacing.p6),
            SGTypography.body("연구소 입점 절차",
                size: FontSize.large,
                weight: FontWeight.w700,
                color: SGColors.black),
            SizedBox(height: SGSpacing.p7),
            Image.asset("assets/images/onboarding.png", width: double.infinity),
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("사업자 등록번호",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  provider.onChangeBusinessNumber(value);
                                },
                                controller: businessRegistrationController,
                                enabled: state.isBusinessNumber ? false : true,
                                style: state.isBusinessNumber
                                    ? TextStyle(
                                        color: SGColors.gray3,
                                        fontSize: FontSize.small,
                                        fontWeight: FontWeight.w400)
                                    : TextStyle(
                                        fontSize: FontSize.small,
                                        color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "'-'없이 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                  SizedBox(width: SGSpacing.p2),
                  InkWell(
                    onTap: () {
                      provider.checkBusinessNumber().then((value) {
                        if (value) {
                          showDialog("조회에 성공하였습니다.");
                        } else {
                          showFailDialogWithImage(
                              "입력하신 정보를\n다시 한번 조회해주세요.", "");
                        }
                      });
                    },
                    child: SGContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: SGSpacing.p3, vertical: SGSpacing.p5),
                        borderColor: SGColors.primary,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        child: Center(
                            child: SGTypography.body("번호조회",
                                color: SGColors.primary,
                                size: FontSize.small,
                                weight: FontWeight.w500))),
                  )
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("대표자명",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                onChanged: (value) {
                                  provider.onChangeCeoName(value);
                                },
                                controller: representativeNameController,
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "대표자명을 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("가게 이름",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                onChanged: (value) {
                                  provider.onChangeStoreName(value);
                                },
                                controller: storeNameController,
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "가게 이름을 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("가게 주소",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                onChanged: (value) {
                                  provider.onChangeAddress(value);
                                },
                                controller: storeAddressController,
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "가게의 상세 주소도 같이 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("가게 번호",
                  size: FontSize.small,
                  weight: FontWeight.w500,
                  color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                        child: SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  provider.onChangePhone(value);
                                },
                                controller: storeNumberController,
                                style: TextStyle(
                                    fontSize: FontSize.small,
                                    color: SGColors.gray5),
                                decoration: InputDecoration(
                                  isDense: true,
                                  isCollapsed: true,
                                  hintStyle: TextStyle(
                                      color: SGColors.gray3,
                                      fontSize: FontSize.small,
                                      fontWeight: FontWeight.w400),
                                  hintText: "연락이 가능한 가게 번호를 입력해주세요.",
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.zero,
                                      borderSide: BorderSide.none),
                                )),
                          ),
                        ],
                      ),
                    )),
                  ),
                ],
              ),
            ],
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("가게 카테고리",
                size: FontSize.small,
                weight: FontWeight.w500,
                color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            GestureDetector(
              onTap: () {
                showSelectionBottomSheetWithSecondTitle<String>(
                  context: context,
                  title: "가게 카테고리",
                  secondTitle: "중복 선택이 가능하며 어떤 카테고리에 속하는지 골라주세요.",
                  options: categoryOptions,
                  onSelect: (List<String> selectedValues) {
                    setState(() {
                      // selectedValues를 selectedCategories와 동일하게 설정
                      selectedCategories.clear();
                      selectedCategories.addAll(selectedValues);

                      print("최종 선택된 카테고리: $selectedCategories");
                    });
                    provider.onChangeCategory(selectedValues);
                  },
                  selected: List.from(selectedCategories), // 선택된 카테고리 전달
                );
              },
              child: SGTextFieldWrapper(
                child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Row(
                    children: [
                      SGTypography.body(
                        selectedCategories.isNotEmpty
                            ? selectedCategories.join(', ')
                            : '가게가 어떤 카테고리에 속하는지 골라주세요.',
                        color: selectedCategories.isNotEmpty
                            ? SGColors.black
                            : SGColors.gray3,
                        size: FontSize.small,
                        weight: FontWeight.w400,
                      ),
                      Spacer(),
                      Image.asset('assets/images/dropdown-arrow.png',
                          width: 16, height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("사업자 구분",
                size: FontSize.small,
                weight: FontWeight.w500,
                color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            GestureDetector(
              onTap: () {
                showSelectionBottomSheet<String>(
                  context: context,
                  title: "사업자 구분",
                  options: businessTypeOptions,
                  onSelect: (String selectedValues) {
                    setState(() {
                      businessType = selectedValues;
                    });
                    provider.onChangeBusinessType(selectedValues);
                  },
                  selected: businessType,
                );
              },
              child: SGTextFieldWrapper(
                child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  child: Row(
                    children: [
                      SGTypography.body(
                        businessType == '' ? "사업자를 구분해주세요." : businessType,
                        color: businessType == ''
                            ? SGColors.gray3
                            : SGColors.black,
                        size: FontSize.small,
                        weight: FontWeight.w400,
                      ),
                      Spacer(),
                      Image.asset('assets/images/dropdown-arrow.png',
                          width: 16, height: 16),
                    ],
                  ),
                ),
              ),
            ),
            ...[
              SizedBox(height: SGSpacing.p8),
              Row(children: [
                SGTypography.body("통장 사본",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("(필수)",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.primary),
              ]),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              InkWell(
                onTap: () async {
                  String message = await provider.onChangeAccountPicture();
                  if (message.isNotEmpty) showFailDialogWithImage(message, "");
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(
                      children: [
                        SGTypography.body(
                            (state.accountPicture == null)
                                ? "파일 업로드"
                                : state.accountPicture!.name,
                            color: SGColors.primary,
                            size: FontSize.small,
                            weight: FontWeight.w400),
                        Spacer(),
                        Image.asset("assets/images/upload.png",
                            width: SGSpacing.p4, height: SGSpacing.p4),
                      ],
                    )),
              ),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                  child: Row(
                children: [
                  SGTypography.body("10MB 이하, jpg, png, pdf 형식의 파일을 등록해주세요.",
                      color: SGColors.gray4,
                      size: FontSize.tiny,
                      weight: FontWeight.w400),
                ],
              ))
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              Row(children: [
                SGTypography.body("사업자등록증 사본",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("(필수)",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.primary),
              ]),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              InkWell(
                onTap: () async {
                  String message =
                      await provider.onChangeBusinessRegistrationPicture();
                  if (message.isNotEmpty) showFailDialogWithImage(message, "");
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(
                      children: [
                        SGTypography.body(
                            (state.businessRegistrationPicture == null)
                                ? "반드시 금년도에 발급한 사본을 보내주세요."
                                : state.businessRegistrationPicture!.name,
                            color: SGColors.primary,
                            size: FontSize.small,
                            weight: FontWeight.w400),
                        Spacer(),
                        Image.asset("assets/images/upload.png",
                            width: SGSpacing.p4, height: SGSpacing.p4),
                      ],
                    )),
              ),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                  child: Row(
                children: [
                  SGTypography.body("10MB 이하, jpg, png, pdf 형식의 파일을 등록해주세요.",
                      color: SGColors.gray4,
                      size: FontSize.tiny,
                      weight: FontWeight.w400),
                ],
              ))
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              Row(children: [
                SGTypography.body("영업신고증 사본",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("(선택)",
                    size: FontSize.small,
                    weight: FontWeight.w500,
                    color: SGColors.primary),
              ]),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              InkWell(
                onTap: () async {
                  String message =
                      await provider.onChangeBusinessPermitPicture();
                  if (message.isNotEmpty) showFailDialogWithImage(message, "");
                },
                child: SGContainer(
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(
                      children: [
                        SGTypography.body(
                            (state.businessPermitPicture == null)
                                ? "반드시 금년도에 발급한 사본을 보내주세요."
                                : state.businessPermitPicture!.name,
                            color: SGColors.primary,
                            size: FontSize.small,
                            weight: FontWeight.w400),
                        const Spacer(),
                        Image.asset("assets/images/upload.png",
                            width: SGSpacing.p4, height: SGSpacing.p4),
                      ],
                    )),
              ),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                  child: Row(
                children: [
                  SGTypography.body("10MB 이하, jpg, png, pdf 형식의 파일을 등록해주세요.",
                      color: SGColors.gray4,
                      size: FontSize.tiny,
                      weight: FontWeight.w400),
                ],
              ))
            ],
            SizedBox(height: SGSpacing.p14),
            SGActionButton(
                onPressed: () {
                  if (state.businessNumber.isNotEmpty &&
                      state.ceoName.isNotEmpty &&
                      state.storeName.isNotEmpty &&
                      state.address.isNotEmpty &&
                      state.phone.isNotEmpty &&
                      state.category.isNotEmpty &&
                      state.businessType != -1 &&
                      state.accountPicture != null &&
                      state.businessRegistrationPicture != null &&
                      state.businessPermitPicture != null) {
                    provider.enroll();
                  }
                },
                label: "연구소 입점 신청하기",
                disabled: !(state.businessNumber.isNotEmpty &&
                    state.ceoName.isNotEmpty &&
                    state.storeName.isNotEmpty &&
                    state.address.isNotEmpty &&
                    state.phone.isNotEmpty &&
                    state.category.isNotEmpty &&
                    state.businessType != -1 &&
                    state.accountPicture != null &&
                    state.businessRegistrationPicture != null &&
                    state.businessPermitPicture != null)),
          ]),
        ));
  }

  void showDialog(String message) {
    showSGDialog(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(message,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              SizedBox(height: SGSpacing.p8),
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
            ]);
  }

  void showFailDialogWithImage(String mainTitle, String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              Center(
                  child: SGTypography.body(mainTitle,
                      size: FontSize.medium,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              Center(
                  child: SGTypography.body(subTitle,
                      color: SGColors.gray4,
                      size: FontSize.small,
                      weight: FontWeight.w700,
                      lineHeight: 1.25,
                      align: TextAlign.center)),
              SizedBox(height: SGSpacing.p4),
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
            ]);
  }
}
