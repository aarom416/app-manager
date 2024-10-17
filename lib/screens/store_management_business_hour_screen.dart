import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/store_management_holiday_management_screen.dart';

class StoreManagementBusinessHourScreen extends StatelessWidget {
  const StoreManagementBusinessHourScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("영업시간", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const _BusinessHourConfigurationScreen()));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        DataTableRow(left: "월요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "화요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "수요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "목요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "금요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "토요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "일요일", right: "오후 17:00~22:00"),
      ]),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴게시간", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const _NonBusinessHourConfigurationScreen()));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        DataTableRow(left: "월요일~금요일", right: "오후 17:00~22:00"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "토요일", right: "-"),
      ]),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴무일", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => const StoreManagementHolidayManagementScreen()));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        DataTableRow(left: "정기 휴무", right: "2,4 째 주 일요일 휴무"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "공휴일", right: "설날, 설날 다음날"),
      ]),
      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴무일 안내", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const _HolidayAnnouncementScreen()));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        SGTypography.body("ex) 가게 리모델링으로 1월 5일~8일 쉬어요", size: FontSize.small, color: SGColors.gray3),
      ]),
      SizedBox(
        height: SGSpacing.p32,
      ),
    ]);
  }
}

class _HolidayAnnouncementScreen extends StatefulWidget {
  const _HolidayAnnouncementScreen({super.key});

  @override
  State<_HolidayAnnouncementScreen> createState() => __HolidayAnnouncementScreenState();
}

class __HolidayAnnouncementScreenState extends State<_HolidayAnnouncementScreen> {
  TextEditingController textEditingController = TextEditingController();

  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "휴무일 안내"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: Column(
            children: [
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p2),
                child: TextField(
                  controller: textEditingController,
                  onChanged: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                  maxLines: 5,
                  style: TextStyle(
                    color: SGColors.black,
                    fontSize: FontSize.small,
                  ),
                  decoration: InputDecoration(
                    hintText: "ex) 이번 주는 가게 리모델링으로 인해 1~2주 동안은 영업이 어려울 것 같습니다.",
                    hintStyle: TextStyle(
                      color: SGColors.gray3,
                      fontSize: FontSize.small,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              )),
              Spacer(),
              SGActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: "변경하기",
                  disabled: text.isEmpty)
            ],
          ),
        ));
  }
}

class _BusinessHourConfigurationScreen extends StatefulWidget {
  const _BusinessHourConfigurationScreen({super.key});

  @override
  State<_BusinessHourConfigurationScreen> createState() => __BusinessHourConfigurationScreenState();
}

class BusinessHourModel {
  final int id;
  final String weekday;
  final String startHour;
  final String startMinute;
  final String endHour;
  final String endMinute;
  final bool is24Hour;

  BusinessHourModel({
    required this.id,
    required this.weekday,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.is24Hour,
  });

  BusinessHourModel copyWith({
    int? id,
    String? weekday,
    String? startHour,
    String? startMinute,
    String? endHour,
    String? endMinute,
    bool? is24Hour,
  }) {
    return BusinessHourModel(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      is24Hour: is24Hour ?? this.is24Hour,
    );
  }
}

class __BusinessHourConfigurationScreenState extends State<_BusinessHourConfigurationScreen> {
  List<BusinessHourModel> businessHours = [
    BusinessHourModel(
        id: 1,
        weekday: "월요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 2,
        weekday: "화요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 3,
        weekday: "수요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 4,
        weekday: "목요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 5,
        weekday: "금요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 6,
        weekday: "토요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
    BusinessHourModel(
        id: 7,
        weekday: "일요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        is24Hour: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "영업시간 변경"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(
            children: [
              ...businessHours
                  .map((businessHour) {
                    return [
                      __BusinessHourConfigurationCard(
                        businessHour: businessHour,
                        onEdit: (businessHour) {
                          setState(() {
                            businessHours =
                                businessHours.map((bh) => bh.id == businessHour.id ? businessHour : bh).toList();
                          });
                        },
                      ),
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                    ];
                  })
                  .toList()
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(onPressed: () {}, label: "변경하기", disabled: true)
            ],
          ),
        ));
  }
}

class __BusinessHourConfigurationCard extends StatelessWidget {
  final BusinessHourModel businessHour;
  final Function(BusinessHourModel) onEdit;

  __BusinessHourConfigurationCard({
    super.key,
    required this.businessHour,
    required this.onEdit,
  });

