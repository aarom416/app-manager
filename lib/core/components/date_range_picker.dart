import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

enum DateRangeType {
  month,
  entire;
}

enum DateRangePickerVariant {
  small,
  normal;
}

class DateRange {
  DateRange({this.id, required this.start, required this.end});

  int? id;
  final DateTime start;
  final DateTime end;

  DateRange copyWith({int? id, DateTime? start, DateTime? end}) {
    return DateRange(id: id ?? this.id, start: start ?? this.start, end: end ?? this.end);
  }
}

typedef DateTimeCallback = void Function(DateTime);

class DateRangePicker extends StatefulWidget {
  final DateRange dateRange;
  final DateTimeCallback onStartDateChanged;
  final DateTimeCallback onEndDateChanged;
  final DateRangePickerVariant variant;

  DateRangePicker(
      {super.key,
      required this.dateRange,
      required this.onStartDateChanged,
      required this.onEndDateChanged,
      this.variant = DateRangePickerVariant.normal});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateRange dateRange;

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    dateRange = widget.dateRange;
    startDate = dateRange.start;
    endDate = dateRange.end;
  }

  String formatDate(DateTime date) {
    return "${date.year}년 ${date.month}월 ${date.day}일 (${weekDay(date)})";
  }

  String weekDay(DateTime date) {
    return date.weekday == 1
        ? "월"
        : date.weekday == 2
            ? "화"
            : date.weekday == 3
                ? "수"
                : date.weekday == 4
                    ? "목"
                    : date.weekday == 5
                        ? "금"
                        : date.weekday == 6
                            ? "토"
                            : "일";
  }

  Widget _renderDateTimeButton({required DateTime datetime, required DateTimeCallback onDateTimeConfirmed}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDatePickerModalBottomSheet(
              date: datetime,
              onDateTimeConfirmed: (DateTime datetime) {
                onDateTimeConfirmed(datetime);
              });
        },
        child: SGContainer(
          borderColor: SGColors.line3,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p4),
          color: Colors.white,
          child: Center(
            child: SGTypography.body(formatDate(datetime),
                size: FontSize.small,
                color: SGColors.black,
                weight: FontWeight.w400,
                letterSpacing: -0.5),
          ),
        ),
      ),
    );
  }

  void showDatePickerModalBottomSheet({required DateTime date, required DateTimeCallback onDateTimeConfirmed}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (ctx) {
          return DatePickerModalBottomSheet(ctx: ctx, date: date, onDateTimeConfirmed: onDateTimeConfirmed);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _renderDateTimeButton(
          datetime: dateRange.start,
          onDateTimeConfirmed: (DateTime datetime) {
            setState(() {
              dateRange = dateRange.copyWith(start: datetime);
            });
            widget.onStartDateChanged(datetime);
          }),
      SGContainer(
          borderWidth: 0,
          padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p2,
          ),
          child: SGTypography.body("~")),
      _renderDateTimeButton(
          datetime: dateRange.end,
          onDateTimeConfirmed: (DateTime datetime) {
            setState(() {
              dateRange = dateRange.copyWith(end: datetime);
            });
            widget.onEndDateChanged(datetime);
          })
    ]);
  }
}

class MonthlyRangePicker extends StatefulWidget {
  final DateRange dateRange;
  final DateTimeCallback onDateChanged;

  MonthlyRangePicker({super.key, required this.dateRange, required this.onDateChanged});

  @override
  State<MonthlyRangePicker> createState() => _MonthlyRangePickerState();
}

class _MonthlyRangePickerState extends State<MonthlyRangePicker> {
  late DateRange dateRange;

  late DateTime date;

  @override
  void initState() {
    super.initState();
    dateRange = widget.dateRange;
    date = dateRange.start;
  }

  String formatDate(DateTime date) {
    return "${date.year}년 ${date.month}월";
  }

