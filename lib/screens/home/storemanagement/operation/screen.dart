import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/operation/holiday/screen.dart';

import '../../../../utils/time_utils.dart';
import 'breaktime/screen.dart';
import 'model.dart';
import 'operationtime/screen.dart';
import 'provider.dart';

class StoreOperationScreen extends ConsumerStatefulWidget {
  const StoreOperationScreen({super.key});

  @override
  ConsumerState<StoreOperationScreen> createState() => _StoreOperationScreenState();
}

class _StoreOperationScreenState extends ConsumerState<StoreOperationScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(storeOperationNotifierProvider.notifier).getOperationInfo();
    });
  }

  void showSGDialogWithImageBoth({
    required BuildContext context,
    required List<Widget> Function(BuildContext) childrenBuilder,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SGContainer(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SGSpacing.p3),
            padding: EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05).copyWith(bottom: 0),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05).copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: SGSpacing.p2),
                    Image.asset("assets/images/warning.png", width: SGSpacing.p12),
                    SizedBox(height: SGSpacing.p3),
                    ...childrenBuilder(context),
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  void showFailDialogWithImageBoth(StoreOperationNotifier provider, int type, String mainTitle, String subTitle) {
    showSGDialogWithImageBoth(
        context: context,
        childrenBuilder: (context) => [
              Column(
                children: [
                  Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                  SizedBox(height: SGSpacing.p2),
                  Center(child: SGTypography.body(subTitle, color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
                  SizedBox(height: SGSpacing.p6),
                ],
              ),
              Row(
                children: [
                  SGFlexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        color: SGColors.gray3,
                        child: Center(
                          child: SGTypography.body("취소", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: SGSpacing.p2),
                  SGFlexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (type == 0) {
                          provider.updateDeliveryStatus(0); // 배달 상태 수정
                        } else {
                          provider.updatePickupStatus(0); // 포장 상태 수정
                        }
                      },
                      child: SGContainer(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        color: SGColors.primary,
                        child: Center(
                          child: SGTypography.body("확인", size: FontSize.normal, weight: FontWeight.w700, color: SGColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeOperationNotifierProvider);

    final provider = ref.read(storeOperationNotifierProvider.notifier);

    List<OperationTimeDetailModel> regularHolidays = state.holidayDetailDTOList.where((holiday) => holiday.isRegularHoliday()).toList()..sort((a, b) => a.cycle.compareTo(b.cycle));

    List<OperationTimeDetailModel> temporaryHolidays = state.holidayDetailDTOList.where((holiday) => holiday.isTemporaryHoliday()).toList()
      ..sort((a, b) => DateFormat('yyyy.MM.dd').parse(a.startDate).compareTo(
            DateFormat('yyyy.MM.dd').parse(b.startDate),
          ));

    List<String> regularHolidayLabels = groupRegularHolidaysByCycle(regularHolidays);

    var groupedOperationTimeDetailDTOList = groupByStartAndEndTime(state.operationTimeDetailDTOList, regularHolidays);

    var groupedBreakTimeDetailDTOList = groupByStartAndEndTime(fillMissingDays(state.breakTimeDetailDTOList), regularHolidays);

    return ListView(children: [
      // --------------------------- 배달 주문 가능 ---------------------------
      SGContainer(
          padding: EdgeInsets.all(SGSpacing.p4),
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line3,
          boxShadow: SGBoxShadow.large,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body("배달 주문 가능", size: FontSize.normal, weight: FontWeight.w500),
              SGSwitch(
                  value: state.deliveryStatus == 1,
                  onChanged: (value) {
                    if (state.deliveryStatus == 1) {
                      showFailDialogWithImageBoth(provider, 0, "배달 주문을 비활성화하시겠습니까?", "비활성화시 신규 배달 주문을 받을 수 없습니다.");
                    } else {
                      provider.updateDeliveryStatus(1);
                    }
                  })
            ],
          )),

      SizedBox(height: SGSpacing.p3),

      // --------------------------- 포장 주문 가능 ---------------------------
      SGContainer(
          padding: EdgeInsets.all(SGSpacing.p4),
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          color: SGColors.white,
          borderColor: SGColors.line3,
          boxShadow: SGBoxShadow.large,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SGTypography.body("포장 주문 가능", size: FontSize.normal, weight: FontWeight.w500),
              SGSwitch(
                  value: state.takeOutStatus == 1,
                  onChanged: (value) {
                    if (state.takeOutStatus == 1) {
                      showFailDialogWithImageBoth(provider, 1, "포장 주문을 비활성화하시겠습니까?", "비활성화시 신규 포장 주문을 받을 수 없습니다.");
                    } else {
                      provider.updatePickupStatus(1);
                    }
                  })
            ],
          )),

      SizedBox(height: SGSpacing.p3),

      // --------------------------- 영업시간 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("영업시간", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
            child: const Icon(Icons.edit, size: FontSize.small),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OperationTimeScreen(
                    operationTimeDetailDTOList: state.operationTimeDetailDTOList,
                    regularHolidays: regularHolidays,
                    onSaveFunction: (operationTimeDetails) {
                      // print("onSaveFunction $operationTimeDetails");
                      provider.updateOperationTime(operationTimeDetails);
                    }),
              ));
            },
          ),
        ]),
        SizedBox(height: SGSpacing.p5),
        ...groupedOperationTimeDetailDTOList.asMap().entries.map((entry) {
          int index = entry.key;
          bool isLastIndex = index == groupedOperationTimeDetailDTOList.length - 1;
          List<OperationTimeDetailModel> operationTimeDetailDTOList = entry.value;
          // print("operationTimeDetailDTO $operationTimeDetailDTOList");
          var day = operationTimeDetailDTOList.length == 1 ? "${operationTimeDetailDTOList.first.day}요일" : "${operationTimeDetailDTOList.first.day}요일~${operationTimeDetailDTOList.last.day}요일";
          var time = operationTimeDetailDTOList.first.is24OperationHour()
              ? "24시간"
              : "${convert24HourTimeToAmPmWithHourMinute(operationTimeDetailDTOList.first.startTime)}~${convert24HourTimeToAmPmWithHourMinute(operationTimeDetailDTOList.first.endTime)}";
          return Column(
            children: [
              DataTableRow(left: day, right: time),
              SizedBox(height: isLastIndex ? 0 : SGSpacing.p4),
            ],
          );
        }),
      ]),

      SizedBox(height: SGSpacing.p3),

      // --------------------------- 휴게시간 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴게시간", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
            child: const Icon(Icons.edit, size: FontSize.small),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BreakTimeScreen(
                    breakTimeDetailDTOList: fillMissingDays(state.breakTimeDetailDTOList),
                    regularHolidays: regularHolidays,
                    onSaveFunction: (breakTimeDetails) {
                      // print("onSaveFunction $breakTimeDetails");
                      provider.updateBreakTime(breakTimeDetails);
                    }),
              ));
            },
          ),
        ]),
        SizedBox(height: SGSpacing.p5),
        ...groupedBreakTimeDetailDTOList.asMap().entries.map((entry) {
          int index = entry.key;
          bool isLastIndex = index == groupedBreakTimeDetailDTOList.length - 1;
          List<OperationTimeDetailModel> breakTimeDetailDTOList = entry.value;
          // print("operationTimeDetailDTO breakTimeDetailDTOList");
          var day = breakTimeDetailDTOList.length == 1 ? "${breakTimeDetailDTOList.first.day}요일" : "${breakTimeDetailDTOList.first.day}요일~${breakTimeDetailDTOList.last.day}요일";
          var time = breakTimeDetailDTOList.first.isNoBreak()
              ? "-"
              : "${convert24HourTimeToAmPmWithHourMinute(breakTimeDetailDTOList.first.startTime)}~${convert24HourTimeToAmPmWithHourMinute(breakTimeDetailDTOList.first.endTime)}";
          return Column(
            children: [
              DataTableRow(left: day, right: time),
              SizedBox(height: isLastIndex ? 0 : SGSpacing.p4),
            ],
          );
        }),
      ]),

      SizedBox(height: SGSpacing.p3),

      // --------------------------- 휴무일 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴무일", size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HolidayScreen(
                      holidayStatus: state.holidayStatus,
                      regularHolidays: regularHolidays,
                      temporaryHolidays: temporaryHolidays,
                      onSaveFunction: (holidayStatus, regularHolidays, temporaryHolidays) {
                        provider.updateHolidayDetail(holidayStatus, regularHolidays, temporaryHolidays);

                        // // 영업시간 리스트
                        // var operationTimeDetails = state.operationTimeDetailDTOList.map((item) => item.copyWith()).toList();
                        //
                        // // 영업하지 않는 것으로 표기된 것들을 기본 영업시간으로 변경
                        // for (int i = 0; i < operationTimeDetails.length; i++) {
                        //   if (operationTimeDetails[i].startTime == "00:00" && operationTimeDetails[i].endTime == "00:00") {
                        //     operationTimeDetails[i] = operationTimeDetails[i].copyWith(
                        //       startTime: "09:00",
                        //       endTime: "21:00",
                        //     );
                        //   }
                        // }
                        //
                        // // 만약 정기 휴무일의 주기가 ‘매주’ 라면 해당 정기 휴무 요일에 대해 운영 시간을 제거함.
                        // for (var regularHoliday in regularHolidays) {
                        //   if (regularHoliday.isWeekCycleHoliday()) {
                        //     // day 값이 같은 항목 찾기
                        //     for (int i = 0; i < operationTimeDetails.length; i++) {
                        //       if (regularHoliday.day == operationTimeDetails[i].day) {
                        //         operationTimeDetails[i] = operationTimeDetails[i].copyWith(
                        //           startTime: "00:00",
                        //           endTime: "00:00",
                        //         );
                        //       } else {}
                        //     }
                        //   }
                        // }
                        //
                        // if (!state.operationTimeDetailDTOList.isEqualTo(operationTimeDetails)) {
                        //   provider.updateOperationTime(operationTimeDetails);
                        // }
                      }),
                ));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        DataTableRow(left: "공휴일", right: (state.holidayStatus == 1) ? "설날, 설날 다음날" : "-"),
        SizedBox(height: SGSpacing.p4),
        if (regularHolidayLabels.isEmpty) const DataTableRow(left: "정기 휴무", right: "-"),
        if (regularHolidayLabels.isNotEmpty)
          ...regularHolidayLabels.asMap().entries.map((entry) {
            int index = entry.key;
            bool isFirstIndex = index == 0;
            bool isLastIndex = index == regularHolidayLabels.length - 1;
            String regularHolidayLabel = entry.value;
            return Column(
              children: [
                DataTableRow(left: isFirstIndex ? "정기 휴무" : "", right: regularHolidayLabel),
                SizedBox(height: isLastIndex ? 0 : SGSpacing.p2),
              ],
            );
          }),
        SizedBox(height: SGSpacing.p4),
        if (temporaryHolidays.isEmpty) const DataTableRow(left: "임시 휴무", right: "-"),
        if (temporaryHolidays.isNotEmpty)
          ...temporaryHolidays.asMap().entries.map((entry) {
            int index = entry.key;
            bool isFirstIndex = index == 0;
            bool isLastIndex = index == temporaryHolidays.length - 1;
            OperationTimeDetailModel temporaryHoliday = entry.value;
            return Column(
              children: [
                DataTableRow(left: isFirstIndex ? "임시 휴무" : "", right: "${temporaryHoliday.startDate}~${temporaryHoliday.endDate}"),
                SizedBox(height: isLastIndex ? 0 : SGSpacing.p2),
              ],
            );
          }),
      ]),

      SizedBox(height: SGSpacing.p3),
    ]);
  }
}

