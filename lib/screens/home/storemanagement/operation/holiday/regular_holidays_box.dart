import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../common/common_widgets.dart';
import '../model.dart';

const List<String> regularHolidayTypes = [
  "매주",
  "매월 첫 번째",
  "매월 두 번째",
  "매월 세 번째",
  "매월 네 번째",
  "매월 다섯 번째",
  "매월 마지막",
];

final List<SelectionOption<int>> regularHolidayOptions = [...regularHolidayTypes.mapIndexed((index, regularHolidayType) => SelectionOption(value: index, label: regularHolidayType))];

final List<SelectionOption<String>> daysOfWeekOptions = [
  SelectionOption(value: "월", label: "월요일"),
  SelectionOption(value: "화", label: "화요일"),
  SelectionOption(value: "수", label: "수요일"),
  SelectionOption(value: "목", label: "목요일"),
  SelectionOption(value: "금", label: "금요일"),
  SelectionOption(value: "토", label: "토요일"),
  SelectionOption(value: "일", label: "일요일"),
];

class RegularHolidayBox extends StatelessWidget {
  final List<OperationTimeDetailModel> regularHolidays;
  final Function(List<OperationTimeDetailModel>) onEditFunction;

  const RegularHolidayBox({
    super.key,
    required this.regularHolidays,
    required this.onEditFunction,
  });

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
                ...regularHolidays
                    .mapIndexed((index, regularHoliday) => [
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  showSelectionBottomSheet<int>(
                                      context: context,
                                      title: "정기 휴무일의 주기를 설정해주세요.",
                                      options: regularHolidayOptions,
                                      onSelect: (cycle) {
                                        regularHolidays[index] = regularHoliday.copyWith(cycle: cycle);
                                        onEditFunction(regularHolidays);
                                      },
                                      selected: regularHoliday.cycle);
                                },
                                child: SGTextFieldWrapper(
                                    child: SGContainer(
                                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    SGTypography.body(regularHolidayTypes[regularHoliday.cycle], color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w500),
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
                                      onSelect: (day) {
                                        regularHolidays[index] = regularHoliday.copyWith(day: day);
                                        onEditFunction(regularHolidays);
                                      },
                                      selected: regularHoliday.day);
                                },
                                child: SGTextFieldWrapper(
                                    child: SGContainer(
                                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    SGTypography.body("${regularHoliday.day}요일", color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w500),
                                    Image.asset(
                                      'assets/images/dropdown-arrow.png',
                                      width: 16,
                                      height: 16,
                                      color: SGColors.gray4,
                                    ),
                                  ]),
                                )),
                              ),
                            ),
                            SizedBox(width: SGSpacing.p3),
                            GestureDetector(
                              onTap: () {
                                regularHolidays.removeAt(index);
                                onEditFunction(regularHolidays);
                              },
                              child: SGContainer(
                                  borderWidth: 0,
                                  width: SGSpacing.p5,
                                  height: SGSpacing.p5,
                                  borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                                  color: SGColors.warningRed,
                                  child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16))),
                            ),
                          ]),
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                        ])
                    .flattened,
                GestureDetector(
                  onTap: () {
                    if (hasDuplicateRegularHolidays(regularHolidays)) {
                      showDefaultSnackBar(context, '중복된 정기휴무일이 있습니다.');
                    } else {
                      regularHolidays.add(const OperationTimeDetailModel(holidayType: 0, cycle: 0, day: "월"));
                      onEditFunction(regularHolidays);
                    }
                  },
                  child: Row(children: [Image.asset("assets/images/accumulative.png", width: 24, height: 24), SizedBox(width: SGSpacing.p1), SGTypography.body("정기 휴무 추가하기", size: FontSize.small)]),
                ),
              ],
            )),
      ],
    );
  }
}

/// regularHolidays 중복 확인
bool hasDuplicateRegularHolidays(List<OperationTimeDetailModel> data) {
  final seen = <String>{};
  for (var item in data) {
    final key = "${item.holidayType}-${item.cycle}-${item.day}";
    if (seen.contains(key)) {
      return true; // 중복 발견
    }
    seen.add(key);
  }
  return false; // 중복 없음
}
