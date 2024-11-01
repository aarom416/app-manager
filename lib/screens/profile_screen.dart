import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home_screen.dart';
import 'package:singleeat/screens/login_screen.dart';
import 'package:singleeat/screens/order_history_screen.dart';
import 'package:singleeat/screens/receipt_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const toolbarHeight = 64.0;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SGContainer(
                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                  child:
                      SGTypography.body("내 정보", size: (FontSize.large + FontSize.xlarge) / 2, weight: FontWeight.w700)),
            ])),
        toolbarHeight: toolbarHeight,
        leadingWidth: 200,
        actions: [],
      ),
      body: SGContainer(
        color: Color(0xFFFAFAFA),
        borderWidth: 0,
        child: ListView(
          children: [
            SGContainer(
              borderWidth: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SGContainer(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4 + SGSpacing.p05, vertical: SGSpacing.p5),
                      child: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SGTypography.body("하루 매출", size: FontSize.small, weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                                SGTypography.body("0원",
                                    size: (FontSize.large + FontSize.xlarge) / 2,
                                    color: Colors.black,
                                    weight: FontWeight.w700),
                                SizedBox(height: SGSpacing.p4 + SGSpacing.p05),
                                Row(children: [
                                  SGTypography.body("배달 0원"),
                                  SGContainer(
                                      color: SGColors.line3,
                                      width: 1,
                                      height: 10,
                                      margin: EdgeInsets.symmetric(horizontal: SGSpacing.p2)),
                                  SGTypography.body("포장 0원"),
                                ])
                              ],
                            )),
                            ReloadButton(
                              onReload: () {},
                            )
                          ],
                        ),
                        SizedBox(height: SGSpacing.p5),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReceiptListScreen()));
                          },
                          child: SGContainer(
                            color: SGColors.primary,
                            padding: EdgeInsets.symmetric(vertical: SGSpacing.p3),
                            borderRadius: BorderRadius.circular(SGSpacing.p3),
                            child: Center(
                                child: SGTypography.body("지난 주문 내역",
                                    size: (FontSize.small + FontSize.normal) / 2, color: Colors.white)),
                          ),
                        ),
                      ]))
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p4),
            SGContainer(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(top: SGSpacing.p6),
              borderRadius: BorderRadius.circular(SGSpacing.p4),
              boxShadow: SGBoxShadow.large,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body("앱 설정", size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  _NavigationLinkItem(
                      title: "자동 영업 임시중지",
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => _TemporaryClosedScreen()));
                      }),
                  _NavigationLinkItem(
                      title: "알림 설정",
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => _NotificationConfigurationScreen()));
                      }),
                  _NavigationLinkItem(
                      title: "계정 설정",
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => _ProfileDeleteSessionScreen()));
                      }),
                ],
              ),
            ),
            // 앱 설정
            SizedBox(height: SGSpacing.p4),
            SGContainer(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(top: SGSpacing.p6),
              borderRadius: BorderRadius.circular(SGSpacing.p4),
              boxShadow: SGBoxShadow.large,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGTypography.body("고객센터", size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p4),
                  _NavigationLinkItem(title: "자주 묻는 질문"),
                  _NavigationLinkItem(title: "1:1 문의"),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p12),
          ],
        ),
      ),
    );
  }
}

class _NavigationLinkItem extends StatelessWidget {
  final String title;
  final Function()? onTap;

