import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../../../../core/components/multiple_information_box.dart';

class TakeOutTimeScreen extends StatefulWidget {
  final int minTakeOutTime;
  final int maxTakeOutTime;
  final Function(int, int) onSaveFunction;

  const TakeOutTimeScreen({super.key, required this.minTakeOutTime, required this.maxTakeOutTime, required this.onSaveFunction});

  @override
  State<TakeOutTimeScreen> createState() => _TakeOutTimeScreenState();
}

class _TakeOutTimeScreenState extends State<TakeOutTimeScreen> {
  late int minTakeOutTime;
  late int maxTakeOutTime;

  List<SelectionOption<int>> minuteOptions = [
    SelectionOption(label: "10분", value: 10),
    SelectionOption(label: "15분", value: 15),
    SelectionOption(label: "20분", value: 20),
    SelectionOption(label: "25분", value: 25),
    SelectionOption(label: "30분", value: 30),
    SelectionOption(label: "35분", value: 35),
    SelectionOption(label: "40분", value: 40),
  ];

  List<SelectionOption<int>> getAvailableMaxOptions(int minTakeOutTime) {
    int minIndex = minuteOptions.indexWhere((option) => option.value == minTakeOutTime);
    return (minIndex != -1 && minIndex + 1 < minuteOptions.length) ? minuteOptions.sublist(minIndex + 1) : [];
  }

  @override
  void initState() {
    super.initState();
    minTakeOutTime = widget.minTakeOutTime;
    maxTakeOutTime = widget.maxTakeOutTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "픽업 예상 시간 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: minTakeOutTime == widget.minTakeOutTime && maxTakeOutTime == widget.maxTakeOutTime,
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onSaveFunction(minTakeOutTime, maxTakeOutTime);
                Navigator.pop(context);
              },
              label: "변경하기")),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("변경 전", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("최소", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p3),
                      Container(
                          height: 42,
                          width: SGSpacing.p32 + SGSpacing.p6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: SGColors.line3)),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("${widget.minTakeOutTime}분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    width: SGSpacing.p4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("최대", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p3),
                      Container(
                          height: 42,
                          width: SGSpacing.p32 + SGSpacing.p6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: SGColors.line3)),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("${widget.maxTakeOutTime}분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                            ],
                          )),
                    ],
                  )
                ],
              )
            ]),
            SizedBox(height: SGSpacing.p5),
            SGTypography.body("변경 후", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("최소", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p3),
                      GestureDetector(
                        onTap: () {
                          showSelectionBottomSheet<int>(
                              context: context,
                              title: "최소 픽업 예상 시간",
                              options: minuteOptions,
                              onSelect: (minTakeOutTime) {
                                setState(() {
                                  this.minTakeOutTime = minTakeOutTime;
                                  maxTakeOutTime = getAvailableMaxOptions(minTakeOutTime).first.value;
                                });
                              },
                              selected: minTakeOutTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            SGTypography.body(minTakeOutTime.toString(), color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
                            Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                          ]),
                        )),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: SGSpacing.p2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SGTypography.body("최대", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
                      SizedBox(height: SGSpacing.p3),
                      GestureDetector(
                        onTap: () {
                          minTakeOutTime == 80 && maxTakeOutTime == 80
                              ? SGTypography.body("$maxTakeOutTime분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600)
                              : showSelectionBottomSheet<int>(
                                  context: context,
                                  title: "최대 픽업 예상 시간",
                                  options: getAvailableMaxOptions(minTakeOutTime),
                                  onSelect: (maxTakeOutTime) {
                                    setState(() {
                                      this.maxTakeOutTime = maxTakeOutTime;
                                    });
                                  },
                                  selected: maxTakeOutTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            SGTypography.body(maxTakeOutTime.toString(), color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
                            Image.asset('assets/images/dropdown-arrow.png', width: 16, height: 16),
                          ]),
                        )),
                      ),
                    ],
                  ),
                ),
              ]),
            ]),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
}