  List<SelectionOption<String>> hourOptions = [
    SelectionOption(label: "오전 0시", value: "오전 0시"),
    SelectionOption(label: "오전 1시", value: "오전 1시"),
    SelectionOption(label: "오전 2시", value: "오전 2시"),
    SelectionOption(label: "오전 3시", value: "오전 3시"),
    SelectionOption(label: "오전 4시", value: "오전 4시"),
    SelectionOption(label: "오전 5시", value: "오전 5시"),
    SelectionOption(label: "오전 6시", value: "오전 6시"),
    SelectionOption(label: "오전 7시", value: "오전 7시"),
    SelectionOption(label: "오전 8시", value: "오전 8시"),
    SelectionOption(label: "오전 9시", value: "오전 9시"),
    SelectionOption(label: "오전 10시", value: "오전 10시"),
    SelectionOption(label: "오전 11시", value: "오전 11시"),
    SelectionOption(label: "오후 12시", value: "오후 12시"),
    SelectionOption(label: "오후 1시", value: "오후 1시"),
    SelectionOption(label: "오후 2시", value: "오후 2시"),
    SelectionOption(label: "오후 3시", value: "오후 3시"),
    SelectionOption(label: "오후 4시", value: "오후 4시"),
    SelectionOption(label: "오후 5시", value: "오후 5시"),
    SelectionOption(label: "오후 6시", value: "오후 6시"),
    SelectionOption(label: "오후 7시", value: "오후 7시"),
    SelectionOption(label: "오후 8시", value: "오후 8시"),
    SelectionOption(label: "오후 9시", value: "오후 9시"),
    SelectionOption(label: "오후 10시", value: "오후 10시"),
    SelectionOption(label: "오후 11시", value: "오후 11시"),
  ];

  List<SelectionOption<String>> minuteOptions = [
    SelectionOption(label: "00분", value: "00분"),
    SelectionOption(label: "30분", value: "30분"),
  ];

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.white,
      borderColor: SGColors.line2,
      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      boxShadow: SGBoxShadow.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body(businessHour.weekday, size: FontSize.normal, weight: FontWeight.w500),
              Spacer(),
              SGTypography.body("24시",
                  size: FontSize.normal,
                  weight: FontWeight.w600,
                  color: businessHour.is24Hour ? SGColors.primary : SGColors.gray4),
              SizedBox(width: SGSpacing.p1),
              SGSwitch(
                value: businessHour.is24Hour,
                onChanged: (value) {
                  onEdit(businessHour.copyWith(is24Hour: value));
                },
              ),
            ],
          ),
          if (!businessHour.is24Hour) ...[
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("시작 시간", weight: FontWeight.w600, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "시작 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(businessHour.copyWith(startHour: value));
                        },
                        selected: businessHour.startHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(businessHour.startHour,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "시작 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(businessHour.copyWith(startMinute: minute));
                        },
                        selected: businessHour.startMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(businessHour.startMinute,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
            ]),
            SizedBox(height: SGSpacing.p4 + SGSpacing.p05),
            SGTypography.body("종료 시간", weight: FontWeight.w600, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "종료 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(businessHour.copyWith(endHour: value));
                        },
                        selected: businessHour.endHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(businessHour.endHour,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "종료 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(businessHour.copyWith(endMinute: minute));
                        },
                        selected: businessHour.endMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(businessHour.endMinute,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
            ]),
          ]
        ],
      ),
    );
  }
}

class NonBusinessHourModel {
  final int id;
  final String weekday;
  final String startHour;
  final String startMinute;
  final String endHour;
  final String endMinute;
  final bool isAvailable;

  NonBusinessHourModel({
    required this.id,
    required this.weekday,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isAvailable,
  });