  const _NavigationLinkItem({
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? onTap : () {},
      child: SGContainer(
        color: Colors.white,
        child: Column(
          children: [
            SGContainer(
              color: SGColors.gray2,
              height: 1,
              width: double.infinity,
            ),
            SGContainer(
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              child: Row(
                children: [
                  SGTypography.body(title, size: (FontSize.small + FontSize.normal) / 2),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios, size: FontSize.small),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryAgencyScreen extends StatelessWidget {
  final List<String> deliveryAgencies = ["바로고", "생각대로", "부릉"];

  _DeliveryAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "배달 대행사 설정"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("연결 가능한 배달대행사", size: FontSize.large, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p6),
              ...deliveryAgencies
                  .map((agency) => [
                        SGContainer(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          borderColor: SGColors.line3,
                          boxShadow: SGBoxShadow.large,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SGTypography.body(agency, size: FontSize.normal),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => RegisterDeliveryAgencyScreen()));
                                      },
                                      child: Image.asset("assets/images/plus-filled.png", width: 24, height: 24)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SGSpacing.p2),
                      ])
                  .flattened,
            ])));
  }
}

class RegisterDeliveryAgencyScreen extends StatefulWidget {
  const RegisterDeliveryAgencyScreen({super.key});

  @override
  State<RegisterDeliveryAgencyScreen> createState() => _RegisterDeliveryAgencyScreenState();
}

class _RegisterDeliveryAgencyScreenState extends State<RegisterDeliveryAgencyScreen> {
  String phoneNumber = "";
  String registrationNumber = "";
  String agencyAuthCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "배달대행사 설정"),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: "조회하기")),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("배달대행사에 등록된\n대표님의 정보를 입력해주세요",
                  size: FontSize.large, weight: FontWeight.w700, lineHeight: 1.35),
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("대표자 전화번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "전화번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("사업자 번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                registrationNumber = value;
                              });
                            },
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "사업자 번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("배달대행사 인증번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                agencyAuthCode = value;
                              });
                            },
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "인증번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              ...[
                SizedBox(height: SGSpacing.p5),
                SGTypography.body("대표자명", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            enabled: false,
                            controller: TextEditingController()..text = "홍길동",
                            style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                            decoration: InputDecoration(
                              isDense: true,
                              isCollapsed: true,
                              hintStyle: TextStyle(
                                  color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                              hintText: "인증번호를 입력해주세요",
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            )),
                      ),
                    ],
                  ),
                )),
              ],
              SizedBox(height: SGSpacing.p32 * 2),
            ])));
  }
}

class _TemporaryClosedScreen extends StatefulWidget {
  const _TemporaryClosedScreen({super.key});

  @override
  State<_TemporaryClosedScreen> createState() => __TemporaryClosedScreenState();
}

