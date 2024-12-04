import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../../utils/time_utils.dart';
import '../model.dart';

class BreakTimeScreen extends StatefulWidget {
  final List<OperationTimeDetailModel> breakTimeDetailDTOList;
  final List<OperationTimeDetailModel> regularHolidays;
  final Function(List<OperationTimeDetailModel>) onSaveFunction;

  const BreakTimeScreen({super.key, required this.breakTimeDetailDTOList, required this.regularHolidays, required this.onSaveFunction});

  @override
  State<BreakTimeScreen> createState() => _BreakTimeScreenState();
}

class _BreakTimeScreenState extends State<BreakTimeScreen> {
  late List<OperationTimeDetailModel> breakTimeDetailDTOList;
  late List<OperationTimeDetailModel> regularHolidays;

  @override
  void initState() {
    super.initState();
    breakTimeDetailDTOList = List.from(widget.breakTimeDetailDTOList);
    regularHolidays = List.from(widget.regularHolidays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "휴게시간 변경"),
        body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(
            children: [
              ...breakTimeDetailDTOList
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    OperationTimeDetailModel breakTimeDetailDTO = entry.value;
                    var isHoliday = regularHolidays.any((regularHoliday) => (regularHoliday.day == breakTimeDetailDTO.day) && regularHoliday.isWeekCycleHoliday());
                    return isHoliday
                        ? [
                            __BreakTimeRegularHolidayCard(
                              key: ValueKey<int>(index),
                              breakTimeDetailDTO: breakTimeDetailDTO,
                            ),
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                          ]
                        : [
                            __BreakTimeCard(
                              key: ValueKey<int>(index),
                              breakTimeDetailDTO: breakTimeDetailDTO,
                              onEditFunction: (breakTimeDetailDTO) {
                                // print("onEditFunction index [$index] breakTimeDetailDTO");
                                setState(() {
                                  breakTimeDetailDTOList[index] = breakTimeDetailDTO;
                                });
                              },
                            ),
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                          ];
                  })
                  .toList()
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(
                  onPressed: () {
                    widget.onSaveFunction(breakTimeDetailDTOList);
                    Navigator.of(context).pop();
                  },
                  label: "변경하기",
                  disabled: widget.breakTimeDetailDTOList.isEqualTo(breakTimeDetailDTOList))
            ],
          ),
        ));
  }
}

class __BreakTimeRegularHolidayCard extends StatelessWidget {
  final OperationTimeDetailModel breakTimeDetailDTO;

  const __BreakTimeRegularHolidayCard({
    super.key,
    required this.breakTimeDetailDTO,
  });

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
              SGTypography.body("${breakTimeDetailDTO.day}요일", size: FontSize.normal, weight: FontWeight.w500),
              const Spacer(),
              SGTypography.body("정기휴무일", size: FontSize.normal, weight: FontWeight.w600, color: SGColors.gray4),
            ],
          )
        ],
      ),
    );
  }
}

class __BreakTimeCard extends StatelessWidget {
  final OperationTimeDetailModel breakTimeDetailDTO;
  final Function(OperationTimeDetailModel) onEditFunction;

  __BreakTimeCard({
    super.key,
    required this.breakTimeDetailDTO,
    required this.onEditFunction,
  })  : hourOptions = List.generate(
          24,
          (hour) => SelectionOption(
            label: formatHourToAmPmWithKoreanSuffix(hour.toString()),
            value: hour.toString(),
          ),
        ),
        minuteOptions = [
          SelectionOption(label: "00분", value: "00"),
          SelectionOption(label: "30분", value: "30"),
        ];

  final List<SelectionOption<String>> hourOptions;
  final List<SelectionOption<String>> minuteOptions;

  @override
  Widget build(BuildContext context) {
    final startTimeSplit = breakTimeDetailDTO.startTime.split(':');
    final startHour = startTimeSplit[0];
    final startMinute = startTimeSplit[1];
    final endTimeSplit = breakTimeDetailDTO.endTime.split(':');
    final endHour = endTimeSplit[0];
    final endMinute = endTimeSplit[1];

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
              SGTypography.body("${breakTimeDetailDTO.day}요일", size: FontSize.normal, weight: FontWeight.w500),
              Spacer(),
              SGTypography.body("24시", size: FontSize.normal, weight: FontWeight.w600, color: breakTimeDetailDTO.isNoBreak() ? SGColors.primary : SGColors.gray4),
              SizedBox(width: SGSpacing.p1),
              SGSwitch(
                value: breakTimeDetailDTO.isNoBreak(),
                onChanged: (noBreak) {
                  onEditFunction(noBreak ? breakTimeDetailDTO.toNoBreak : breakTimeDetailDTO.toDefaultBreakHour);
                },
              ),
            ],
          ),
          if (!breakTimeDetailDTO.isNoBreak()) ...[
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("시작 시간", weight: FontWeight.w600, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2),
            Row(children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showSelectionBottomSheet<String>(
                        context: context,
                        title: "시작 시간을 설정해 주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEditFunction(breakTimeDetailDTO.copyWith(startTime: "$value:$startMinute"));
                        },
                        selected: startHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(formatHourToAmPmWithKoreanSuffix(startHour), color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
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
                        title: "시작 시간(분)을 설정해 주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEditFunction(breakTimeDetailDTO.copyWith(startTime: "$startHour:$minute"));
                        },
                        selected: startMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("$startMinute분", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
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
                        title: "종료 시간을 설정해 주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEditFunction(breakTimeDetailDTO.copyWith(endTime: "$value:$endMinute"));
                        },
                        selected: endHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body(formatHourToAmPmWithKoreanSuffix(endHour), color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
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
                        title: "종료 시간(분)을 설정해 주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEditFunction(breakTimeDetailDTO.copyWith(endTime: "$endHour:$minute"));
                        },
                        selected: endMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      SGTypography.body("$endMinute분", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w500),
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
