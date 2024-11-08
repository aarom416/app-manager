import 'dart:io';

import 'package:collection/collection.dart';
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
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/providers/signup_provider.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';
import 'package:singleeat/screens/signup_complete_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) => pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(authenticateWithPhoneNumberNotifierProvider.notifier)
          .onChangeMethod(AuthenticateWithPhoneNumberMethod.SIGNUP);

      ref
          .read(signupNotifierProvider.notifier)
          .onChangeStatus(SignupStatus.step1);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signupNotifierProvider, (previous, next) {
      if (previous?.status != next.status) {
        switch (next.status) {
          case SignupStatus.step1:
            FocusScope.of(context).unfocus();
            animateToPage(0);
            break;
          case SignupStatus.step2:
            FocusScope.of(context).unfocus();
            animateToPage(1);
            break;
          case SignupStatus.step3:
            FocusScope.of(context).unfocus();
            animateToPage(2);
            break;
          case SignupStatus.step4:
            FocusScope.of(context).unfocus();
            animateToPage(3);
            break;
          case SignupStatus.step5:
            FocusScope.of(context).unfocus();
            animateToPage(4);
            break;
          case SignupStatus.error:
            showSGDialog(
                context: context,
                childrenBuilder: (ctx) => [
                      Center(
                        child: SGTypography.body(
                          '전화번호 인증을 실패하였습니다.',
                          size: FontSize.medium,
                          weight: FontWeight.normal,
                          align: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: SGSpacing.p5),
                      Row(children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(ctx).pop();
                            },
                            child: SGContainer(
                              color: SGColors.primary,
                              padding:
                                  EdgeInsets.symmetric(vertical: SGSpacing.p4),
                              borderRadius: BorderRadius.circular(SGSpacing.p3),
                              child: Center(
                                child: SGTypography.body("확인",
                                    size: FontSize.normal,
                                    weight: FontWeight.normal,
                                    color: SGColors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ]);
            break;
        }
      }
    });

    return Scaffold(
        body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
          AuthenticateWithPhoneNumberScreen(
              title: "회원가입",
              onPrev: () {
                FocusScope.of(context).unfocus();

                Navigator.pop(context);
              }),
          SignupFormScreen(onPrev: () {
            FocusScope.of(context).unfocus();

            animateToPage(0);
          }, onNext: () {
            FocusScope.of(context).unfocus();

            animateToPage(2);
          }),
          _TermCheckScreen(onPrev: () {
            FocusScope.of(context).unfocus();

            animateToPage(1);
          }, onNext: () {
            FocusScope.of(context).unfocus();

            animateToPage(3);
          }),
          _StoreRegistrationFormScreen(
            onPrev: () {
              FocusScope.of(context).unfocus();

              animateToPage(2);
            },
            onNext: () {
              FocusScope.of(context).unfocus();

              animateToPage(4);
            },
          ),
          const SignUpCompleteScreen(),
        ]));
  }
}

class _StoreRegistrationFormScreen extends ConsumerStatefulWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _StoreRegistrationFormScreen({
    super.key,
    required this.onPrev,
    required this.onNext,
  });

  @override
  ConsumerState<_StoreRegistrationFormScreen> createState() =>
      _StoreRegistrationFormScreenState();
}

class _StoreRegistrationFormScreenState
    extends ConsumerState<_StoreRegistrationFormScreen> {
  TextEditingController businessRegistrationController =
      TextEditingController();
  TextEditingController representativeNameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController storeNumberController = TextEditingController();

  File? _accountImage;
  File? _businessRegistrationImage;
  File? _operationImage;

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
    final state = ref.watch(signupNotifierProvider);
    final provider = ref.read(signupNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "싱그릿 식단 연구소"),
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
            ]);
  }
}

class _TermCheckScreen extends ConsumerStatefulWidget {
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _TermCheckScreen(
      {super.key, required this.onPrev, required this.onNext});

  @override
  ConsumerState<_TermCheckScreen> createState() => _TermCheckScreenState();
}

class _Term {
  bool checked;
  bool isRequired;
  String title;

  _Term({this.checked = false, required this.isRequired, required this.title});

  _Term copyWith({bool? checked, bool? isRequired, String? title}) {
    return _Term(
        checked: checked ?? this.checked,
        isRequired: isRequired ?? this.isRequired,
        title: title ?? this.title);
  }
}

