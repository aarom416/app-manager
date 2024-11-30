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

class StoreBreakTimesScreen extends StatefulWidget {
  final List<OperationTimeDetailModel> breakTimeDetails;
  final Function(List<OperationTimeDetailModel>) onSaveFunction;

  const StoreBreakTimesScreen(
      {super.key,
      required this.breakTimeDetails,
      required this.onSaveFunction});

  @override
  State<StoreBreakTimesScreen> createState() =>
      _StoreBreakTimesScreenState();
}

class _StoreBreakTimesScreenState extends State<StoreBreakTimesScreen> {
  late List<OperationTimeDetailModel> breakTimeDetails;

  @override
  void initState() {
    super.initState();
    breakTimeDetails = List.from(widget.breakTimeDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "휴게시간 변경"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(
            children: [
              ...breakTimeDetails
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    OperationTimeDetailModel businessHour = entry.value;
                    return [
                      __BreakTimeCard(
                        key: ValueKey<int>(index),
                        businessHour: businessHour,
                        onEditFunction: (businessHour) {
                          // print("onEditFunction index [$index] $businessHour");
                          setState(() {
                            breakTimeDetails[index] = businessHour;
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
                    widget.onSaveFunction(breakTimeDetails);
                  },
                  label: "변경하기",
                  disabled: false)
            ],
          ),
        ));
  }
}

class __BreakTimeCard extends StatelessWidget {
  final OperationTimeDetailModel businessHour;
  final Function(OperationTimeDetailModel) onEditFunction;

  __BreakTimeCard({
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
        minuteOptions = [
          SelectionOption(label: "00분", value: "00"),
          SelectionOption(label: "30분", value: "30"),
        ];

  final List<SelectionOption<String>> hourOptions;
  final List<SelectionOption<String>> minuteOptions;

  @override
  Widget build(BuildContext context) {
    final startTime = businessHour.startTime.split(':');
    var startHour = startTime[0];
    var startMinute = startTime[1];
    final endTime = businessHour.endTime.split(':');
    var endHour = endTime[0];
    var endMinute = endTime[1];
    var isNoBreak = startHour == "00" &&
        startMinute == "00" &&
        endHour == "00" &&
        endMinute == "00";

    return SGContainer(
      color: SGColors.white,
      borderColor: SGColors.line2,
      padding: EdgeInsets.symmetric(
          horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      boxShadow: SGBoxShadow.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body("${businessHour.day}요일",
                  size: FontSize.normal, weight: FontWeight.w500),
              Spacer(),
              SGTypography.body("24시",
                  size: FontSize.normal,
                  weight: FontWeight.w600,
                  color: isNoBreak ? SGColors.primary : SGColors.gray4),
              SizedBox(width: SGSpacing.p1),
              SGSwitch(
                value: isNoBreak,
                onChanged: (value) {
                  onEditFunction(businessHour.copyWith(
                      startTime: value ? "00:00" : "15:00",
                      endTime: value ? "00:00" : "17:00"));
                },
              ),
            ],
          ),
          if (!isNoBreak) ...[
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("시작 시간",
                weight: FontWeight.w600, color: SGColors.gray4),
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
                          onEditFunction(businessHour.copyWith(
                              startTime: "$value:$startMinute"));
                        },
                        selected: startHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(
                              formatHourToAmPmWithKoreanSuffix(startHour),
                              color: SGColors.black,
                              size: FontSize.normal,
                              weight: FontWeight.w500),
                          Image.asset('assets/images/dropdown-arrow.png',
                              width: 16, height: 16),
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
                          onEditFunction(businessHour.copyWith(
                              startTime: "$startHour:$minute"));
                        },
                        selected: startMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body("$startMinute분",
                              color: SGColors.black,
                              size: FontSize.normal,
                              weight: FontWeight.w500),
                          Image.asset('assets/images/dropdown-arrow.png',
                              width: 16, height: 16),
                        ]),
                  )),
                ),
              ),
            ]),
            SizedBox(height: SGSpacing.p4 + SGSpacing.p05),
            SGTypography.body("종료 시간",
                weight: FontWeight.w600, color: SGColors.gray4),
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
                          onEditFunction(businessHour.copyWith(
                              endTime: "$value:$endMinute"));
                        },
                        selected: endHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(
                              formatHourToAmPmWithKoreanSuffix(endHour),
                              color: SGColors.black,
                              size: FontSize.normal,
                              weight: FontWeight.w500),
                          Image.asset('assets/images/dropdown-arrow.png',
                              width: 16, height: 16),
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
                          onEditFunction(businessHour.copyWith(
                              endTime: "$endHour:$minute"));
                        },
                        selected: endMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body("$endMinute분",
                              color: SGColors.black,
                              size: FontSize.normal,
                              weight: FontWeight.w500),
                          Image.asset('assets/images/dropdown-arrow.png',
                              width: 16, height: 16),
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
