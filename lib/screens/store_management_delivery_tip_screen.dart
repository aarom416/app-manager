import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/formatter.dart';

class StoreManagementDeliveryTipScreen extends StatelessWidget {
  List<(String, String)> baseDeliveryTip = [('주문 금액', '배달팁'), ('3,000원 이상', '4,000원')];

  List<(String, String)> additionalDeliveryTip = [
    ('26,000원 ~ 39,999원', '4,000원'),
    ('40,000원 ~ 49,999원', '3,000원'),
    ('50,000원 이상', '0원'),
  ];

  StoreManagementDeliveryTipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            MultipleInformationBox(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SGTypography.body("배달 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(width: SGSpacing.p2),
                    InkWell(onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => _EditDeliveryExpectedTimeScreen()));
                        },child: const Icon(Icons.edit, size: FontSize.small)),
                  ],
                ),
                SGTypography.body("15 ~ 20분", color: SGColors.gray4, size: FontSize.normal)
              ])
            ]),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SGTypography.body("픽업 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                SizedBox(width: SGSpacing.p2),
                InkWell(onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => _EditPickUpExpectedTimeScreen()));
                },child: const Icon(Icons.edit, size: FontSize.small)),
               ],
              ),
            SGTypography.body("15 ~ 20분", color: SGColors.gray4, size: FontSize.normal)
                ])
            ]),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p4),
                color: SGColors.white,
                borderColor: SGColors.line2,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const _EditDeliveryTipScreen()));
                    },
                    child: Row(children: [
                      SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(width: SGSpacing.p2),
                      Icon(Icons.edit, size: FontSize.small),
                    ]),
                  ),
                  SizedBox(height: SGSpacing.p5),
                  SGTypography.body("최소 주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
                  SizedBox(height: SGSpacing.p5 / 2),
                  Table(
                      border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)),
                      children: [
                        ...baseDeliveryTip.map((tip) => TableRow(children: [
                              Center(
                                  child: SGContainer(
                                      padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                      child: SGTypography.body(tip.$1, color: SGColors.black, weight: FontWeight.w700))),
                              Center(
                                  child: SGContainer(
                                      padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                      child: SGTypography.body(tip.$2, color: SGColors.gray5, weight: FontWeight.w500))),
                            ])),
                      ]),
                  SizedBox(height: SGSpacing.p4),
                  SGTypography.body("배달팁 추가", color: SGColors.gray4, weight: FontWeight.w600),
                  SizedBox(height: SGSpacing.p5 / 2),
                  Table(
                      border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)),
                      children: [
                        ...additionalDeliveryTip.map((tip) => TableRow(children: [
                              Center(
                                  child: SGContainer(
                                      padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                      child: SGTypography.body(tip.$1, color: SGColors.black, weight: FontWeight.w700))),
                              Center(
                                  child: SGContainer(
                                      padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                      child: SGTypography.body(tip.$2, color: SGColors.gray5, weight: FontWeight.w500))),
                            ])),
                      ]),
                ])),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SGTypography.body("배달 지역", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                SGTypography.body("현재는 역삼동에서만 배달 가능해요.", color: SGColors.gray4, size: FontSize.normal)
              ])
            ])
          ],
        ),
      ),
    );
  }
}

class _EditDeliveryExpectedTimeScreen extends StatefulWidget {
  _EditDeliveryExpectedTimeScreen({super.key});

  @override
  State<_EditDeliveryExpectedTimeScreen> createState() => _EditDeliveryExpectedTimeScreenState();

}

class _EditDeliveryExpectedTimeScreenState extends State<_EditDeliveryExpectedTimeScreen> {

  List<SelectionOption<String>> minuteOptions = [
    SelectionOption(label: "40분", value: "40분"),
    SelectionOption(label: "50분", value: "50분"),
    SelectionOption(label: "60분", value: "60분"),
    SelectionOption(label: "70분", value: "70분"),
    SelectionOption(label: "80분", value: "80분"),
  ];

  String minDeliveryTime = "40분";
  String maxDeliveryTime = "50분";

  bool minDeliveryTimeStatus = false;
  bool maxDeliveryTimeStatus = false;