class _TermCheckScreenState extends ConsumerState<_TermCheckScreen> {
  List<(String, bool)> _terms = [
    ("개인정보 수집 및 이용 동의", true),
    ("전자금융거래 이용약관 동의", true),
    ("고유식별정보 처리 동의", true),
    ("통신사 이용약관 동의", true),
    ("싱그릿 식단 연구소 수신 동의", false),
    ("부가 서비스 및 혜택 안내 동의", false),
  ];

  late List<_Term> terms = [
    ..._terms.map((e) => _Term(isRequired: e.$2, title: e.$1))
  ];

  bool get isAllChecked => terms.every((element) => element.checked);

  bool get isAllRequiredChecked => terms
      .where((element) => element.isRequired)
      .every((element) => element.checked);

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(signupNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "싱그릿 식단 연구소", onTap: widget.onPrev),
        body: SGContainer(
            color: SGColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("이용약관 동의",
                  size: FontSize.xlarge,
                  weight: FontWeight.w700,
                  color: SGColors.black),
              SizedBox(height: SGSpacing.p6),
              GestureDetector(
                onTap: () {
                  setState(() {
                    terms = terms
                        .map((e) => e.copyWith(checked: !isAllChecked))
                        .toList();
                  });
                },
                child: SGContainer(
                    borderColor: SGColors.line2,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    padding: EdgeInsets.all(SGSpacing.p4),
                    child: Row(children: [
                      Image.asset(
                          isAllChecked
                              ? "assets/images/checkbox-on.png"
                              : "assets/images/checkbox-off.png",
                          width: SGSpacing.p6,
                          height: SGSpacing.p6),
                      SizedBox(width: SGSpacing.p2),
                      SGTypography.body("모든 이용약관에 동의합니다.",
                          size: FontSize.medium,
                          weight: FontWeight.w600,
                          color: SGColors.black),
                    ])),
              ),
              ...terms
                  .mapIndexed((index, term) => [
                        SizedBox(height: SGSpacing.p3),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              terms = terms
                                  .mapIndexed((i, e) => i == index
                                      ? e.copyWith(checked: !e.checked)
                                      : e)
                                  .toList();
                            });
                          },
                          child: SGContainer(
                              padding: EdgeInsets.all(SGSpacing.p4),
                              child: Row(children: [
                                Image.asset(
                                    term.checked
                                        ? "assets/images/checkbox-on.png"
                                        : "assets/images/checkbox-off.png",
                                    width: SGSpacing.p6,
                                    height: SGSpacing.p6),
                                SizedBox(width: SGSpacing.p2),
                                SGTypography.body(term.title,
                                    size: FontSize.normal,
                                    weight: FontWeight.w600,
                                    color: SGColors.gray5),
                                SizedBox(width: SGSpacing.p1),
                                if (term.isRequired)
                                  SGTypography.body("(필수)",
                                      size: FontSize.normal,
                                      color: SGColors.primary,
                                      weight: FontWeight.w400)
                                else
                                  SGTypography.body("(선택)",
                                      size: FontSize.normal,
                                      color: SGColors.gray3,
                                      weight: FontWeight.w400),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,
                                    size: FontSize.small,
                                    color: SGColors.gray3),
                              ])),
                        ),
                      ])
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(
                onPressed: () {
                  for (int i = 0; i < terms.length; i++) {
                    if (terms[i].title == '싱그릿 식단 연구소 수신 동의') {
                      provider.onChangeIsSingleeatAgree(terms[i].checked);
                    } else if (terms[i].title == '부가 서비스 및 혜택 안내 동의') {
                      provider.onChangeIsAdditionalAgree(terms[i].checked);
                    }
                  }

                  if (isAllRequiredChecked) {
                    provider.changeStatus();
                  }
                },
                label: "확인",
                disabled: !isAllRequiredChecked,
              ),
              SizedBox(height: SGSpacing.p10),
            ])));
  }
}

class SignupFormScreen extends ConsumerStatefulWidget {
  VoidCallback onPrev;
  VoidCallback onNext;

  SignupFormScreen({super.key, required this.onPrev, required this.onNext});

  @override
  ConsumerState<SignupFormScreen> createState() => _SignupFormScreenState();
}

class _SignupFormScreenState extends ConsumerState<SignupFormScreen> {
  final loginIdFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final passwordConfirmFocusNode = FocusNode();

