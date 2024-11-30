import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/store_management_holiday_management_screen.dart';

import '../../../../utils/time_utils.dart';
import 'breaktime/screen.dart';
import 'businesshours/screen.dart';
import 'model.dart';
import 'provider.dart';

class StoreOperationScreen extends ConsumerStatefulWidget {
  const StoreOperationScreen({super.key});

  @override
  ConsumerState<StoreOperationScreen> createState() =>
      _StoreOperationScreenState();
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
            padding: EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05)
                .copyWith(bottom: 0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SGContainer(
                    padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05)
                        .copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: SGSpacing.p2),
                        Image.asset("assets/images/warning.png",
                            width: SGSpacing.p12),
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

  void showFailDialogWithImageBoth(StoreOperationNotifier provider, int type,
      String mainTitle, String subTitle) {
    showSGDialogWithImageBoth(
        context: context,
        childrenBuilder: (context) => [
              Column(
                children: [
                  Center(
                      child: SGTypography.body(mainTitle,
                          size: FontSize.medium,
                          weight: FontWeight.w700,
                          lineHeight: 1.25,
                          align: TextAlign.center)),
                  SizedBox(height: SGSpacing.p2),
                  Center(
                      child: SGTypography.body(subTitle,
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w700,
                          lineHeight: 1.25,
                          align: TextAlign.center)),
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
                          child: SGTypography.body("취소",
                              size: FontSize.normal,
                              weight: FontWeight.w700,
                              color: SGColors.white),
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
                          child: SGTypography.body("확인",
                              size: FontSize.normal,
                              weight: FontWeight.w700,
                              color: SGColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]);
  }

  /// 주어진 OperationTimeDetailModel 리스트를 startTime과 endTime 값에 따라 그룹화.
  List<List<OperationTimeDetailModel>> groupByStartAndEndTime(
      List<OperationTimeDetailModel> data) {
    List<List<OperationTimeDetailModel>> result = [];
    List<OperationTimeDetailModel> currentGroup = [];

    for (var i = 0; i < data.length; i++) {
      if (currentGroup.isEmpty ||
          (data[i].startTime == currentGroup.last.startTime &&
              data[i].endTime == currentGroup.last.endTime)) {
        currentGroup.add(data[i]);
      } else {
        result.add(currentGroup);
        currentGroup = [data[i]];
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
    final existingData = {
      for (var model in data) model.day: model
    };

    // 모든 요일을 포함하도록 데이터 생성
    final completeData = daysOfWeek.map((day) {
      return existingData[day] ?? OperationTimeDetailModel(day: day, startTime: "00:00", endTime: "00:00");
    }).toList();

    return completeData;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeOperationNotifierProvider);

    final provider = ref.read(storeOperationNotifierProvider.notifier);

    var groupedOperationTimeDetails =
        groupByStartAndEndTime(state.operationTimeDetailDTOList);

    var groupedBreakTimeDetails =
    groupByStartAndEndTime(fillMissingDays(state.breakTimeDetailDTOList));


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
              SGTypography.body("배달 주문 가능",
                  size: FontSize.normal, weight: FontWeight.w500),
              SGSwitch(
                  value: state.deliveryStatus == 1,
                  onChanged: (value) {
                    setState(() {
                      if (state.deliveryStatus == 1) {
                        showFailDialogWithImageBoth(provider, 0,
                            "배달 주문을 비활성화하시겠습니까?", "비활성화시 신규 배달 주문을 받을 수 없습니다.");
                      } else {
                        provider.updateDeliveryStatus(1);
                      }
                    });
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
              SGTypography.body("포장 주문 가능",
                  size: FontSize.normal, weight: FontWeight.w500),
              SGSwitch(
                  value: state.takeOutStatus == 1,
                  onChanged: (value) {
                    setState(() {
                      if (state.takeOutStatus == 1) {
                        showFailDialogWithImageBoth(provider, 1,
                            "포장 주문을 비활성화하시겠습니까?", "비활성화시 신규 포장 주문을 받을 수 없습니다.");
                      } else {
                        provider.updatePickupStatus(1);
                      }
                    });
                  })
            ],
          )),

      SizedBox(height: SGSpacing.p3),

      // --------------------------- 영업시간 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("영업시간",
              size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
            child: const Icon(Icons.edit, size: FontSize.small),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StoreOperationTimesScreen(
                    operationTimeDetails: state.operationTimeDetailDTOList,
                    onSaveFunction: (operationTimeDetails) {
                      // print("onSaveFunction $operationTimeDetails");
                      provider.updateOperationTime(operationTimeDetails);
                      Navigator.of(context).pop();
                    }),
              ));
            },
          ),
        ]),
        SizedBox(height: SGSpacing.p5),
        ...groupedOperationTimeDetails.map((operationTimeDetails) {
          var day = operationTimeDetails.length == 1
              ? "${operationTimeDetails.first.day}요일"
              : "${operationTimeDetails.first.day}요일~${operationTimeDetails.last.day}요일";
          var time = operationTimeDetails.first.startTime == "00:00" &&
                  operationTimeDetails.first.endTime == "24:00"
              ? "24시간"
              : "${convert24HourTimeToAmPmWithHourMinute(operationTimeDetails.first.startTime)}~${convert24HourTimeToAmPmWithHourMinute(operationTimeDetails.first.endTime)}";

          return Column(
            children: [
              DataTableRow(
                left: day,
                right: time,
              ),
              SizedBox(height: SGSpacing.p4),
            ],
          );
        }),
      ]),

      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

      // --------------------------- 휴게시간 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴게시간",
              size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
            child: const Icon(Icons.edit, size: FontSize.small),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StoreBreakTimesScreen(
                    breakTimeDetails: fillMissingDays(state.breakTimeDetailDTOList),
                    onSaveFunction: (breakTimeDetails) {
                      // print("onSaveFunction $breakTimeDetails");
                      provider.updateBreakTime(breakTimeDetails);
                      Navigator.of(context).pop();
                    }),
              ));
            },
          ),
        ]),
        SizedBox(height: SGSpacing.p5),
        ...groupedBreakTimeDetails.map((operationTimeDetails) {
          var day = operationTimeDetails.length == 1
              ? "${operationTimeDetails.first.day}요일"
              : "${operationTimeDetails.first.day}요일~${operationTimeDetails.last.day}요일";
          var time = operationTimeDetails.first.startTime == "00:00" &&
              operationTimeDetails.first.endTime == "00:00"
              ? "-"
              : "${convert24HourTimeToAmPmWithHourMinute(operationTimeDetails.first.startTime)}~${convert24HourTimeToAmPmWithHourMinute(operationTimeDetails.first.endTime)}";

          return Column(
            children: [
              DataTableRow(
                left: day,
                right: time,
              ),
              SizedBox(height: SGSpacing.p4),
            ],
          );
        }),
      ]),

      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),

      // --------------------------- 휴무일 ---------------------------
      MultipleInformationBox(children: [
        Row(children: [
          SGTypography.body("휴무일",
              size: FontSize.normal, weight: FontWeight.w700),
          SizedBox(width: SGSpacing.p1),
          GestureDetector(
              child: const Icon(Icons.edit, size: FontSize.small),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        const StoreManagementHolidayManagementScreen()));
              }),
        ]),
        SizedBox(height: SGSpacing.p5),
        DataTableRow(left: "정기 휴무", right: "2,4 째 주 일요일 휴무"),
        SizedBox(height: SGSpacing.p4),
        DataTableRow(left: "공휴일", right: "설날, 설날 다음날"),
      ]),

      SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
    ]);
  }
}