  List<SelectionOption<String>> getFilteredMaxOptions() {
    int minIndex = minuteOptions.indexWhere((option) => option.value == minDeliveryTime);
    if (minDeliveryTime == "80분") {
      return minuteOptions.sublist(minuteOptions.length-1);
    }
    if (minIndex != -1 && minIndex + 1 < minuteOptions.length) {
      return minuteOptions.sublist(minIndex + 1);
    }
    return [];
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "배달 예상 시간 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: !minDeliveryTimeStatus || !maxDeliveryTimeStatus,
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              label: "변경하기")),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: SGColors.line3)
                        ),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("10분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: SGColors.line3)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("15분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
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
                          showSelectionBottomSheet<String>(
                              context: context,
                              title: "최소 배달 예상 시간",
                              options: minuteOptions,
                              onSelect: (value) {
                                setState(() {
                                  minDeliveryTime = value;
                                  maxDeliveryTime = getFilteredMaxOptions().first.value;
                                  minDeliveryTimeStatus = true;
                                });
                              },
                              selected: minDeliveryTime);
                          getFilteredMaxOptions();
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                SGTypography.body(minDeliveryTime,
                                    color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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
                          minDeliveryTime == "80분" && maxDeliveryTime == "80분" ?
                          SGTypography.body("15분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600) :
                          showSelectionBottomSheet<String>(
                              context: context,
                              title: "최대 배달 예상 시간",
                              options: getFilteredMaxOptions(),
                              onSelect: (minute) {
                                setState(() {
                                  maxDeliveryTime = minute;
                                  maxDeliveryTimeStatus = true;
                                });
                              },
                              selected: maxDeliveryTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                SGTypography.body(maxDeliveryTime,
                                    color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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

class _EditPickUpExpectedTimeScreen extends StatefulWidget {
  _EditPickUpExpectedTimeScreen({super.key});

  @override
  State<_EditPickUpExpectedTimeScreen> createState() => _EditPickUpExpectedTimeScreenState();

}

class _EditPickUpExpectedTimeScreenState extends State<_EditPickUpExpectedTimeScreen> {

  List<SelectionOption<String>> minuteOptions = [
    SelectionOption(label: "10분", value: "10분"),
    SelectionOption(label: "15분", value: "15분"),
    SelectionOption(label: "20분", value: "20분"),
    SelectionOption(label: "25분", value: "25분"),
    SelectionOption(label: "30분", value: "30분"),
    SelectionOption(label: "35분", value: "35분"),
    SelectionOption(label: "40분", value: "40분"),
  ];

  String minPickUpTime = "10분";
  String maxPickUpTime = "40분";

  bool minPickUpTimeStatus = false;
  bool maxPickUpTimeStatus = false;

  List<SelectionOption<String>> getFilteredMaxOptions() {
    int minIndex = minuteOptions.indexWhere((option) => option.value == minPickUpTime);
    if (minPickUpTime == "40분") {
      return minuteOptions.sublist(minuteOptions.length-1);
    }
    if (minIndex != -1 && minIndex + 1 < minuteOptions.length) {
      return minuteOptions.sublist(minIndex + 1);
    }
    return [];
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "픽업 예상 시간 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: !minPickUpTimeStatus || !maxPickUpTimeStatus,
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              label: "변경하기")),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: SGColors.line3)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("10분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
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
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: SGColors.line3)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: SGSpacing.p2),
                              SGTypography.body("15분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600),
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
                          showSelectionBottomSheet<String>(
                              context: context,
                              title: "최소 배달 예상 시간",
                              options: minuteOptions,
                              onSelect: (value) {
                                setState(() {
                                  minPickUpTime = value;
                                  maxPickUpTime = getFilteredMaxOptions().first.value;
                                  minPickUpTimeStatus = true;
                                });
                              },
                              selected: minPickUpTime);
                          getFilteredMaxOptions();
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                SGTypography.body(minPickUpTime,
                                    color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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
                          minPickUpTime == "40분" && maxPickUpTime == "40분" ?
                          SGTypography.body("15분", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w600) :
                          showSelectionBottomSheet<String>(
                              context: context,
                              title: "최대 배달 예상 시간",
                              options: getFilteredMaxOptions(),
                              onSelect: (minute) {
                                setState(() {
                                  maxPickUpTime = minute;
                                  maxPickUpTimeStatus = true;
                                });
                              },
                              selected: maxPickUpTime);
                        },
                        child: SGTextFieldWrapper(
                            child: SGContainer(
                              padding: EdgeInsets.symmetric(horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                SGTypography.body(maxPickUpTime,
                                    color: SGColors.black, size: FontSize.small, weight: FontWeight.w500),
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

class _EditDeliveryTipScreen extends StatefulWidget {
  const _EditDeliveryTipScreen({
    super.key,
  });

  @override
  State<_EditDeliveryTipScreen> createState() => _EditDeliveryTipScreenState();
}

class AdditionalDeliveryTip {
  final int id;
  final int minimumPrice;
  final int maximumPrice;
  final int tip;

  AdditionalDeliveryTip({required this.id, required this.minimumPrice, required this.maximumPrice, required this.tip});

  AdditionalDeliveryTip copyWith({int? minimumPrice, int? maximumPrice, int? tip}) {
    return AdditionalDeliveryTip(
      id: id,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
      tip: tip ?? this.tip,
    );
  }
}

class _EditDeliveryTipScreenState extends State<_EditDeliveryTipScreen> {
  int defaulDelieryTip = 4000;
  int minimumPrice = 16000;

  int minOrderPrice = 0;
  int maxOrderPrice = 12000;
  int orderDeliveryTip = 3000;

  late TextEditingController minimumPriceController;
  late TextEditingController defaulDelieryTipController;

  late TextEditingController minOrderPriceController;
  late TextEditingController maxOrderPriceController;
  late TextEditingController orderDeliveryTipController;

  List<AdditionalDeliveryTip> additionalDeliveryTips = [];

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    minimumPriceController = TextEditingController(text: minimumPrice.toKoreanCurrency);
    defaulDelieryTipController = TextEditingController(text: defaulDelieryTip.toKoreanCurrency);

    minimumPriceController.addListener(_enableButton);
    defaulDelieryTipController.addListener(_enableButton);
  }

  @override
  void dispose() {
    minimumPriceController.dispose();
    defaulDelieryTipController.dispose();
    super.dispose();
  }

  void _enableButton() {
    setState(() {
      isButtonEnabled = minimumPriceController.text != minimumPrice.toKoreanCurrency ||
          defaulDelieryTipController.text != defaulDelieryTip.toKoreanCurrency;
    });
  }

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
          if (subTitle.isEmpty) ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p6),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
              },
              child: SGContainer(
                color: SGColors.primary,
                width: double.infinity,
                borderColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                    child: SGTypography.body("확인",
                        color: SGColors.white,
                        weight: FontWeight.w700,
                        size: FontSize.normal)),
              ),
            )
          ] else ...[
            Center(
                child: SGTypography.body(mainTitle,
                    size: FontSize.medium,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p4),
            Center(
                child: SGTypography.body(subTitle,
                    color: SGColors.gray4,
                    size: FontSize.small,
                    weight: FontWeight.w700,
                    lineHeight: 1.25,
                    align: TextAlign.center)),
            SizedBox(height: SGSpacing.p6),
            GestureDetector(
              onTap: () {
                Navigator.pop(ctx);
              },
              child: SGContainer(
                color: SGColors.primary,
                width: double.infinity,
                borderColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Center(
                    child: SGTypography.body("확인",
                        color: SGColors.white,
                        weight: FontWeight.w700,
                        size: FontSize.normal)),
              ),
            )
          ]
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "배달팁 수정"),
      floatingActionButton: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
          child: SGActionButton(
              disabled: !isButtonEnabled,
              onPressed: () {
                showFailDialogWithImage(mainTitle: "배달팁 등록 실패", subTitle: "배달팁은 5,000원 이하만 설정 가능합니다.");
                FocusScope.of(context).unfocus();
              },
              label: "변경하기")),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              SGTypography.body("최소 주문 금액 설정", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p4),
              Row(children: [
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minimumPriceController,
                          style:
                              TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            comparableNumericInputFormatter(1000000000)
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (value) {
                            value = value.replaceAll(",", "");
                            setState(() {
                              minimumPrice = int.parse(value);
                            });
                          },
                        ),
                      ),
                      SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원 이상",
                              color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                    ],
                  )),
                ),
                SizedBox(width: SGSpacing.p2),
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: defaulDelieryTipController,
                          style:
                              TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            comparableNumericInputFormatter(1000000000)
                          ],
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border:
                                const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          ),
                          onChanged: (value) {
                            setState(() {
                              defaulDelieryTip = int.parse(value.replaceAll(",", ""));
                            });
                          },
                        ),
                      ),
                      SGContainer(
                          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원",
                              color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                    ],
                  )),
                ),
              ])
            ]),
            SizedBox(height: SGSpacing.p5),
            SGTypography.body("배달팁 추가", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            _AdditionalDeliveryTipForm(
                key: ValueKey([0, ...additionalDeliveryTips.map((tip) => tip.id)].reduce((a, b) => a ^ b)),
                additionalDeliveryTips: additionalDeliveryTips,
                minimumPrice: minimumPrice,
                onAdditionalDeliveryTipsChanged: (tips) {
                  setState(() {
                    additionalDeliveryTips = tips;
                    isButtonEnabled = true;
                  });
                }),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SGTypography.body("*", color: SGColors.gray3, lineHeight: 1.25),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body("30,000원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는  동일한 배달팁이 적용돼요",
                  color: SGColors.gray3, lineHeight: 1.25)
            ]),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
}