  Widget _renderDateTimeButton({required DateTime datetime, required DateTimeCallback onDateTimeConfirmed}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDatePickerModalBottomSheet(
              date: datetime,
              onDateTimeConfirmed: (DateTime datetime) {
                onDateTimeConfirmed(datetime);
              });
        },
        child: SGContainer(
          borderColor: SGColors.line3,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p4),
          color: Colors.white,
          child: SGTypography.body(formatDate(datetime),
              size: FontSize.small, color: Colors.black, weight: FontWeight.w400, letterSpacing: -0.5),
        ),
      ),
    );
  }

  void showDatePickerModalBottomSheet({required DateTime date, required DateTimeCallback onDateTimeConfirmed}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (ctx) {
          return DatePickerModalBottomSheet(
              ctx: ctx, dateRangeType: DateRangeType.month, date: date, onDateTimeConfirmed: onDateTimeConfirmed);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      _renderDateTimeButton(
          datetime: dateRange.start,
          onDateTimeConfirmed: (DateTime datetime) {
            setState(() {
              final startDate = datetime.copyWith(day: 1);
              final endDate = datetime.copyWith(month: datetime.month + 1, day: 1).subtract(Duration(days: 1));
              dateRange = dateRange.copyWith(start: startDate, end: endDate);
            });
            widget.onDateChanged(datetime);
          })
    ]);
  }
}

class DatePickerModalBottomSheet extends StatefulWidget {
  DatePickerModalBottomSheet({
    super.key,
    required this.ctx,
    required this.date,
    required this.onDateTimeConfirmed,
    this.dateRangeType = DateRangeType.entire,
  });

  final BuildContext ctx;
  final DateTime date;
  final DateRangeType dateRangeType;

  final DateTimeCallback onDateTimeConfirmed;

  @override
  State<DatePickerModalBottomSheet> createState() => _DatePickerModalBottomSheetState();
}

class _DatePickerModalBottomSheetState extends State<DatePickerModalBottomSheet> {
  late DateTime draftDate;

  @override
  void initState() {
    super.initState();
    draftDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, physics: BouncingScrollPhysics(), children: [
      SGContainer(
        color: Colors.transparent,
        padding: EdgeInsets.all(SGSpacing.p2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            SGTypography.body("기간 선택", size: FontSize.medium, weight: FontWeight.w700),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: IconButton(
                        iconSize: SGSpacing.p6,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(widget.ctx).pop();
                        })),
              ],
            )),
          ],
        ),
      ),
      DatePickerWrapper(
          date: draftDate,
          dateRangeType: widget.dateRangeType,
          onDateTimeChanged: (DateTime datetime) {
            setState(() {
              draftDate = datetime;
            });
          }),

      SGContainer(
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(top: SGSpacing.p4, bottom: SGSpacing.p5),
        child: GestureDetector(
          onTap: () {
            widget.onDateTimeConfirmed(draftDate);
            Navigator.of(context).pop();
          },
          child: SGContainer(
              padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
              width: double.infinity,
              color: SGColors.primary,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Center(
                  child: SGTypography.body("완료", color: Colors.white, weight: FontWeight.w700, size: FontSize.medium))),
        ),
      ),
      // TODO: 완료 버튼
    ]);
  }
}

class DatePickerWrapper extends StatefulWidget {
  DatePickerWrapper(
      {super.key, required this.date, required this.onDateTimeChanged, this.dateRangeType = DateRangeType.entire});

  final DateTime date;
  final DateTimeCallback onDateTimeChanged;
  final DateRangeType dateRangeType;

  @override
  State<DatePickerWrapper> createState() => _DatePickerWrapperState();
}

class _DatePickerWrapperState extends State<DatePickerWrapper> {
  late DateTime _selectedDate;
  ScrollViewDetailOptions get detailOption => ScrollViewDetailOptions(
        selectedTextStyle: TextStyle(
          color: SGColors.black,
          fontSize: FontSize.large,
          fontWeight: FontWeight.w500,
        ),
        textStyle: TextStyle(
          color: SGColors.gray4,
          fontSize: FontSize.normal,
          fontWeight: FontWeight.w400,
        ),
      );

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      height: 216.0,
      padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
      child: ScrollDatePicker(
          viewType: widget.dateRangeType == DateRangeType.entire
              ? [DatePickerViewType.year, DatePickerViewType.month, DatePickerViewType.day]
              : [DatePickerViewType.year, DatePickerViewType.month],
          selectedDate: _selectedDate,
          locale: Locale('ko', 'KR'),
          scrollViewOptions: DatePickerScrollViewOptions(
              year: detailOption,
              month: detailOption,
              day: detailOption,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly),
          options: DatePickerOptions(perspective: 0.01, itemExtent: 36.0, diameterRatio: 18),
          onDateTimeChanged: (DateTime datetime) {
            setState(() {
              widget.onDateTimeChanged(datetime);
              _selectedDate = datetime;
            });
          }),
    );
  }
}
