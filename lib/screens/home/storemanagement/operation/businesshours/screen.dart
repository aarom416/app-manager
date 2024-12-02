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

class StoreOperationTimesScreen extends StatefulWidget {
  final List<OperationTimeDetailModel> operationTimeDetails;
  final Function(List<OperationTimeDetailModel>) onSaveFunction;

  const StoreOperationTimesScreen({super.key, required this.operationTimeDetails, required this.onSaveFunction});

  @override
  State<StoreOperationTimesScreen> createState() => _StoreOperationTimesScreenState();
}

class _StoreOperationTimesScreenState extends State<StoreOperationTimesScreen> {
  late List<OperationTimeDetailModel> operationTimeDetails;

  @override
  void initState() {
    super.initState();
    operationTimeDetails = List.from(widget.operationTimeDetails);
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
              ...operationTimeDetails
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    OperationTimeDetailModel businessHour = entry.value;
                    print("businessHour $businessHour");
                    // if(businessHour.startTime == "00:00") {
                    //   return [
                    //     __OperationRegularHolidayCard(
                    //       key: ValueKey<int>(index),
                    //       businessHour: businessHour,
                    //     ),
                    //     SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                    //   ];
                    // } else {
                      return [
                        __OperationTimeCard(
                          key: ValueKey<int>(index),
                          businessHour: businessHour,
                          onEditFunction: (businessHour) {
                            // print("onEditFunction index [$index] $businessHour");
                            setState(() {
                              operationTimeDetails[index] = businessHour;
                            });
                          },
                        ),
                        SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                      ];
                    // }

                  })
                  .toList()
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(
                  onPressed: () {
                    widget.onSaveFunction(operationTimeDetails);
                    Navigator.of(context).pop();
                  },
                  label: "변경하기",
                  disabled: false)
            ],
          ),
        ));
  }
}

class __OperationTimeCard extends StatelessWidget {
  final OperationTimeDetailModel businessHour;
  final Function(OperationTimeDetailModel) onEditFunction;

  __OperationTimeCard({
    super.key,
    required this.businessHour,
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
    final startTime = businessHour.startTime.split(':');
    var startHour = startTime[0];
    var startMinute = startTime[1];
    final endTime = businessHour.endTime.split(':');
    var endHour = endTime[0];
    var endMinute = endTime[1];
    var is24Hour = startHour == "00" && startMinute == "00" && endHour == "24" && endMinute == "00";

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
              SGTypography.body("${businessHour.day}요일", size: FontSize.normal, weight: FontWeight.w500),
              const Spacer(),
              SGTypography.body("24시", size: FontSize.normal, weight: FontWeight.w600, color: is24Hour ? SGColors.primary : SGColors.gray4),
              SizedBox(width: SGSpacing.p1),
              SGSwitch(
                value: is24Hour,
                onChanged: (value) {
                  if (value) {
                    onEditFunction(businessHour.to24Hour());
                  } else {
                    onEditFunction(businessHour.toDefaultHour());
                  }
                  // onEditFunction(businessHour.copyWith(startTime: value ? "00:00" : "09:00", endTime: value ? "24:00" : "21:00"));
                },
              ),
            ],
          ),
          if (!is24Hour) ...[
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
                          if(value == "0" && businessHour.endTime == "00:00") {
                            onEditFunction(businessHour.copyWith(startTime: "$value:$startMinute", endTime: "01:00"));
                          } else {
                            onEditFunction(businessHour.copyWith(startTime: "$value:$startMinute"));
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
                          onEditFunction(businessHour.copyWith(startTime: "$startHour:$minute"));
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
                        options: businessHour.startTime == "00:00" ? hourWithout0Options : hourOptions,
                        onSelect: (value) {
                          onEditFunction(businessHour.copyWith(endTime: "$value:$endMinute"));
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
                          onEditFunction(businessHour.copyWith(endTime: "$endHour:$minute"));
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

class __OperationRegularHolidayCard extends StatelessWidget {
  final OperationTimeDetailModel businessHour;

  const __OperationRegularHolidayCard({
    super.key,
    required this.businessHour,
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
          SGTypography.body("${businessHour.day}요일", size: FontSize.normal, weight: FontWeight.w500),
          const Spacer(),
          SGTypography.body("정기휴무일 입니다", size: FontSize.normal, weight: FontWeight.w600, color: SGColors.gray4),
        ],
      ),
    );
  }
}


extension OperationTimeDetailModelExtensions on OperationTimeDetailModel {
  /// 기본 영업시간으로 변경
  OperationTimeDetailModel toDefaultHour() {
    return copyWith(startTime: "09:00", endTime: "21:00");
  }

  /// 24시간 영업으로 변경
  OperationTimeDetailModel to24Hour() {
    return copyWith(startTime: "00:00", endTime: "24:00");
  }

  /// 영업하지 않음(정기휴무)으로 변경
  // OperationTimeDetailModel toOffHour() {
  //   return copyWith(startTime: "00:00", endTime: "00:00");
  // }
}
