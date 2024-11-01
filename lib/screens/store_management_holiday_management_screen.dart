import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class StoreManagementHolidayManagementScreen extends StatefulWidget {
  const StoreManagementHolidayManagementScreen({super.key});

  @override
  State<StoreManagementHolidayManagementScreen> createState() => _StoreManagementHolidayManagementScreenState();
}

const List<String> periodTypes = [
  "매월 첫 번째",
  "매월 두 번째",
  "매월 세 번째",
  "매월 네 번째",
  "매월 다섯 번째",
  "매월 마지막",
  "매주",
];

final List<SelectionOption<String>> periodicTypeOptions = [
  ...periodTypes.map((e) => SelectionOption(value: e, label: e))
];

const List<String> daysOfWeek = [
  "월요일",
  "화요일",
  "수요일",
  "목요일",
  "금요일",
  "토요일",
  "일요일",
];

final List<SelectionOption<String>> daysOfWeekOptions = [...daysOfWeek.map((e) => SelectionOption(value: e, label: e))];

class PeriodicHoliday {
  int id;
  String periodType;
  String dayOfWeek;

  PeriodicHoliday({required this.id, required this.periodType, required this.dayOfWeek});
}

final List<DateRange> defaultDateRanges = [
  DateRange(
    id: 1,
    start: DateTime.now(),
    end: DateTime.now().add(Duration(days: 10)),
  ),
];

class _StoreManagementHolidayManagementScreenState extends State<StoreManagementHolidayManagementScreen> {
  bool holidayEnabled = true;

  List<PeriodicHoliday> periodicHolidays = [
    PeriodicHoliday(id: 1, periodType: periodTypes[0], dayOfWeek: daysOfWeek[0]),
  ];

  late List<DateRange> temporaryHolidayRanges;

  @override
  void initState() {
    super.initState();
    temporaryHolidayRanges = [...defaultDateRanges];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "휴무일 변경"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: "변경하기")),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            SGTypography.body("휴무일", color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
            SizedBox(height: SGSpacing.p3),
            SGTextFieldWrapper(
                child: SGContainer(
                    borderRadius: BorderRadius.circular(SGSpacing.p4),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    color: SGColors.white,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("공휴일", size: FontSize.small, weight: FontWeight.w600),
                      Spacer(),
                      SGSwitch(
                          value: holidayEnabled,
                          onChanged: (value) => {
                                setState(() {
                                  holidayEnabled = value;
                                })
                              })
                    ]))),
            SizedBox(height: SGSpacing.p3),

            SGTypography.body("* 일요일을 제외한 공휴일을 설정해요!",
                color: SGColors.gray3, weight: FontWeight.w700, size: FontSize.small),
            SizedBox(height: SGSpacing.p3),
            _PeriodicHolidayManagementBox(
              periodicHolidays: periodicHolidays,
              onPeriodicHolidaysChanged: (value) {
                setState(() {
                  periodicHolidays = [...value];
                });
              },
            ),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

            /// 임시 휴무 컴포넌트
            _TemporaryHolidayManagementBox(
                temporaryHolidayRanges: temporaryHolidayRanges,
                onTemporaryHolidayRangesChanged: (value) {
                  setState(() {
                    temporaryHolidayRanges = [...value];
                  });
                }),
            SizedBox(height: SGSpacing.p10),
          ])),
    );
  }
}

class _PeriodicHolidayManagementBox extends StatelessWidget {
  _PeriodicHolidayManagementBox({
    super.key,
    required this.periodicHolidays,
    required this.onPeriodicHolidaysChanged,
  });

  final List<PeriodicHoliday> periodicHolidays;
  final Function(List<PeriodicHoliday>) onPeriodicHolidaysChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SGSpacing.p6),
        SGTypography.body("정기 휴무", color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
        SizedBox(height: SGSpacing.p3),
        SGContainer(
            color: SGColors.white,
            borderColor: SGColors.line2,
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4,
              vertical: SGSpacing.p5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...periodicHolidays
                    .mapIndexed((index, holiday) => [
                        if (index >= 1)
                          Row(children: [
                            /// Period Type Box
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showSelectionBottomSheet<String>(
                                      context: context,
                                      title: "정기 휴무일의 주기를 설정해주세요.",
                                      options: periodicTypeOptions,
                                      onSelect: (value) {
                                        onPeriodicHolidaysChanged([
                                          ...periodicHolidays.sublist(0, index),
                                          PeriodicHoliday(id: holiday.id, periodType: value, dayOfWeek: holiday.dayOfWeek),
                                          ...periodicHolidays.sublist(index + 1),
                                        ]);
                                      },
                                      selected: holiday.periodType);
                                },
                                child: SGTextFieldWrapper(
                                    child: SGContainer(
                                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    SGTypography.body(holiday.periodType,
                                        color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w500),
                                    Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16, color: SGColors.gray4),
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
                                      title: "정기 휴무일의 요일을 설정해주세요.",
                                      options: daysOfWeekOptions,
                                      onSelect: (minute) {
                                        onPeriodicHolidaysChanged([
                                          ...periodicHolidays.sublist(0, index),
                                          PeriodicHoliday(
                                              id: holiday.id, periodType: holiday.periodType, dayOfWeek: minute),
                                          ...periodicHolidays.sublist(index + 1),
                                        ]);
                                      },
                                      selected: holiday.dayOfWeek);
                                },
                                child: SGTextFieldWrapper(
                                    child: SGContainer(
                                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    SGTypography.body(holiday.dayOfWeek,
                                        color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w500),
                                    Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16, color: SGColors.gray4,),
                                  ]),
                                )),
                              ),
                            ),
                            SizedBox(width: SGSpacing.p3),
                            GestureDetector(
                                onTap: () {
                                  onPeriodicHolidaysChanged([
                                    ...periodicHolidays.sublist(0, index),
                                    ...periodicHolidays.sublist(index + 1),
                                  ]);
                                },
                                child: SGContainer(
                                    borderWidth: 0,
                                    width: SGSpacing.p5,
                                    height: SGSpacing.p5,
                                    borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                                    color: SGColors.warningRed,
                                    child:
                                        Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16))),
                              ),

                            /// Delete Box
                          ]),
                          if (index >= 1)
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                        ])
                    .flattened,
                GestureDetector(
                  onTap: () {
                    onPeriodicHolidaysChanged([
                      ...periodicHolidays,
                      PeriodicHoliday(
                          id: DateTime.now().millisecondsSinceEpoch, periodType: periodTypes[0], dayOfWeek: daysOfWeek[0]),
                    ]);
                  },
                  child: Row(children: [
                    Image.asset("assets/images/accumulative.png", width: 24, height: 24),
                    SizedBox(width: SGSpacing.p1),
                    SGTypography.body("정기 휴무 추가하기", size: FontSize.small)
                  ]),
                ),
              ],
            )),
      ],
    );
  }
}