/// 주어진 OperationTimeDetailModel 리스트를 startTime과 endTime 값에 따라 그룹화.
List<List<OperationTimeDetailModel>> groupByStartAndEndTime(List<OperationTimeDetailModel> data, List<OperationTimeDetailModel> regularHolidays) {
  List<List<OperationTimeDetailModel>> result = [];
  List<OperationTimeDetailModel> currentGroup = [];

  for (var i = 0; i < data.length; i++) {
    var isHoliday = regularHolidays.any((regularHoliday) => (regularHoliday.day == data[i].day) && regularHoliday.isWeekCycleHoliday());
    if (!isHoliday && (currentGroup.isEmpty || (data[i].startTime == currentGroup.last.startTime && data[i].endTime == currentGroup.last.endTime))) {
      currentGroup.add(data[i]);
    } else {
      if (currentGroup.isNotEmpty) {
        result.add(currentGroup);
      }
      if (isHoliday) {
        currentGroup = [];
      } else {
        currentGroup = [data[i]];
      }
    }
  }

  if (currentGroup.isNotEmpty) {
    result.add(currentGroup);
  }

  return result;
}

/// 주어진 요일별 영업시간 데이터에서 누락된 요일을 채워주는 함수.
List<OperationTimeDetailModel> fillMissingDays(List<OperationTimeDetailModel> data) {
  const List<String> daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  // 입력 데이터를 Map으로 변환 (요일을 키로 사용)
  final existingData = {for (var model in data) model.day: model};

  // 모든 요일을 포함하도록 데이터 생성
  final completeData = daysOfWeek.map((day) {
    return existingData[day] ?? OperationTimeDetailModel(day: day, startTime: "00:00", endTime: "00:00");
  }).toList();

  return completeData;
}

/// 정기 휴무일 표기용 레이블 생성 함수
List<String> groupRegularHolidaysByCycle(List<OperationTimeDetailModel> regularHolidays) {
  // 그룹화 기준: cycle, day
  Map<int, List<String>> groupedHolidays = {};

  for (var holiday in regularHolidays) {
    if (!groupedHolidays.containsKey(holiday.cycle)) {
      groupedHolidays[holiday.cycle] = [];
    }
    groupedHolidays[holiday.cycle]!.add(holiday.day);
  }

  List<String> results = [];
  groupedHolidays.forEach((cycle, days) {
    days.sort(); // 요일 정렬
    String cycleText = cycle == 0 ? "매주" : "$cycle째 주";
    results.add("$cycleText ${days.join(', ')}요일 휴무");
  });

  return results;
}