  late TextEditingController emailDomainController = TextEditingController();

  String emailInputOption = '직접 입력';

  List<SelectionOption<String>> emailInputOptions = [
    SelectionOption<String>(label: "naver.com", value: "naver.com"),
    SelectionOption<String>(label: "gmail.com", value: "gmail.com"),
    SelectionOption<String>(label: "daum.net", value: "daum.net"),
    SelectionOption<String>(label: "hanmail.net", value: "hanmail.net"),
    SelectionOption<String>(label: "nate.com", value: "nate.com"),
    SelectionOption<String>(label: "yahoo.com", value: "yahoo.com"),
    SelectionOption<String>(label: "직접 입력", value: "직접 입력"),
  ];

  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;

  bool get isFormValid {
    SignupState state = ref.read(signupNotifierProvider);
    return state.loginIdValid &&
        state.password.isNotEmpty &&
        state.passwordConfirm.isNotEmpty &&
        state.password == state.passwordConfirm &&
        (state.emailStatus == SignupEmailStatus.success);
  }

  @override
  void initState() {
    loginIdFocusNode.addListener(() {
      if (!loginIdFocusNode.hasFocus) {
        ref.read(signupNotifierProvider.notifier).loginIdValidation();
      }
    });

    passwordFocusNode.addListener(() {
      if (!passwordFocusNode.hasFocus) {
        ref.read(signupNotifierProvider.notifier).passwordValidation();
      }
    });

    passwordConfirmFocusNode.addListener(() {
      if (!passwordConfirmFocusNode.hasFocus) {
        ref.read(signupNotifierProvider.notifier).passwordConfirmValidation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SignupState state = ref.watch(signupNotifierProvider);
    SignupNotifier provider = ref.read(signupNotifierProvider.notifier);
    ref.listen(signupNotifierProvider, (previous, next) {
      if (previous?.emailStatus != next.emailStatus) {
        switch (next.emailStatus) {
          case SignupEmailStatus.push:
            showDialog("사장님 이메일로 인증메일을\n보내드렸습니다.");
            break;

          case SignupEmailStatus.success:
            showDialog("이메일 인증이 완료되었습니다.");
            break;

          case SignupEmailStatus.error:
            showFailDialogWithImage("인증에 실패하였습니다.\n잠시 후 다시 시도해주세요.", "");
            break;

          default:
            break;
        }
      }
    });

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "회원가입"),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            SGTypography.body("아이디",
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
                              focusNode: loginIdFocusNode,
                              onChanged: (value) {
                                provider.onChangeLoginId(value);
                              },
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
                                hintText: "아이디를 입력해주세요.",
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
                GestureDetector(
                  onTap: () {
                    provider.checkLoginId();
                  },
                  child: SGContainer(
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p3, vertical: SGSpacing.p5),
                      borderColor: state.loginIdValid
                          ? SGColors.gray4
                          : SGColors.primary,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(SGSpacing.p3),
                      child: Center(
                          child: SGTypography.body(
                              state.loginIdValid ? "사용가능" : "중복확인",
                              color: state.loginIdValid
                                  ? SGColors.gray4
                                  : SGColors.primary,
                              size: FontSize.small,
                              weight: FontWeight.w500))),
                )
              ],
            ),
            if (state.loginIdError.errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: SGSpacing.p2),
                child: Text(
                  state.loginIdError.errorMessage,
                  style: TextStyle(
                    fontSize: FontSize.tiny,
                    color: SGColors.warningRed,
                  ),
                ),
              ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("비밀번호",
                size: FontSize.small,
                weight: FontWeight.w500,
                color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                            focusNode: passwordFocusNode,
                            onChanged: (value) {
                              provider.onChangePassword(value);
                            },
                            style: TextStyle(
                                fontSize: FontSize.small,
                                color: SGColors.gray5),
                            obscureText: !passwordVisible,
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3,
                                  fontSize: FontSize.small,
                                  fontWeight: FontWeight.w400),
                              hintText: "8~16자의 영문, 숫자, 특수문자를 입력해주세요.",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero,
                                  borderSide: BorderSide.none),
                            )),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                          child: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: SGColors.gray3)),
                    ],
                  ),
                ],
              ),
            )),
            if (state.passwordValidError.errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: SGSpacing.p2),
                child: Text(
                  state.passwordValidError.errorMessage,
                  style: TextStyle(
                    fontSize: FontSize.tiny,
                    color: SGColors.warningRed,
                  ),
                ),
              ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("비밀번호 확인",
                size: FontSize.small,
                weight: FontWeight.w500,
                color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGTextFieldWrapper(
                child: SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                        focusNode: passwordConfirmFocusNode,
                        onChanged: (value) {
                          provider.onChangePasswordConfirm(value);
                        },
                        style: TextStyle(
                            fontSize: FontSize.small, color: SGColors.gray5),
                        obscureText: !passwordVisibleConfirm,
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintStyle: TextStyle(
                              color: SGColors.gray3,
                              fontSize: FontSize.small,
                              fontWeight: FontWeight.w400),
                          hintText: "비밀번호를 다시 한번 입력해주세요.",
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide.none),
                        )),
                  ),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisibleConfirm = !passwordVisibleConfirm;
                        });
                      },
                      child: Icon(
                          passwordVisibleConfirm
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: SGColors.gray3)),
                ],
              ),
            )),
            if (state.password.isNotEmpty &&
                state.passwordConfirm.isNotEmpty &&
                state.password != state.passwordConfirm) ...{
              SizedBox(height: SGSpacing.p2),
              SGTypography.body("비밀번호가 다릅니다.",
                  size: FontSize.tiny, color: SGColors.warningRed),
            },
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("이메일",
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
                                ref
                                    .read(signupNotifierProvider.notifier)
                                    .onChangeEmail(value);
                              },
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
                                hintText: "이메일 앞자리",
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ],
                    ),
                  )),
                ),
                SizedBox(width: SGSpacing.p4),
                SGTypography.body("@",
                    size: FontSize.medium,
                    weight: FontWeight.w500,
                    color: SGColors.gray4),
                SizedBox(width: SGSpacing.p4),
                Expanded(
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: emailInputOption == "직접 입력",
                              controller: emailDomainController,
                              onChanged: (value) {
                                ref
                                    .read(signupNotifierProvider.notifier)
                                    .onChangeDomain(value);
                              },
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
                                hintText: "이메일 뒷자리",
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
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            GestureDetector(
              onTap: () {
                showSelectionBottomSheet<String>(
                    context: context,
                    title: "이메일 뒷자리를 선택해주세요.",
                    options: emailInputOptions,
                    onSelect: (value) {
                      setState(() {
                        emailInputOption = value;
                        if (value == "직접 입력") {
                          emailDomainController.text = "";
                          ref
                              .read(signupNotifierProvider.notifier)
                              .onChangeDomain(value);
                        } else {
                          emailDomainController.text = value;
                          ref
                              .read(signupNotifierProvider.notifier)
                              .onChangeDomain(value);
                        }
                      });
                    },
                    selected: emailInputOption);
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              enabled: false,
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
                                hintText: emailInputOption,
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero,
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ],
                    ),
                  )),
                  SGContainer(
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                      child: Image.asset("assets/images/dropdown-arrow.png",
                          width: SGSpacing.p5, height: SGSpacing.p5))
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            if (state.isSendCode) ...[
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          onChanged: (value) {
                            provider.onChangeAuthCode(value);
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
                            hintText: "인증번호",
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          )),
                    ),
                  ],
                ),
              )),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              GestureDetector(
                onTap: () {
                  provider.verifyCode();
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p4 + SGSpacing.p05),
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이메일 인증 확인",
                            color: SGColors.primary,
                            weight: FontWeight.w500,
                            size: FontSize.small))),
              ),
            ] else ...[
              GestureDetector(
                onTap: () {
                  ref.read(signupNotifierProvider.notifier).sendCode();
                  // showDialog("사장님 이메일로 인증메일을\n보내드렸습니다.");
                  //
                },
                child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        vertical: SGSpacing.p4 + SGSpacing.p05),
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("이메일 인증",
                            color: SGColors.primary,
                            weight: FontWeight.w700,
                            size: FontSize.small))),
              ),
            ],
            SizedBox(height: SGSpacing.p24),
            SGActionButton(
                onPressed: () {
                  if (!isFormValid) return;
                  // widget.onNext();
                  provider.signUp();
                },
                label: "가입 완료",
                disabled: !isFormValid),
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
            ]);
  }
}
