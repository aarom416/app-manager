import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../../core/components/date_range_picker.dart';
import '../../../../../core/components/text_field_wrapper.dart';
import '../../../../common/common_widgets.dart';
import '../model.dart';

class TemporaryHolidayBox extends StatefulWidget {
  final List<OperationTimeDetailModel> temporaryHolidays;
  final Function(List<OperationTimeDetailModel>) onEditFunction;

  const TemporaryHolidayBox({
    super.key,
    required this.temporaryHolidays,
    required this.onEditFunction,
  });

  @override
  State<TemporaryHolidayBox> createState() => _TemporaryHolidayBoxState();
}

class _TemporaryHolidayBoxState extends State<TemporaryHolidayBox> {
  late List<TextEditingController> textEditingControllers;

  final int MENT_INPUT_MAX = 100;

  @override
  void initState() {
    super.initState();
    textEditingControllers = widget.temporaryHolidays.map((holiday) => TextEditingController(text: holiday.ment)).toList();
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: SGSpacing.p6),
        SGTypography.body("임시 휴무", color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
        SizedBox(height: SGSpacing.p3),
        SGContainer(
            color: SGColors.white,
            borderColor: SGColors.line2,
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.temporaryHolidays
                    .asMap()
                    .entries
                    .map((entry) {
                      int index = entry.key;
                      OperationTimeDetailModel temporaryHoliday = entry.value;
                      DateRange dateRange = temporaryHoliday.toDateRange;
                      var textEditingController = textEditingControllers[index];

                      return [
                        Row(children: [
                          Expanded(
                            child: DateRangePicker(
                              key: ValueKey(dateRange.id),
                              variant: DateRangePickerVariant.small,
                              dateRange: dateRange,
                              onStartDateChanged: (startDate) {
                                // print("onStartDateChanged $startDate");
                                if (dateRange.end.isBefore(startDate)) {
                                  showDefaultSnackBar(context, '시작 날짜는 종료 날짜보다 빨라야 합니다.', seconds: 4);
                                  widget.onEditFunction(widget.temporaryHolidays);
                                } else {
                                  final updatedHolidays = List<OperationTimeDetailModel>.from(widget.temporaryHolidays);
                                  updatedHolidays[index] = temporaryHoliday.copyWith(startDate: DateFormat('yyyy.MM.dd').format(startDate));
                                  widget.onEditFunction(updatedHolidays);
                                }
                              },
                              onEndDateChanged: (endDate) {
                                // print("onEndDateChanged dateRange.start ${dateRange.start}");
                                // print("onEndDateChanged $endDate");
                                if (dateRange.start.isAfter(endDate)) {
                                  showDefaultSnackBar(context, '종료 날짜는 시작 날짜보다 늦어야 합니다.', seconds: 4);
                                  widget.onEditFunction(widget.temporaryHolidays);
                                } else {
                                  final updatedHolidays = List<OperationTimeDetailModel>.from(widget.temporaryHolidays);
                                  updatedHolidays[index] = temporaryHoliday.copyWith(endDate: DateFormat('yyyy.MM.dd').format(endDate));
                                  widget.onEditFunction(updatedHolidays);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: SGSpacing.p3),
                          GestureDetector(
                            onTap: () {
                              textEditingControllers.removeAt(index).dispose();
                              final updatedHolidays = List<OperationTimeDetailModel>.from(widget.temporaryHolidays);
                              updatedHolidays.removeAt(index);
                              widget.onEditFunction(updatedHolidays);
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
                        SGTextFieldWrapper(
                            child: SGContainer(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          height: SGSpacing.p12,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              TextField(
                                controller: textEditingController,
                                maxLines: 5,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(MENT_INPUT_MAX), // 최대 입력 길이 제한
                                ],
                                onChanged: (inputValue) {
                                  // print("onChanged $inputValue");
                                  final updatedHolidays = List<OperationTimeDetailModel>.from(widget.temporaryHolidays);
                                  updatedHolidays[index] = temporaryHoliday.copyWith(ment: inputValue);
                                  widget.onEditFunction(updatedHolidays);
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: SGSpacing.p3, horizontal: SGSpacing.p4),
                                  // 패딩 조정
                                  isCollapsed: true,
                                  hintText: "ex) 가게 리모델링으로 1월 5일 ~ 8일 쉬어요",
                                  hintStyle: TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small, color: SGColors.gray3),
                                  border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                                ),
                                textAlignVertical: TextAlignVertical.center, // 텍스트 가운데 정렬
                              ),
                            ],
                          ),
                        )),
                        SizedBox(height: SGSpacing.p3),
                      ];
                    })
                    .toList()
                    .flattened,
                GestureDetector(
                  onTap: () {
                    // print("temporaryHolidays ${widget.temporaryHolidays}");
                    if (hasDuplicateTemporaryHolidays(widget.temporaryHolidays)) {
                      showDefaultSnackBar(context, '중복된 임시휴무일이 있습니다.');
                    } else if (hasOverlappingDateRanges(widget.temporaryHolidays)) {
                      showDefaultSnackBar(context, '날짜가 겹치는 임시휴무일이 있습니다.');
                    } else {
                      // 새로운 임시 휴무 추가
                      var dateRange = DateRange(id: DateTime.now().millisecondsSinceEpoch, start: DateTime.now(), end: DateTime.now().add(const Duration(days: 30)));
                      // print("dateRange ${dateRange.start} ${dateRange.end}");
                      final newHoliday = dateRange.toOperationTimeDetailModel();
                      textEditingControllers.add(TextEditingController(text: newHoliday.ment));
                      final updatedHolidays = List<OperationTimeDetailModel>.from(widget.temporaryHolidays);
                      updatedHolidays.add(newHoliday);
                      widget.onEditFunction(updatedHolidays);
                    }
                  },
                  child: Row(children: [Image.asset("assets/images/accumulative.png", width: 24, height: 24), SizedBox(width: SGSpacing.p1), SGTypography.body("임시 휴무 추가하기", size: FontSize.small)]),
                ),
              ],
            )),
      ],
    );
  }
}

