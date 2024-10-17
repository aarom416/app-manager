import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
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
                          _isClosed = value;
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
              SGTypography.body("접수지연으로 주문 취소가 3건 이상 발생 시 자동으로 3시간 동안 모든 가게 영업이 임시 중지 돼요.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("2.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              SGTypography.body("임시중지 상태에선 싱그릿 앱에 ‘준비중'으로 보여요.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
            ]),
            SizedBox(height: SGSpacing.p1),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("3.",
                  size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTypography.body("임시중지는 언제든지 직접 해지할 수 있으며 설정/해제 현황을 메시지로 안내 드려요.",
                    size: FontSize.small, weight: FontWeight.w500, lineHeight: 1.5, color: SGColors.gray4),
              ),
            ]),
          ]),
        ]),
      ),
    );
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
                  SGTypography.body("전체 알림 설정", size: FontSize.normal, weight: FontWeight.w500),
                  Spacer(),
                  SGSwitch(
                      value: allowAllNotification,
                      onChanged: (value) {
                        setState(() {
                          allowAllNotification = value;
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
            SGTypography.body("라이더 알림", size: FontSize.normal, weight: FontWeight.w700),
            SizedBox(height: SGSpacing.p3),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => _DeliveryNotificationConfigurationScreen()));
              },
              child: SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(SGSpacing.p3),
                  borderColor: SGColors.line3,
                  boxShadow: SGBoxShadow.large,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    SGTypography.body("라이더 알림음", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios, size: FontSize.small),
                  ])),
            ),
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
}

class _DeliveryNotificationConfigurationScreen extends StatefulWidget {
  _DeliveryNotificationConfigurationScreen({
    super.key,
  });

  @override
  State<_DeliveryNotificationConfigurationScreen> createState() => _DeliveryNotificationConfigurationScreenState();
}

class _DeliveryNotificationConfigurationScreenState extends State<_DeliveryNotificationConfigurationScreen> {
  bool allowSound = true;
  bool allowEffectSound = false;
  bool noSound = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "라이더 알림음"),
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
                    SGTypography.body("음성 안내음", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowSound,
                        onChanged: (value) {
                          setState(() {
                            allowSound = value;
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
                    SGTypography.body("효과음", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: allowEffectSound,
                        onChanged: (value) {
                          setState(() {
                            allowEffectSound = value;
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
                    SGTypography.body("무음", size: FontSize.normal, weight: FontWeight.w500),
                    Spacer(),
                    SGSwitch(
                        value: noSound,
                        onChanged: (value) {
                          setState(() {
                            noSound = value;
                          });
                        })
                  ])),
            ])));
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

class _ProfileDeleteSessionScreen extends StatelessWidget {
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
          ])),
    );
  }
}
