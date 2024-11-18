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
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/providers/authenticate_with_phone_number_provider.dart';
import 'package:singleeat/office/providers/signup_provider.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';
import 'package:singleeat/screens/signup_complete_screen.dart';
import 'package:singleeat/screens/store_registration_form_screen.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  PageController pageController = PageController();

  void animateToPage(int index) =>
      pageController.animateToPage(
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
            ref
                .read(goRouterProvider)
                .go(AppRoutes.storeRegistrationForm, extra: UniqueKey());
            break;
          case SignupStatus.error:
            showSGDialog(
                context: context,
                childrenBuilder: (ctx) =>
                [
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
              }),
              const StoreRegistrationFormScreen(),
              const SignUpCompleteScreen(),
            ]));
  }
}

class _SignUpCompleteScreen extends StatefulWidget {
  VoidCallback onLogout;
  VoidCallback onPrev;

  _SignUpCompleteScreen({
    super.key,
    required this.onLogout,
    required this.onPrev,
  });

  @override
  State<_SignUpCompleteScreen> createState() => _SignUpCompleteScreenState();
}

class _SignUpCompleteScreenState extends State<_SignUpCompleteScreen> {
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "싱그릿 식단 연구소", onTap: widget.onPrev),
        floatingActionButton: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width - SGSpacing.p8,
                maxHeight: 58),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.onLogout();
                      },
                      child: SGContainer(
                          color: SGColors.gray1,
                          padding: EdgeInsets.all(SGSpacing.p4),
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          child: Center(
                              child: SGTypography.body("로그아웃",
                                  size: FontSize.large,
                                  color: SGColors.gray5,
                                  weight: FontWeight.w700))),
                    )),
                SizedBox(width: SGSpacing.p3),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _ProfileEditScreen()));
                      },
                      child: SGContainer(
                          color: SGColors.primary,
                          padding: EdgeInsets.all(SGSpacing.p4),
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          child: Center(
                              child: SGTypography.body("내 정보",
                                  size: FontSize.large,
                                  color: SGColors.white,
                                  weight: FontWeight.w700))),
                    )),
              ],
            )),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (toggled)
                  _GreetingScreen()
                else
                  _NotRegisteredScreen(
                    onPressActionButton: () {
                      setState(() {
                        toggled = true;
                      });
                    },
                  )
              ])),
        ));
  }
}

class _ProfileEditScreen extends StatefulWidget {
  _ProfileEditScreen({
    super.key,
  });

  @override
  State<_ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<_ProfileEditScreen> {
  late TextEditingController usernameController =
  TextEditingController(text: "singleat");
  late TextEditingController nameController =
  TextEditingController(text: "싱그릿");
  late TextEditingController authCodeController =
  TextEditingController(text: "");
  late TextEditingController emailController =
  TextEditingController(text: "singleeat@singleeat.com");
  late TextEditingController phoneNumberController =
  TextEditingController(text: "010-1234-5678");

  String username = "singleat";
  String name = "싱그릿";
  bool emailAuthRequested = false;
  bool emailAuthConfirmed = false;
  String email = "singleeat@singleat.com";
  String phoneNumber = "010-1234-5678";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "싱그릿 식단 연구소"),
        body: SGContainer(
          color: SGColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            ...[
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
                                    enabled: false,
                                    controller: usernameController,
                                    onChanged: (value) {
                                      setState(() {
                                        username = value;
                                      });
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
                ],
              ),
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("이름",
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
                                    controller: nameController,
                                    enabled: false,
                                    onChanged: (value) {
                                      setState(() {
                                        name = value;
                                      });
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
                                      hintText: "이름을 입력해주세요.",
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
                                    enabled: false,
                                    controller: emailController,
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
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
                                      hintText: "이메일을 입력해주세요.",
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
            if (emailAuthRequested) ...[
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
                                    controller: authCodeController,
                                    onChanged: (value) {
                                      // 인증코드
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
                                      hintText: "인증번호",
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
                  setState(() {
                    emailAuthConfirmed = false;
                  });
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
            ],
            ...[
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("휴대폰 번호",
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
                                    controller: phoneNumberController,
                                    enabled: false,
                                    onChanged: (value) {
                                      setState(() {
                                        phoneNumber = value;
                                      });
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
                                      hintText: "이름을 입력해주세요.",
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
            ],
          ]),
        ));
  }
}

class _NotRegisteredScreen extends StatelessWidget {
  VoidCallback onPressActionButton;

