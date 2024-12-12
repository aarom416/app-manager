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

class DeliveryTimeScreen extends StatefulWidget {
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final Function(int, int) onSaveFunction;

  const DeliveryTimeScreen({super.key, required this.minDeliveryTime, required this.maxDeliveryTime, required this.onSaveFunction});

  @override
  State<DeliveryTimeScreen> createState() => _DeliveryTimeScreenState();
}

class _DeliveryTimeScreenState extends State<DeliveryTimeScreen> {
  late int minDeliveryTime;
  late int maxDeliveryTime;

  List<SelectionOption<int>> minuteOptions = [
    SelectionOption(label: "40분", value: 40),
    SelectionOption(label: "50분", value: 50),
    SelectionOption(label: "60분", value: 60),
    SelectionOption(label: "70분", value: 70),
    SelectionOption(label: "80분", value: 80),
  ];

  List<SelectionOption<int>> getAvailableMaxOptions(int minDeliveryTime) {
    int minIndex = minuteOptions.indexWhere((option) => option.value == minDeliveryTime);
    return (minIndex != -1 && minIndex + 1 < minuteOptions.length) ? minuteOptions.sublist(minIndex + 1) : [];
  }

  @override
  void initState() {
    super.initState();
    minDeliveryTime = widget.minDeliveryTime;
    maxDeliveryTime = widget.maxDeliveryTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "배달 예상 시간 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: minDeliveryTime == widget.minDeliveryTime && maxDeliveryTime == widget.maxDeliveryTime,
              onPressed: () {
                FocusScope.of(context).unfocus();
                widget.onSaveFunction(minDeliveryTime, maxDeliveryTime);
                Navigator.pop(context);
              },
              label: "변경하기")),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("변경 전", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(
              children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SGTypography.body(
                          "최소",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w600,
                        ),
                        SizedBox(height: SGSpacing.p3),
                        Container(
                          height: SGSpacing.p10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: SGColors.line3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body(
                                "${widget.minDeliveryTime}분",
                                color: SGColors.gray4,
                                size: FontSize.small,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: SGSpacing.p2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SGTypography.body(
                          "최대",
                          color: SGColors.gray4,
                          size: FontSize.small,
                          weight: FontWeight.w600,
                        ),
                        SizedBox(height: SGSpacing.p3),
                        Container(
                          height: SGSpacing.p10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: SGColors.line3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body(
                                "${widget.maxDeliveryTime}분",
                                color: SGColors.gray4,
                                size: FontSize.small,
                                weight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                              title: "최소 배달 예상 시간",
                              options: minuteOptions,
                              onSelect: (minDeliveryTime) {
                                setState(() {
                                  this.minDeliveryTime = minDeliveryTime;
                                  maxDeliveryTime = getAvailableMaxOptions(minDeliveryTime).first.value;
                                });
                              },
                              selected: minDeliveryTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    SGTypography.body(minDeliveryTime.toString(), color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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
                          minDeliveryTime == 80 && maxDeliveryTime == 80
                              ? SGTypography.body("$maxDeliveryTime분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600)
                              : showSelectionBottomSheet<int>(
                                  context: context,
                                  title: "최대 배달 예상 시간",
                                  options: getAvailableMaxOptions(minDeliveryTime),
                                  onSelect: (maxDeliveryTime) {
                                    setState(() {
                                      this.maxDeliveryTime = maxDeliveryTime;
                                    });
                                  },
                                  selected: maxDeliveryTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            SGTypography.body(maxDeliveryTime.toString(), color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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
