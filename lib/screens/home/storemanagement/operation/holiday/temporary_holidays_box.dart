import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/components/date_range_picker.dart';
import '../../../../../core/components/text_field_wrapper.dart';
import '../../../../common/common_widgets.dart';
import '../model.dart';

class TemporaryHolidaysBox extends StatefulWidget {
  final List<OperationTimeDetailModel> temporaryHolidays;
  final Function(List<OperationTimeDetailModel>) onEditFunction;

  const TemporaryHolidaysBox({
    super.key,
    required this.temporaryHolidays,
    required this.onEditFunction,
  });

  @override
  State<TemporaryHolidaysBox> createState() => _TemporaryHolidaysBoxState();
}

class _TemporaryHolidaysBoxState extends State<TemporaryHolidaysBox> {
  late List<TextEditingController> textEditingControllers;

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

  int MENT_INPUT_MAX = 100;

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
            padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4,
              vertical: SGSpacing.p5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...widget.temporaryHolidays
                    .asMap()
                    .entries
                    .map((entry) {

                      int index = entry.key;
                      OperationTimeDetailModel temporaryHoliday = entry.value;
                      DateRange dateRange = temporaryHoliday.toDateRange();
                      var textEditingController = textEditingControllers[index];

                      return [
                        Row(children: [
                          Expanded(
                            child: DateRangePicker(
                              key: ValueKey(dateRange.id),
                              variant: DateRangePickerVariant.small,
                              dateRange: dateRange,
                              onStartDateChanged: (startDate) {
                                if (dateRange.end.isBefore(startDate)) {
                                  showDefaultSnackBar(context, '시작 날짜는 종료 날짜보다 빨라야 합니다.');
                                } else {
                                  widget.temporaryHolidays[index] = temporaryHoliday.copyWith(startDate: DateFormat('yyyy.MM.dd').format(startDate));
                                  widget.onEditFunction(widget.temporaryHolidays);
                                }
                              },
                              onEndDateChanged: (endDate) {
                                if (dateRange.start.isAfter(endDate)) {
                                  showDefaultSnackBar(context, '종료 날짜는 시작 날짜보다 늦어야 합니다.');
                                } else {
                                  widget.temporaryHolidays[index] = temporaryHoliday.copyWith(endDate: DateFormat('yyyy.MM.dd').format(endDate));
                                  widget.onEditFunction(widget.temporaryHolidays);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: SGSpacing.p3),
                          GestureDetector(
                            onTap: () {
                              widget.temporaryHolidays.removeAt(index);
                              widget.onEditFunction(widget.temporaryHolidays);
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
                                onChanged: (inputValue) {
                                  print("onChanged $inputValue");
                                  var inputValue_ = inputValue.substring(0, MENT_INPUT_MAX);
                                  print("inputValue_ $inputValue_");
                                  textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: MENT_INPUT_MAX));
                                  widget.temporaryHolidays[index] = temporaryHoliday.copyWith(ment: inputValue);
                                  widget.onEditFunction(widget.temporaryHolidays);
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
                    /// 중복 확인
                    bool hasDuplicateEntries(List<OperationTimeDetailModel> data) {
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

                    print("temporaryHolidays ${widget.temporaryHolidays}");
                    if (hasDuplicateEntries(widget.temporaryHolidays)) {
                      showDefaultSnackBar(context, '중복된 임시휴무일이 있습니다.');
                    } else {
                      textEditingControllers.add(TextEditingController(text: ''));
                      var dateRange = DateRange(id: DateTime.now().millisecondsSinceEpoch, start: DateTime.now(), end: DateTime.now().add(const Duration(days: 30)));
                      print("dateRange ${dateRange.start} ${dateRange.end}");
                      widget.temporaryHolidays.add(dateRange.toOperationTimeDetailModel());
                      widget.onEditFunction(widget.temporaryHolidays);
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

/// OperationTimeDetailModel 에서 DateRange 를 만드는 확장함수
extension OperationTimeDetailModelExtensions on OperationTimeDetailModel {
  DateRange toDateRange() {
    final dateFormat = DateFormat("yyyy.MM.dd");
    int uniqueId = DateTime.now().millisecondsSinceEpoch;
    DateTime startDate = dateFormat.parse(this.startDate);
    DateTime endDate = dateFormat.parse(this.endDate);
    return DateRange(id: uniqueId, start: startDate, end: endDate);
  }
}

/// DateRange 에서 OperationTimeDetailModel 를 만드는 확장함수
extension DateRangeExtensions on DateRange {
  OperationTimeDetailModel toOperationTimeDetailModel() {
    final dateFormat = DateFormat("yyyy.MM.dd");
    return OperationTimeDetailModel(holidayType: 1, startDate: dateFormat.format(start), endDate: dateFormat.format(end), ment: "기본 멘트...");
  }
}
