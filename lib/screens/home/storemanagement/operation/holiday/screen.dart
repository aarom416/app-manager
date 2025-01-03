import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/regular_holidays_card.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/temporary_holidays_card.dart';

import '../../../../../core/components/snackbar.dart';
import '../model.dart';

class HolidayScreen extends StatefulWidget {
  final int holidayStatus;
  final List<OperationTimeDetailModel> regularHolidays;
  final List<OperationTimeDetailModel> temporaryHolidays;
  final Function(int, List<OperationTimeDetailModel>, List<OperationTimeDetailModel>) onSaveFunction;

  const HolidayScreen({super.key, required this.holidayStatus, required this.regularHolidays, required this.temporaryHolidays, required this.onSaveFunction});

  @override
  State<HolidayScreen> createState() => _HolidayScreenState();
}

class _HolidayScreenState extends State<HolidayScreen> {
  late int holidayStatus;
  late List<OperationTimeDetailModel> regularHolidays;
  late List<OperationTimeDetailModel> temporaryHolidays;

  @override
  void initState() {
    super.initState();
    holidayStatus = widget.holidayStatus;
    regularHolidays = widget.regularHolidays;
    temporaryHolidays = widget.temporaryHolidays;
  }

  bool areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  bool _isStateChanged() {
    return holidayStatus != widget.holidayStatus ||
        !areListsEqual(widget.regularHolidays, regularHolidays) ||
        !areListsEqual(widget.temporaryHolidays, temporaryHolidays);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "휴무일 변경"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                if (hasDuplicateRegularHolidays(regularHolidays)) {
                  showDefaultSnackBar(context, '중복된 정기휴무일이 있습니다.');
                } else if (hasDuplicateTemporaryHolidays(temporaryHolidays)) {
                  showDefaultSnackBar(context, '중복된 임시휴무일이 있습니다.');
                } else if (hasOverlappingDateRanges(temporaryHolidays)) {
                  showDefaultSnackBar(context, '날짜가 겹치는 임시휴무일이 있습니다.');
                } else if (_isStateChanged()){
                  widget.onSaveFunction(holidayStatus, regularHolidays, temporaryHolidays);
                  showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
                }
              },
              label: "변경하기",
              disabled: !_isStateChanged(),
            ),
         ),
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
                RegularHolidayCard(
                  regularHolidays: regularHolidays,
                  onEditFunction: (regularHolidays) {
                    // print("onEditFunction regularHolidays $regularHolidays");
                    setState(() {
                      this.regularHolidays = regularHolidays;
                    });
                  },
                ),

                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

                // --------------------------- 임시휴무 ---------------------------
                TemporaryHolidayCard(
                  temporaryHolidays: temporaryHolidays,
                  onEditFunction: (temporaryHolidays) {
                    // print("onEditFunction temporaryHolidays $temporaryHolidays");
                    setState(() {
                      this.temporaryHolidays = temporaryHolidays;
                    });
                  },
                ),

                SizedBox(height: SGSpacing.p20),
              ])),
        );
  }
}