  _NotRegisteredScreen({
    super.key,
    required this.onPressActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SGContainer(
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            borderColor: SGColors.line3,
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4)
                .copyWith(top: SGSpacing.p10, bottom: SGSpacing.p6),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(
                  child: SGTypography.body(
                    "아직 싱그릿에 입점하지 않으셨어요.",
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    color: SGColors.black,
                    align: TextAlign.center,
                    lineHeight: 1.25,
                  ),
                )
              ]),
              SizedBox(height: SGSpacing.p8),
              GestureDetector(
                onTap: onPressActionButton,
                child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.primary,
                  child: Center(
                      child: SGTypography.body("입점 신청하기",
                          size: FontSize.normal,
                          weight: FontWeight.w700,
                          color: SGColors.primary)),
                ),
              ),
            ])),
        SizedBox(height: SGSpacing.p32),
      ],
    );
  }
}

class _GreetingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: Colors.transparent,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Image.asset("assets/images/home-icon.png", width: SGSpacing.p20),
        SizedBox(height: SGSpacing.p10),
        SGTypography.body("사장님, 입점을 심사하고 있어요!",
            size: FontSize.xlarge,
            weight: FontWeight.w700,
            color: SGColors.black,
            align: TextAlign.center,
            lineHeight: 1.25),
        SizedBox(height: SGSpacing.p4),
        SGTypography.body("24시간 이내에 입점 신청을 완료할 예정입니다.",
            size: FontSize.normal,
            weight: FontWeight.w400,
            color: SGColors.gray4,
            lineHeight: 1.15),
        SizedBox(height: SGSpacing.p32),
      ]),
    );
  }
}

class _TermCheckScreen extends ConsumerStatefulWidget {
  final VoidCallback onPrev;

  const _TermCheckScreen({super.key, required this.onPrev});

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

  bool get isAllRequiredChecked =>
      terms
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
                  .mapIndexed((index, term) =>
              [
                SizedBox(height: SGSpacing.p3),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      terms = terms
                          .mapIndexed((i, e) =>
                      i == index
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

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _idErrorText;
  String? _passwordErrorText;

  void _validateId(String value) {
    final idRegex = RegExp(r'^[a-zA-Z0-9]{6,12}$');
    setState(() {
      if (idRegex.hasMatch(value)) {
        _idErrorText = null; // Valid ID
      } else {
        _idErrorText = "아이디는 6~12자 이내, 영문, 숫자만 사용 가능합니다.";
      }
    });
  }

  void _validatePassword(String value) {
    final passwordRegex = RegExp(r'^[a-zA-Z0-9!@#$%^&*()_+]{8,16}$');
    setState(() {
      if (passwordRegex.hasMatch(value)) {
        _passwordErrorText = null; // Valid password
      } else {
        _passwordErrorText = "비밀번호는 8~16자의 영문, 숫자, 특수문자만 사용 가능합니다.";
      }
    });
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

    Future.microtask(() {
      ref.read(signupNotifierProvider.notifier).reset();
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
                    fontSize: FontSize.small,
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
                    fontSize: FontSize.small,
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
                                fontSize: FontSize.small,
                                color: SGColors.gray5),
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
              SGTypography.body("다시 한 번 확인해주세요.",
                  size: FontSize.small, color: SGColors.warningRed),
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
                                  fontSize: FontSize.small,
                                  color: SGColors.gray5),
                              keyboardType: TextInputType.number,
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
            ] else
              ...[
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
        childrenBuilder: (ctx) =>
        [
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
        childrenBuilder: (ctx) =>
        [
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
