import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/regular_holidays_box.dart';

import '../../../../../core/components/date_range_picker.dart';
import '../model.dart';

class StoreHolidayScreen extends StatefulWidget {
  final int holidayStatus;
  final List<OperationTimeDetailModel> holidayDetails;
  final Function(int, List<OperationTimeDetailModel>) onSaveFunction;

  const StoreHolidayScreen({super.key, required this.holidayStatus, required this.holidayDetails, required this.onSaveFunction});

  @override
  State<StoreHolidayScreen> createState() => _StoreHolidayScreenState();
}

final List<DateRange> defaultDateRanges = [
  DateRange(
    id: 1,
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 10)),
  ),
];

class _StoreHolidayScreenState extends State<StoreHolidayScreen> {
  late int holidayStatus;
  late List<OperationTimeDetailModel> holidayDetails;
  late List<OperationTimeDetailModel> regularHolidays;
  late List<OperationTimeDetailModel> temporaryHolidays;

  late List<DateRange> temporaryHolidayRanges;

  @override
  void initState() {
    super.initState();
    holidayStatus = widget.holidayStatus;
    holidayDetails = List.from(widget.holidayDetails);
    // 정기휴무. cycle 순 정렬
    regularHolidays = holidayDetails.where((element) => element.holidayType == 0).toList()..sort((a, b) => a.cycle.compareTo(b.cycle));
    // 임시휴무. startDate 순 정렬
    temporaryHolidays = holidayDetails.where((element) => element.holidayType != 0).toList()
      ..sort((a, b) => DateFormat('yyyy.MM.dd').parse(a.startDate).compareTo(
            DateFormat('yyyy.MM.dd').parse(b.startDate),
          ));

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
                //[참고사항]
                // 만약 정기 휴무일의 주기가 ‘매주’ 라면 해당 정기 휴무 요일에 대해 운영 시간을 제거함.
                widget.onSaveFunction(holidayStatus, holidayDetails);
                Navigator.of(context).pop();
              },
              label: "변경하기")),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
          child: ListView(children: [
            SGTypography.body("휴무일", color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),

            SizedBox(height: SGSpacing.p3),

            // --------------------------- 휴무일 ---------------------------
            SGTextFieldWrapper(
                child: SGContainer(
                    borderRadius: BorderRadius.circular(SGSpacing.p4),
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    color: SGColors.white,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("공휴일", size: FontSize.small, weight: FontWeight.w600),
                      const Spacer(),
                      SGSwitch(
                          value: holidayStatus == 1,
                          onChanged: (value) => {
                                setState(() {
                                  holidayStatus = value ? 1 : 0;
                                })
                              })
                    ]))),
            SizedBox(height: SGSpacing.p3),
            SGTypography.body("* 일요일을 제외한 공휴일을 설정해요!", color: SGColors.gray3, weight: FontWeight.w700, size: FontSize.small),

            SizedBox(height: SGSpacing.p3),

            // --------------------------- 정기휴무 ---------------------------
            RegularHolidaysBox(
              regularHolidays: regularHolidays,
              onEditFunction: (regularHolidays_) {
                // print("onEditFunction index $regularHolidays_");
                setState(() {
                  regularHolidays = regularHolidays_;
                });
              },
            ),

            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

            // --------------------------- 임시휴무 ---------------------------
            TemporaryHolidaysBox(
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

class TemporaryHolidaysBox extends StatefulWidget {
  const TemporaryHolidaysBox({
    super.key,
    required this.temporaryHolidayRanges,
    required this.onTemporaryHolidayRangesChanged,
  });

  final List<DateRange> temporaryHolidayRanges;
  final Function(List<DateRange>) onTemporaryHolidayRangesChanged;

  @override
  State<TemporaryHolidaysBox> createState() => _TemporaryHolidaysBoxState();
}

class _TemporaryHolidaysBoxState extends State<TemporaryHolidaysBox> {
  late TextEditingController controller;
  late String value;

  TextStyle baseStyle = const TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);
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
                                      child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16))),
                                ),

                              /// Delete Box
                            ]),
                          if (index >= 1) SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                          if (index >= 1)
                            SGTextFieldWrapper(
                                child: SGContainer(
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
                                      contentPadding: EdgeInsets.symmetric(vertical: SGSpacing.p3, horizontal: SGSpacing.p4),
                                      // 패딩 조정
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
                          if (index >= 1) SizedBox(height: SGSpacing.p3),
                        ])
                    .flattened,
                GestureDetector(
                  onTap: () {
                    widget.onTemporaryHolidayRangesChanged([
                      ...widget.temporaryHolidayRanges,
                      DateRange(id: DateTime.now().millisecondsSinceEpoch, start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1))),
                    ]);
                  },
                  child: Row(children: [Image.asset("assets/images/accumulative.png", width: 24, height: 24), SizedBox(width: SGSpacing.p1), SGTypography.body("임시 휴무 추가하기", size: FontSize.small)]),
                ),
              ],
            )),
      ],
    );
  }
}
