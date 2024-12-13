import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/snackbar.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../../core/utils/time_utils.dart';
import '../model.dart';

class OperationTimeScreen extends StatefulWidget {
  final List<OperationTimeDetailModel> operationTimeDetailDTOList;
  final List<OperationTimeDetailModel> regularHolidays;
  final Function(List<OperationTimeDetailModel>) onSaveFunction;

  const OperationTimeScreen({super.key, required this.operationTimeDetailDTOList, required this.regularHolidays, required this.onSaveFunction});

  @override
  State<OperationTimeScreen> createState() => _OperationTimeScreenState();
}

class _OperationTimeScreenState extends State<OperationTimeScreen> {
  late List<OperationTimeDetailModel> operationTimeDetailDTOList;
  late List<OperationTimeDetailModel> regularHolidays;

  @override
  void initState() {
    super.initState();
    operationTimeDetailDTOList = List.from(widget.operationTimeDetailDTOList);
    regularHolidays = List.from(widget.regularHolidays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "영업시간 변경"),
        body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(
            children: [
              ...operationTimeDetailDTOList
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    OperationTimeDetailModel operationTimeDetailDTO = entry.value;
                    var isHoliday = regularHolidays.any((regularHoliday) => (regularHoliday.day == operationTimeDetailDTO.day) && regularHoliday.isWeekCycleHoliday());
                    return isHoliday
                        ? [
                            __OperationRegularHolidayCard(
                              key: ValueKey<int>(index),
                              operationTimeDetailDTO: operationTimeDetailDTO,
                            ),
                            SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                          ]
                        : [
                            __OperationTimeCard(
                              key: ValueKey<int>(index),
                              operationTimeDetailDTO: operationTimeDetailDTO,
                              onEditFunction: (operationTimeDetailDTO) {
                                // print("onEditFunction index [$index] operationTimeDetailDTO");
                                setState(() {
                                  operationTimeDetailDTOList[index] = operationTimeDetailDTO;
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
                    widget.onSaveFunction(operationTimeDetailDTOList);
                    showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
                  },
                  label: "변경하기",
                  disabled: const DeepCollectionEquality().equals(widget.operationTimeDetailDTOList, operationTimeDetailDTOList))
            ],
          ),
        ));
  }
}

class __OperationRegularHolidayCard extends StatelessWidget {
  final OperationTimeDetailModel operationTimeDetailDTO;

  const __OperationRegularHolidayCard({
    super.key,
    required this.operationTimeDetailDTO,
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
              SGTypography.body("${operationTimeDetailDTO.day}요일", size: FontSize.normal, weight: FontWeight.w500),
              const Spacer(),
              SGTypography.body("정기휴무일", size: FontSize.normal, weight: FontWeight.w600, color: SGColors.gray4),
            ],
          )
        ],
      ),
    );
  }
}

class __OperationTimeCard extends StatelessWidget {
  final OperationTimeDetailModel operationTimeDetailDTO;
  final Function(OperationTimeDetailModel) onEditFunction;

  __OperationTimeCard({
    super.key,
    required this.operationTimeDetailDTO,
    required this.onEditFunction,
  })  : hourOptions = List.generate(
          24,
          (hour) => SelectionOption(
            label: formatHourToAmPmWithKoreanSuffix(hour.toString()),
            value: hour.toString(),
          ),
        ),
        hourWithout0Options = List.generate(
          23,
          (hour) => SelectionOption(
            label: formatHourToAmPmWithKoreanSuffix((hour + 1).toString()),
            value: (hour + 1).toString(),
          ),
        ),
        minuteOptions = [
          SelectionOption(label: "00분", value: "00"),
          SelectionOption(label: "30분", value: "30"),
        ];

  final List<SelectionOption<String>> hourOptions;
  final List<SelectionOption<String>> hourWithout0Options;
  final List<SelectionOption<String>> minuteOptions;

  @override
  Widget build(BuildContext context) {
    final startTime = operationTimeDetailDTO.startTime.split(':');
    final startHour = startTime[0];
    final startMinute = startTime[1];
    final endTime = operationTimeDetailDTO.endTime.split(':');
    final endHour = endTime[0];
    final endMinute = endTime[1];

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
              SGTypography.body("${operationTimeDetailDTO.day}요일", size: FontSize.normal, weight: FontWeight.w500),
              const Spacer(),
              SGTypography.body("24시", size: FontSize.normal, weight: FontWeight.w600, color: operationTimeDetailDTO.is24OperationHour() ? SGColors.primary : SGColors.gray4),
              SizedBox(width: SGSpacing.p1),
              SGSwitch(
                value: operationTimeDetailDTO.is24OperationHour(),
                onChanged: (value) {
                  if (value) {
                    onEditFunction(operationTimeDetailDTO.to24OperationHour);
                  } else {
                    onEditFunction(operationTimeDetailDTO.toDefaultOperationHour);
                  }
                },
              ),
            ],
          ),
          if (!operationTimeDetailDTO.is24OperationHour()) ...[
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
                          // 시작시 0시, 종료시 0시 설정하지 못하도록 한다.
                          if (value == "0" && operationTimeDetailDTO.endTime == "00:00") {
                            onEditFunction(operationTimeDetailDTO.copyWith(startTime: "$value:$startMinute", endTime: "01:00"));
                          } else {
                            onEditFunction(operationTimeDetailDTO.copyWith(startTime: "$value:$startMinute"));
                          }
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
                          onEditFunction(operationTimeDetailDTO.copyWith(startTime: "$startHour:$minute"));
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
                        options: operationTimeDetailDTO.startTime == "00:00" ? hourWithout0Options : hourOptions,
                        onSelect: (value) {
                          onEditFunction(operationTimeDetailDTO.copyWith(endTime: "$value:$endMinute"));
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
                          onEditFunction(operationTimeDetailDTO.copyWith(endTime: "$endHour:$minute"));
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