class __TemporaryClosedScreenState extends State<_TemporaryClosedScreen> {
  bool _isClosed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "영업 임시중지"),
      body: SGContainer(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
        color: Color(0xFFFAFAFA),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SGContainer(
              padding: EdgeInsets.all(SGSpacing.p4),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              color: SGColors.white,
              borderColor: SGColors.line3,
              boxShadow: SGBoxShadow.large,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGTypography.body("영업 임시중지", size: FontSize.normal, weight: FontWeight.w500),
                  SGSwitch(
                      value: _isClosed,
                      onChanged: (value) {
                        setState(() {
                          if (_isClosed) {
                            _isClosed = !_isClosed;
                          } else {
                            showDialog(context: context);
                          }
                        });
                      })
                ],
              )),
          SizedBox(height: SGSpacing.p5),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("1. ",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              SGTypography.body("임시 중지 상태에선 싱그릿 앱에 '준비 중'으로 보여요.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("2.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              SGTypography.body("가게 영업 임시 중지 시 신규 주문 접수는 어려워요.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("3.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTypography.body("임시 중지는 언제든지 직접 해지할 수 있어요.",
                    size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }

  void showDialog({required BuildContext context}) {
    showSGDialog(
        context: context,
        childrenBuilder: (ctx) => [
          SGTypography.body("영업 임시 중지 시", size: FontSize.medium, weight: FontWeight.w700),
          SizedBox(height: SGSpacing.p1),
          SGTypography.body("신규 주문 접수가 불가합니다.", size: FontSize.medium, weight: FontWeight.w700),
          SizedBox(height: SGSpacing.p5),
          Row(
            children: [
              SGFlexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                  child: SGContainer(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    color: SGColors.gray3,
                    child: Center(
                      child: SGTypography.body("취소",
                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              SGFlexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _isClosed = true;
                    });
                  },
                  child: SGContainer(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    color: SGColors.primary,
                    child: Center(
                      child: SGTypography.body("확인",
                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
  }
}

class _NotificationConfigurationScreen extends StatefulWidget {
  _NotificationConfigurationScreen({
    super.key,
  });

  @override
  State<_NotificationConfigurationScreen> createState() => _NotificationConfigurationScreenState();
}

class _NotificationConfigurationScreenState extends State<_NotificationConfigurationScreen> {
  bool allowAllNotification = true;
  double notificationVolume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림 설정"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("알림 음량 및 설정", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.line3,
                boxShadow: SGBoxShadow.large,
                child: Row(children: [
                  SGTypography.body("주문 알림 설정", size: FontSize.normal, weight: FontWeight.w500),
                  Spacer(),
                  SGSwitch(
                      value: allowAllNotification,
                      onChanged: (value) {
                        setState(() {
                          if (allowAllNotification) {
                            showFailDialogWithImageBoth("주문 알림을 비활성화하시겠습니까?", "비활성화 시 주문 관련 알림을 받을 수 없습니다.");
                          } else {
                            allowAllNotification = true;
                          }
                        });
                      })
                ])),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                color: Colors.white,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                borderColor: SGColors.line3,
                boxShadow: SGBoxShadow.large,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SGTypography.body("알림 음량", size: FontSize.normal, weight: FontWeight.w500),
                  SizedBox(height: SGSpacing.p2),
                  SliderTheme(
                    data: SliderThemeData(
                      inactiveTrackColor: SGColors.line3,
                      activeTrackColor: SGColors.primary,
                      valueIndicatorColor: SGColors.primary,
                      thumbColor: SGColors.white,
                      trackHeight: 6,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 1),
                    ),
                    child: Slider(
                      value: notificationVolume,
                      onChanged: (double value) {
                        setState(() {
                          notificationVolume = value;
                        });
                      },
                    ),
                  )
                ])),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("사장님 알림 센터", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => _BusinessNotificationConfigurationScreen()));
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SGTypography.body("알림 받기 설정", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: FontSize.small),
                  ])),
            ),
          ]),
        ));
  }


  void showFailDialogWithImageBoth(String mainTitle, String subTitle) {
    showSGDialogWithImageBoth(
        context: context,
        childrenBuilder: (ctx) => [
          Column(
            children: [
              Center(
                  child: SGTypography.body(mainTitle,
                      size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
              ),
              SizedBox(height: SGSpacing.p2),
              Center(
                  child: SGTypography.body(subTitle,
                      color: SGColors.gray4,
                      size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
              ),
              SizedBox(height: SGSpacing.p6),
            ],
          ),
          Row(
            children: [
              SGFlexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                  },
                  child: SGContainer(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    color: SGColors.gray3,
                    child: Center(
                      child: SGTypography.body("취소",
                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              SGFlexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      allowAllNotification = false;
                    });
                  },
                  child: SGContainer(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    color: SGColors.primary,
                    child: Center(
                      child: SGTypography.body("확인",
                          size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]);
  }
}

class _BusinessNotificationConfigurationScreen extends StatefulWidget {
  _BusinessNotificationConfigurationScreen({
    super.key,
  });

  @override
  State<_BusinessNotificationConfigurationScreen> createState() => _BusinessNotificationConfigurationScreenState();
}

class _BusinessNotificationConfigurationScreenState extends State<_BusinessNotificationConfigurationScreen> {
  bool allowAnnounce = true;
  bool allowBenefit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "알림 받기 설정"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            child: ListView(children: [
              SGContainer(),
              SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(children: [
                    SGTypography.body("소식 알림", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowAnnounce,
                        onChanged: (value) {
                          setState(() {
                            allowAnnounce = value;
                          });
                        })
                  ])),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(children: [
                    SGTypography.body("혜택 알림", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowBenefit,
                        onChanged: (value) {
                          setState(() {
                            allowBenefit = value;
                          });
                        })
                  ])),
            ])));
  }
}