  NonBusinessHourModel copyWith({
    int? id,
    String? weekday,
    String? startHour,
    String? startMinute,
    String? endHour,
    String? endMinute,
    bool? isAvailable,
  }) {
    return NonBusinessHourModel(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class _NonBusinessHourConfigurationScreen extends StatefulWidget {
  const _NonBusinessHourConfigurationScreen({super.key});

  @override
  State<_NonBusinessHourConfigurationScreen> createState() => __NonBusinessHourConfigurationScreenState();
}

class __NonBusinessHourConfigurationScreenState extends State<_NonBusinessHourConfigurationScreen> {
  List<NonBusinessHourModel> nonBusinessHours = [
    NonBusinessHourModel(
        id: 1,
        weekday: "월요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 2,
        weekday: "화요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 3,
        weekday: "수요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 4,
        weekday: "목요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 5,
        weekday: "금요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 6,
        weekday: "토요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 7,
        weekday: "일요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "휴게시간 변경"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(
            children: [
              ...nonBusinessHours
                  .map((nonBusinessHour) {
                    return [
                      __NonBusinessHourConfigurationCard(
                        nonBusinessHour: nonBusinessHour,
                        onEdit: (nonBusinessHour) {
                          setState(() {
                            nonBusinessHours = nonBusinessHours
                                .map((nbh) => nbh.id == nonBusinessHour.id ? nonBusinessHour : nbh)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                    ];
                  })
                  .toList()
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(onPressed: () {}, label: "변경하기", disabled: true)
            ],
          ),
        ));
  }
}

class __NonBusinessHourConfigurationCard extends StatelessWidget {
  final NonBusinessHourModel nonBusinessHour;
  final Function(NonBusinessHourModel) onEdit;

  __NonBusinessHourConfigurationCard({
    super.key,
    required this.nonBusinessHour,
    required this.onEdit,
  });

  List<SelectionOption<String>> hourOptions = [
    SelectionOption(label: "오전 0시", value: "오전 0시"),
    SelectionOption(label: "오전 1시", value: "오전 1시"),
    SelectionOption(label: "오전 2시", value: "오전 2시"),
    SelectionOption(label: "오전 3시", value: "오전 3시"),
    SelectionOption(label: "오전 4시", value: "오전 4시"),
    SelectionOption(label: "오전 5시", value: "오전 5시"),
    SelectionOption(label: "오전 6시", value: "오전 6시"),
    SelectionOption(label: "오전 7시", value: "오전 7시"),
    SelectionOption(label: "오전 8시", value: "오전 8시"),
    SelectionOption(label: "오전 9시", value: "오전 9시"),
    SelectionOption(label: "오전 10시", value: "오전 10시"),
    SelectionOption(label: "오전 11시", value: "오전 11시"),
    SelectionOption(label: "오후 12시", value: "오후 12시"),
    SelectionOption(label: "오후 1시", value: "오후 1시"),
    SelectionOption(label: "오후 2시", value: "오후 2시"),
    SelectionOption(label: "오후 3시", value: "오후 3시"),
    SelectionOption(label: "오후 4시", value: "오후 4시"),
    SelectionOption(label: "오후 5시", value: "오후 5시"),
    SelectionOption(label: "오후 6시", value: "오후 6시"),
    SelectionOption(label: "오후 7시", value: "오후 7시"),
    SelectionOption(label: "오후 8시", value: "오후 8시"),
    SelectionOption(label: "오후 9시", value: "오후 9시"),
    SelectionOption(label: "오후 10시", value: "오후 10시"),
    SelectionOption(label: "오후 11시", value: "오후 11시"),
  ];

  List<SelectionOption<String>> minuteOptions = [
    SelectionOption(label: "00분", value: "00분"),
    SelectionOption(label: "30분", value: "30분"),
  ];

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.white,
      borderColor: SGColors.line2,
      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      boxShadow: SGBoxShadow.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body(nonBusinessHour.weekday, size: FontSize.normal, weight: FontWeight.w500),
              Spacer(),
              SGSwitch(
                value: nonBusinessHour.isAvailable,
                onChanged: (value) {
                  onEdit(nonBusinessHour.copyWith(isAvailable: value));
                },
              ),
            ],
          ),
          if (nonBusinessHour.isAvailable) ...[
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("시작 시간", weight: FontWeight.w600, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "시작 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(nonBusinessHour.copyWith(startHour: value));
                        },
                        selected: nonBusinessHour.startHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(nonBusinessHour.startHour,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "시작 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(nonBusinessHour.copyWith(startMinute: minute));
                        },
                        selected: nonBusinessHour.startMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(nonBusinessHour.startMinute,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
            ]),
            SizedBox(height: SGSpacing.p4 + SGSpacing.p05),
            SGTypography.body("종료 시간", weight: FontWeight.w600, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "종료 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(nonBusinessHour.copyWith(endHour: value));
                        },
                        selected: nonBusinessHour.endHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(nonBusinessHour.endHour,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "종료 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(nonBusinessHour.copyWith(endMinute: minute));
                        },
                        selected: nonBusinessHour.endMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(nonBusinessHour.endMinute,
                          color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
                      Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                    ]),
                  )),
                ),
              ),
            ]),
          ]
        ],
      ),
    );
  }
}