class NonBusinessHourModel {
  final int id;
  final String weekday;
  final String startHour;
  final String startMinute;
  final String endHour;
  final String endMinute;
  final bool isAvailable;

  NonBusinessHourModel({
    required this.id,
    required this.weekday,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isAvailable,
  });

  NonBusinessHourModel copyWith({
    int? id,
    String? weekday,
    String? startHour,
    String? startMinute,
    String? endHour,
    String? endMinute,
    bool? isAvailable,
  }) {
    return NonBusinessHourModel(
      id: id ?? this.id,
      weekday: weekday ?? this.weekday,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

class _NonBusinessHourConfigurationScreen extends StatefulWidget {
  const _NonBusinessHourConfigurationScreen({super.key});

  @override
  State<_NonBusinessHourConfigurationScreen> createState() =>
      __NonBusinessHourConfigurationScreenState();
}

class __NonBusinessHourConfigurationScreenState
    extends State<_NonBusinessHourConfigurationScreen> {
  List<NonBusinessHourModel> nonBusinessHours = [
    NonBusinessHourModel(
        id: 1,
        weekday: "월요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 2,
        weekday: "화요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 3,
        weekday: "수요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 4,
        weekday: "목요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 5,
        weekday: "금요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 6,
        weekday: "토요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
    NonBusinessHourModel(
        id: 7,
        weekday: "일요일",
        startHour: "오전 10시",
        startMinute: "00분",
        endHour: "오후 10시",
        endMinute: "00분",
        isAvailable: true),
  ];

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
              ...nonBusinessHours
                  .map((nonBusinessHour) {
                    return [
                      __NonBusinessHourConfigurationCard(
                        nonBusinessHour: nonBusinessHour,
                        onEdit: (nonBusinessHour) {
                          setState(() {
                            nonBusinessHours = nonBusinessHours
                                .map((nbh) => nbh.id == nonBusinessHour.id
                                    ? nonBusinessHour
                                    : nbh)
                                .toList();
                          });
                        },
                      ),
                      SizedBox(height: SGSpacing.p2 + SGSpacing.p05)
                    ];
                  })
                  .toList()
                  .flattened,
              SizedBox(height: SGSpacing.p15),
              SGActionButton(onPressed: () {}, label: "변경하기", disabled: true)
            ],
          ),
        ));
  }
}