class _ProfileDeleteSessionScreen extends StatefulWidget {
  @override
  State<_ProfileDeleteSessionScreen> createState() => _ProfileDeleteSessionScreenState();
}

class _ProfileDeleteSessionScreenState extends State<_ProfileDeleteSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "계정 설정"),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3 + SGSpacing.p05),
          child: Column(children: [
            GestureDetector(
              onTap: () {
                showSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                          Center(
                              child: SGTypography.body("로그아웃 하시겠습니까?", size: FontSize.large, weight: FontWeight.w700)),
                          SizedBox(height: SGSpacing.p5),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  showFailDialogWithImage("로그아웃 실패","현재 가게가 영업 중이거나 진행 중인 주문이 있어\n로그아웃을 진행할 수 없습니다.");
                                },
                                child: SGContainer(
                                  color: SGColors.gray3,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  child: Center(
                                    child: SGTypography.body("취소",
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                },
                                child: SGContainer(
                                  color: SGColors.primary,
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  child: Center(
                                    child: SGTypography.body("로그아웃",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ]);
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SGTypography.body("로그아웃", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: FontSize.small),
                  ])),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                showSGDialog(
                    context: context,
                    childrenBuilder: (ctx) => [
                          // 로그아웃 하시겠습니까.
                          Center(
                              child: SGTypography.body("정말 탈퇴하시겠습니까?", size: FontSize.large, weight: FontWeight.w700)),
                          SizedBox(height: SGSpacing.p3),
                          Center(
                            child: SGTypography.body(
                              "계정 탈퇴 시 고객센터로 전화주세요",
                              color: SGColors.gray4,
                              size: FontSize.small,
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
                                  padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                                  child: Center(
                                    child: SGTypography.body("확인",
                                        size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ]);
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SGTypography.body("회원탈퇴", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: FontSize.small),
                  ])),
            ),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CheckPasswordScreen(title: "비밀번호 확인")));
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SGTypography.body("비밀번호 변경", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: FontSize.small),
                  ])),
            ),
          ])),
    );
  }
  void showFailDialogWithImage(String mainTitle, String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          Center(
              child: SGTypography.body(mainTitle,
                  size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p2),
          Center(
              child: SGTypography.body(subTitle,
                  color: SGColors.gray4,
                  size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
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
                      color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
            ),
          )
        ]);
  }
}


class CheckPasswordScreen extends StatefulWidget {
  String title;
  CheckPasswordScreen({
    super.key,
    required this.title,
  });

  @override
  State<CheckPasswordScreen> createState() => CheckPasswordScreenState();
}

class CheckPasswordScreenState extends State<CheckPasswordScreen> {
  String password = "";

  bool passwordVisible = false;

  late TextEditingController controller = TextEditingController();

  bool get isPasswordValid => password.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: widget.title,
            onTap: () {
              Navigator.pop(context);
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  if (isPasswordValid) {
                    showFailDialogWithImage("입력하신 비밀번호가 현재 비밀번호와 일치하지 않습니다.", "다시 한 번 확인 후 입력해 주세요.");
                  }
                },
                disabled: !isPasswordValid,
                label: "다음")),
        body: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            color: SGColors.white,
            child: ListView(children: [
              Row(
                children: [
                  SGTypography.body("사장님의 정보 보호를 위해,\n현재 비밀번호를 확인해주세요.", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
                ],
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("비밀번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              controller: controller,
                              style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                              obscureText: !passwordVisible,
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                                hintText: "현재 비밀번호를 입력해주세요.",
                                border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: SGColors.gray3)),
                      ],
                    ),
                  )),
              SizedBox(height: SGSpacing.p8),
            ])));
  }

  void showFailDialogWithImage(String mainTitle, String subTitle) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          Center(
              child: SGTypography.body(mainTitle,
                  size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p2),
          Center(
              child: SGTypography.body(subTitle,
                  color: SGColors.gray4,
                  size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)
          ),
          SizedBox(height: SGSpacing.p6),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePasswordScreen(title: "비밀번호 변경")));
            },
            child: SGContainer(
              color: SGColors.primary,
              width: double.infinity,
              borderColor: SGColors.primary,
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                  child: SGTypography.body("확인",
                      color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
            ),
          )
        ]);
  }
}

