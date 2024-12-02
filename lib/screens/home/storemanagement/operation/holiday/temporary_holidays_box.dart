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
import '../model.dart';

class TemporaryHolidaysBox extends StatelessWidget {
  final List<OperationTimeDetailModel> temporaryHolidays;
  final Function(List<OperationTimeDetailModel>) onEditFunction;

  const TemporaryHolidaysBox({
    super.key,
    required this.temporaryHolidays,
    required this.onEditFunction,
  });

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
                ...temporaryHolidays
                    .map((temporaryHoliday) => Tuple2(temporaryHoliday, temporaryHoliday.toDateRange()))
                    .mapIndexed((index, holidayDateRangePair) => [
                          Row(children: [
                            Expanded(
                              child: DateRangePicker(
                                key: ValueKey(holidayDateRangePair.item2.id),
                                variant: DateRangePickerVariant.small,
                                dateRange: holidayDateRangePair.item2,
                                onStartDateChanged: (startDate) {
                                  temporaryHolidays[index] = holidayDateRangePair.item1.copyWith(startDate: DateFormat('yyyy.MM.dd').format(startDate));
                                  onEditFunction(temporaryHolidays);
                                },
                                onEndDateChanged: (endDate) {
                                  temporaryHolidays[index] = holidayDateRangePair.item1.copyWith(endDate: DateFormat('yyyy.MM.dd').format(endDate));
                                  onEditFunction(temporaryHolidays);
                                },
                              ),
                            ),
                            SizedBox(width: SGSpacing.p3),
                            GestureDetector(
                              onTap: () {
                                temporaryHolidays.removeAt(index);
                                onEditFunction(temporaryHolidays);
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

                    print("temporaryHolidays $temporaryHolidays");
                    if (hasDuplicateEntries(temporaryHolidays)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('중복된 임시휴무일이 있습니다.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      temporaryHolidays.add(DateRange(id: DateTime.now().millisecondsSinceEpoch, start: DateTime.now(), end: DateTime.now().add(const Duration(days: 1))).toOperationTimeDetailModel());
                      onEditFunction(temporaryHolidays);
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
    return OperationTimeDetailModel(
      holidayType: 1,
      startDate: dateFormat.format(start),
      endDate: dateFormat.format(end),
    );
  }
}