/// DateRange 에서 OperationTimeDetailModel 를 만드는 확장함수
extension DateRangeExtensions on DateRange {
  OperationTimeDetailModel toOperationTimeDetailModel() {
    final dateFormat = DateFormat("yyyy.MM.dd");
    return OperationTimeDetailModel(holidayType: 1, startDate: dateFormat.format(start), endDate: dateFormat.format(end));
  }
}

/// temporaryHolidays 중복 확인
bool hasDuplicateTemporaryHolidays(List<OperationTimeDetailModel> data) {
  final seen = <String>{};
  for (var item in data) {
    final key = "${item.holidayType}-${item.startDate}-${item.endDate}";
    if (seen.contains(key)) {
      return true; // 중복 발견
    }
    seen.add(key);
  }
  return false; // 중복 없음
}

/// temporaryHolidays 서로 겹치는 날짜가 있는지 확인
bool hasOverlappingDateRanges(List<OperationTimeDetailModel> temporaryHolidays) {
  // 날짜 형식을 정의
  final dateFormat = DateFormat("yyyy.MM.dd");

  // 시작 날짜와 종료 날짜를 각각 리스트로 추출
  final startDates = temporaryHolidays.map((holiday) => dateFormat.parse(holiday.startDate)).toList();
  final endDates = temporaryHolidays.map((holiday) => dateFormat.parse(holiday.endDate)).toList();

  // 시작 날짜와 종료 날짜를 정렬 (시작 날짜 기준)
  final sortedIndices = List.generate(startDates.length, (index) => index)..sort((a, b) => startDates[a].compareTo(startDates[b]));

  // 정렬된 날짜를 기반으로 중복 여부 확인
  for (int i = 0; i < sortedIndices.length - 1; i++) {
    final currentIndex = sortedIndices[i];
    final nextIndex = sortedIndices[i + 1];

    // 현재 범위의 종료 날짜가 다음 범위의 시작 날짜 이상인지 확인
    if (!endDates[currentIndex].isBefore(startDates[nextIndex])) {
      return true; // 겹침 발견
    }
  }

  return false; // 겹침 없음
}