class ChangePasswordScreen extends StatefulWidget {
  VoidCallback? onPrev;
  VoidCallback? onNext;
  String title;
  ChangePasswordScreen({
    super.key,
    required this.title,
    this.onPrev,
    this.onNext,
  });

  @override
  State<ChangePasswordScreen> createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String password = "";
  String passwordConfirm = "";

  bool passwordVisible = false;
  bool passwordVisibleConfirm = false;

  late TextEditingController controller = TextEditingController();
  late TextEditingController controllerConfirm = TextEditingController();

  bool get isPasswordValid => password.isNotEmpty && passwordConfirm.isNotEmpty && password == passwordConfirm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: widget.title,
            onTap: () {
              widget.onPrev!();
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  if (isPasswordValid) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _SuccessChangePasswordScreen()));
                  }
                },
                disabled: !isPasswordValid,
                label: "다음")),
        body: SGContainer(
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p8),
            color: SGColors.white,
            child: ListView(children: [
              Row(
                children: [
                  SGTypography.body("비밀번호 변경", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
                ],
              ),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("비밀번호", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                              controller: controller,
                              style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                              obscureText: !passwordVisible,
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                                hintText: "8~16자의 영문, 숫자, 특수문자를 입력해주세요.",
                                border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: SGColors.gray3)),
                      ],
                    ),
                  )),
              Row(children: []),
              SizedBox(height: SGSpacing.p8),
              if (password.isNotEmpty && passwordConfirm.isNotEmpty && password != passwordConfirm)
                SGTypography.body("비밀번호가 다릅니다.",
                    size: FontSize.small, weight: FontWeight.w500, color: SGColors.warningRed)
              else
                SGTypography.body("비밀번호 확인", size: FontSize.small, weight: FontWeight.w500, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                    padding: EdgeInsets.all(SGSpacing.p4),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  passwordConfirm = value;
                                });
                              },
                              controller: controllerConfirm,
                              style: TextStyle(fontSize: FontSize.small, color: SGColors.gray5),
                              obscureText: !passwordVisibleConfirm,
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                hintStyle:
                                TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                                hintText: "비밀번호를 다시 한번 입력해주세요.",
                                border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              )),
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisibleConfirm = !passwordVisibleConfirm;
                              });
                            },
                            child: Icon(passwordVisibleConfirm ? Icons.visibility : Icons.visibility_off,
                                color: SGColors.gray3)),
                      ],
                    ),
                  )),
            ])));
  }
}

class _SuccessChangePasswordScreen extends StatelessWidget {
  _SuccessChangePasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(
            title: "비밀번호 변경",
            onTap: () {
              Navigator.pop(context);
            }),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
                label: "확인")),
        body: SGContainer(
            color: SGColors.white,
            child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset("assets/images/large-checkbox.png", width: SGSpacing.p10 * 2),
                  SizedBox(height: SGSpacing.p10),
                  SGTypography.body("비밀번호 변경 성공!", size: FontSize.xlarge, weight: FontWeight.w700, lineHeight: 1.35),
                  SizedBox(height: SGSpacing.p4),
                  SGTypography.body("싱그릿 사장님 비밀번호가\n성공적으로 변경되었습니다.",
                      align: TextAlign.center,
                      size: FontSize.normal,
                      weight: FontWeight.w400,
                      color: SGColors.gray4,
                      lineHeight: 1.25),
                  SizedBox(height: SGSpacing.p32),
                ]))));
  }
}

