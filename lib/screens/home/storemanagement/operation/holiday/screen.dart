import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/regular_holidays_box.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/temporary_holidays_box.dart';

import '../../../../common/common_widgets.dart';
import '../model.dart';

class StoreHolidayScreen extends StatefulWidget {
  final int holidayStatus;
  final List<OperationTimeDetailModel> holidayDetails;
  final Function(int, List<OperationTimeDetailModel>, List<OperationTimeDetailModel>) onSaveFunction;

  const StoreHolidayScreen({super.key, required this.holidayStatus, required this.holidayDetails, required this.onSaveFunction});

  @override
  State<StoreHolidayScreen> createState() => _StoreHolidayScreenState();
}

class _StoreHolidayScreenState extends State<StoreHolidayScreen> {
  late int holidayStatus;
  late List<OperationTimeDetailModel> holidayDetails;
  late List<OperationTimeDetailModel> regularHolidays;
  late List<OperationTimeDetailModel> temporaryHolidays;

  @override
  void initState() {
    super.initState();
    holidayStatus = widget.holidayStatus;
    holidayDetails = List.from(widget.holidayDetails);
    // 정기휴무. cycle 순 정렬
    regularHolidays = holidayDetails.where((element) => element.holidayType == 0).toList()..sort((a, b) => a.cycle.compareTo(b.cycle));
    // 임시휴무. startDate 순 정렬
    temporaryHolidays = holidayDetails.where((element) => element.holidayType != 0).toList()
      ..sort((a, b) => DateFormat('yyyy.MM.dd').parse(a.startDate).compareTo(
            DateFormat('yyyy.MM.dd').parse(b.startDate),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "휴무일 변경"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                print("holidayStatus $holidayStatus");
                print("regularHolidays $regularHolidays");
                print("temporaryHolidays $temporaryHolidays");
                if (hasDuplicateRegularHolidays(regularHolidays)) {
                  showDefaultSnackBar(context, '중복된 정기휴무일이 있습니다.');
                } else if (hasDuplicateTemporaryHolidays(temporaryHolidays)) {
                  showDefaultSnackBar(context, '중복된 임시휴무일이 있습니다.');
                } else {
                  widget.onSaveFunction(holidayStatus, regularHolidays, temporaryHolidays);
                  Navigator.of(context).pop();
                }
              },
              label: "변경하기")),
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
            RegularHolidaysBox(
              regularHolidays: regularHolidays,
              onEditFunction: (regularHolidays_) {
                print("onEditFunction regularHolidays_ $regularHolidays_");
                setState(() {
                  regularHolidays = regularHolidays_;
                });
              },
            ),

            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

            // --------------------------- 임시휴무 ---------------------------
            TemporaryHolidaysBox(
              temporaryHolidays: temporaryHolidays,
              onEditFunction: (temporaryHolidays_) {
                print("onEditFunction temporaryHolidays_ $temporaryHolidays_");
                setState(() {
                  temporaryHolidays = temporaryHolidays_;
                });
              },
            ),

            SizedBox(height: SGSpacing.p10),
          ])),
    );
  }
}