class _TemporaryHolidayManagementBox extends StatefulWidget {
  _TemporaryHolidayManagementBox({
    super.key,
    required this.temporaryHolidayRanges,
    required this.onTemporaryHolidayRangesChanged,
  });

  final List<DateRange> temporaryHolidayRanges;
  final Function(List<DateRange>) onTemporaryHolidayRangesChanged;

  @override
  State<_TemporaryHolidayManagementBox> createState() => _TemporaryHolidayManagementBoxState();
}

class _TemporaryHolidayManagementBoxState extends State<_TemporaryHolidayManagementBox> {

  late TextEditingController controller;
  late String value;

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);
  int maxLength = 100;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    value = ""; // 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SGSpacing.p6),
        SGTypography.body("임시 휴무", color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
        SizedBox(height: SGSpacing.p3),
        SGContainer(
            color: SGColors.white,
            borderColor: SGColors.line2,
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4,
              vertical: SGSpacing.p5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.temporaryHolidayRanges
                    .mapIndexed((index, holiday) => [
                      if (index >= 1)
                          Row(children: [
                            Expanded(
                              /// Stateful Widget이기 때문에 변경이 일어날 시 key를 변경해주어야 함
                              child: DateRangePicker(
                                key: ValueKey(holiday.id),
                                variant: DateRangePickerVariant.small,
                                dateRange: holiday,
                                onStartDateChanged: (value) {
                                  widget.onTemporaryHolidayRangesChanged([
                                    ...widget.temporaryHolidayRanges.sublist(0, index),
                                    holiday.copyWith(start: value),
                                    ...widget.temporaryHolidayRanges.sublist(index + 1),
                                  ]);
                                },
                                onEndDateChanged: (value) {
                                  widget.onTemporaryHolidayRangesChanged([
                                    ...widget.temporaryHolidayRanges.sublist(0, index),
                                    holiday.copyWith(end: value),
                                    ...widget.temporaryHolidayRanges.sublist(index + 1),
                                  ]);
                                },
                              ),
                            ),
                            SizedBox(width: SGSpacing.p3),
                            if (index == 0)
                              SizedBox(width: SGSpacing.p5)
                            else
                              GestureDetector(
                                onTap: () {
                                  widget.onTemporaryHolidayRangesChanged([
                                    ...widget.temporaryHolidayRanges.sublist(0, index),
                                    ...widget.temporaryHolidayRanges.sublist(index + 1),
                                  ]);
                                },
                                child: SGContainer(
                                    borderWidth: 0,
                                    width: SGSpacing.p5,
                                    height: SGSpacing.p5,
                                    borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                                    color: SGColors.warningRed,
                                    child:
                                        Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16))),
                              ),

                            /// Delete Box
                          ]),
                          if (index >= 1)
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                      if (index >= 1)
                      SGTextFieldWrapper(
                          child:  SGContainer(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(SGSpacing.p3),
                            height: SGSpacing.p12,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                TextField(
                                  controller: controller,
                                  maxLines: 5,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.length > maxLength) {
                                        controller.text = value.substring(0, maxLength);
                                        controller.selection = TextSelection.fromPosition(TextPosition(offset: maxLength));
                                        return;
                                      }
                                      this.value = value;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: SGSpacing.p3, horizontal: SGSpacing.p4), // 패딩 조정
                                    isCollapsed: true,
                                    hintText: "ex) 가게 리모델링으로 1월 5일 ~ 8일 쉬어요",
                                    hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                                    border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                                  ),
                                  textAlignVertical: TextAlignVertical.center, // 텍스트 가운데 정렬
                                ),
                              ],
                            ),
                          )),
                          if(index >=1)
                            SizedBox(height: SGSpacing.p3),
                        ])
                    .flattened,
                GestureDetector(
                  onTap: () {
                    widget.onTemporaryHolidayRangesChanged([
                      ...widget.temporaryHolidayRanges,
                      DateRange(
                          id: DateTime.now().millisecondsSinceEpoch,
                          start: DateTime.now(),
                          end: DateTime.now().add(Duration(days: 1))),
                    ]);
                  },
                  child: Row(children: [
                    Image.asset("assets/images/accumulative.png", width: 24, height: 24),
                    SizedBox(width: SGSpacing.p1),
                    SGTypography.body("임시 휴무 추가하기", size: FontSize.small)
                  ]),
                ),
              ],
            )),
      ],
    );
  }
}