class __NonBusinessHourConfigurationCard extends StatelessWidget {
  final NonBusinessHourModel nonBusinessHour;
  final Function(NonBusinessHourModel) onEdit;

  __NonBusinessHourConfigurationCard({
    super.key,
    required this.nonBusinessHour,
    required this.onEdit,
  });

  List<SelectionOption<String>> hourOptions = [
    SelectionOption(label: "오전 0시", value: "오전 0시"),
    SelectionOption(label: "오전 1시", value: "오전 1시"),
    SelectionOption(label: "오전 2시", value: "오전 2시"),
    SelectionOption(label: "오전 3시", value: "오전 3시"),
    SelectionOption(label: "오전 4시", value: "오전 4시"),
    SelectionOption(label: "오전 5시", value: "오전 5시"),
    SelectionOption(label: "오전 6시", value: "오전 6시"),
    SelectionOption(label: "오전 7시", value: "오전 7시"),
    SelectionOption(label: "오전 8시", value: "오전 8시"),
    SelectionOption(label: "오전 9시", value: "오전 9시"),
    SelectionOption(label: "오전 10시", value: "오전 10시"),
    SelectionOption(label: "오전 11시", value: "오전 11시"),
    SelectionOption(label: "오후 12시", value: "오후 12시"),
    SelectionOption(label: "오후 1시", value: "오후 1시"),
    SelectionOption(label: "오후 2시", value: "오후 2시"),
    SelectionOption(label: "오후 3시", value: "오후 3시"),
    SelectionOption(label: "오후 4시", value: "오후 4시"),
    SelectionOption(label: "오후 5시", value: "오후 5시"),
    SelectionOption(label: "오후 6시", value: "오후 6시"),
    SelectionOption(label: "오후 7시", value: "오후 7시"),
    SelectionOption(label: "오후 8시", value: "오후 8시"),
    SelectionOption(label: "오후 9시", value: "오후 9시"),
    SelectionOption(label: "오후 10시", value: "오후 10시"),
    SelectionOption(label: "오후 11시", value: "오후 11시"),
  ];

  List<SelectionOption<String>> minuteOptions = [
    SelectionOption(label: "00분", value: "00분"),
    SelectionOption(label: "30분", value: "30분"),
  ];

  @override
  Widget build(BuildContext context) {
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
              SGTypography.body(nonBusinessHour.weekday,
                  size: FontSize.normal, weight: FontWeight.w500),
              Spacer(),
              SGSwitch(
                value: nonBusinessHour.isAvailable,
                onChanged: (value) {
                  onEdit(nonBusinessHour.copyWith(isAvailable: value));
                },
              ),
            ],
          ),
          if (nonBusinessHour.isAvailable) ...[
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
                        title: "시작 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(nonBusinessHour.copyWith(startHour: value));
                        },
                        selected: nonBusinessHour.startHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(nonBusinessHour.startHour,
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
                        title: "시작 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(nonBusinessHour.copyWith(startMinute: minute));
                        },
                        selected: nonBusinessHour.startMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(nonBusinessHour.startMinute,
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
                        title: "종료 시간을 설정해주세요.",
                        options: hourOptions,
                        onSelect: (value) {
                          onEdit(nonBusinessHour.copyWith(endHour: value));
                        },
                        selected: nonBusinessHour.endHour);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(nonBusinessHour.endHour,
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
                        title: "종료 시간을 설정해주세요.",
                        options: minuteOptions,
                        onSelect: (minute) {
                          onEdit(nonBusinessHour.copyWith(endMinute: minute));
                        },
                        selected: nonBusinessHour.endMinute);
                  },
                  child: SGTextFieldWrapper(
                      child: SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(nonBusinessHour.endMinute,
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