class _AdditionalDeliveryTipForm extends StatefulWidget {
  final List<AdditionalDeliveryTip> additionalDeliveryTips;
  final int minimumPrice;
  final Function(List<AdditionalDeliveryTip>) onAdditionalDeliveryTipsChanged;

  _AdditionalDeliveryTipForm(
      {super.key,
      required this.minimumPrice,
      required this.additionalDeliveryTips,
      required this.onAdditionalDeliveryTipsChanged});

  @override
  State<_AdditionalDeliveryTipForm> createState() => _AdditionalDeliveryTipFormState();
}

class _AdditionalDeliveryTipFormState extends State<_AdditionalDeliveryTipForm> {
  bool isEditing = false;

  late List<TextEditingController> minimumPriceControllers;
  late List<TextEditingController> maximumPriceControllers;
  late List<TextEditingController> tipControllers;

  late List<AdditionalDeliveryTip> additionalDeliveryTips;

  @override
  void initState() {
    super.initState();
    minimumPriceControllers = widget.additionalDeliveryTips
        .map((tip) => TextEditingController(text: tip.minimumPrice.toKoreanCurrency))
        .toList();
    maximumPriceControllers = widget.additionalDeliveryTips
        .map((tip) => TextEditingController(text: tip.maximumPrice.toKoreanCurrency))
        .toList();
    tipControllers =
        widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.tip.toKoreanCurrency)).toList();
    additionalDeliveryTips = widget.additionalDeliveryTips;
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      ...additionalDeliveryTips.mapIndexed((index, tip) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.body("주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: minimumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(minimumPrice: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원 이상",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
              SizedBox(width: SGSpacing.p2),
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: maximumPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray3),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          setState(() {
                            additionalDeliveryTips[index] =
                                tip.copyWith(maximumPrice: int.parse(value.replaceAll(",", "")));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원 미만",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
              SizedBox(width: SGSpacing.p2),
              SGContainer(
                  width: SGSpacing.p5,
                  height: SGSpacing.p5,
                  borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                  color: SGColors.warningRed,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          additionalDeliveryTips = [
                            ...additionalDeliveryTips.sublist(0, index),
                            ...additionalDeliveryTips.sublist(index + 1)
                          ];
                          minimumPriceControllers = [
                            ...minimumPriceControllers.sublist(0, index),
                            ...minimumPriceControllers.sublist(index + 1)
                          ];
                          maximumPriceControllers = [
                            ...maximumPriceControllers.sublist(0, index),
                            ...maximumPriceControllers.sublist(index + 1)
                          ];
                          tipControllers = [
                            ...tipControllers.sublist(0, index),
                            ...tipControllers.sublist(index + 1)
                          ];
                        });
                      },
                      child: Center(
                        child: Image.asset('assets/images/minus-white.png', width: 16, height: 16),
                      ))),
            ]),
            SizedBox(height: SGSpacing.p4),
            SGTypography.body("배달팁", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: isEditing,
                        controller: tipControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          comparableNumericInputFormatter(1000000000)
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border:
                              const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (value) {
                          value = value.replaceAll(",", "");
                          setState(() {
                            additionalDeliveryTips[index] = tip.copyWith(tip: int.parse(value));
                          });
                        },
                      ),
                    ),
                    SGContainer(
                        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                        child: SGTypography.body("원",
                            color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                  ],
                )),
              ),
            ]),
            SizedBox(height: SGSpacing.p5),
          ])),
      if (!isEditing) ...[
        GestureDetector(
            onTap: () {

            },
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {

                        isEditing = true;

                        if (isEditing) {
                          final newAdditionalDeliveryTip = AdditionalDeliveryTip(
                              id: DateTime.now().millisecondsSinceEpoch,
                              minimumPrice: widget.minimumPrice,
                              maximumPrice: 0,
                              tip: 3000);
                          additionalDeliveryTips = [...additionalDeliveryTips, newAdditionalDeliveryTip];

                          minimumPriceControllers = [
                            ...minimumPriceControllers,
                            TextEditingController(text: widget.minimumPrice.toKoreanCurrency)
                          ];

                          maximumPriceControllers = [
                            ...maximumPriceControllers,
                            TextEditingController(text: newAdditionalDeliveryTip.maximumPrice.toKoreanCurrency)
                          ];

                          tipControllers = [
                            ...tipControllers,
                            TextEditingController(text: newAdditionalDeliveryTip.tip.toKoreanCurrency)
                          ];
                          widget.onAdditionalDeliveryTipsChanged(additionalDeliveryTips);
                        }
                      });
                    },
                    child:Image.asset("assets/images/accumulative.png", width: 24, height: 24)),
                SizedBox(width: SGSpacing.p1),
                SGTypography.body("배달팁 추가하기", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
              ],
            ),
        )
      ],
    ]);
  }
}
