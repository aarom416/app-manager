import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/utils/formatter.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/provider.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/takeouttime/screen.dart';

import 'deliverytime/screen.dart';
import 'deliverytip/screen.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({super.key});

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(deliveryNotifierProvider.notifier).getDeliveryTakeoutInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DeliveryState state = ref.watch(deliveryNotifierProvider);

    final DeliveryNotifier provider = ref.read(deliveryNotifierProvider.notifier);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            // --------------------------- 배달 예상 시간 card ---------------------------
            MultipleInformationBox(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SGTypography.body("배달 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(width: SGSpacing.p2),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DeliveryTimeScreen(
                                    minDeliveryTime: state.minDeliveryTime,
                                    maxDeliveryTime: state.maxDeliveryTime,
                                    onSaveFunction: (minDeliveryTime, maxDeliveryTime) {
                                      print("onSaveFunction $minDeliveryTime $maxDeliveryTime");
                                      provider.updateDeliveryTime(minDeliveryTime, maxDeliveryTime);
                                    },
                                  )));
                        },
                        child: const Icon(Icons.edit, size: FontSize.small)),
                  ],
                ),
                SGTypography.body("${state.minDeliveryTime} ~ ${state.maxDeliveryTime}분", color: SGColors.gray4, size: FontSize.normal)
              ])
            ]),

            SizedBox(height: SGSpacing.p3),

            // --------------------------- 픽업 예상 시간 card ---------------------------
            MultipleInformationBox(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SGTypography.body("픽업 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                    SizedBox(width: SGSpacing.p2),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  TakeOutTimeScreen(
                                    minTakeOutTime: state.minTakeOutTime,
                                    maxTakeOutTime: state.maxTakeOutTime,
                                    onSaveFunction: (minTakeOutTime, maxTakeOutTime) {
                                      print("onSaveFunction $minTakeOutTime $maxTakeOutTime");
                                      provider.updatePickupTime(minTakeOutTime, maxTakeOutTime);
                                    },
                                  )));
                        },
                        child: const Icon(Icons.edit, size: FontSize.small)),
                  ],
                ),
                SGTypography.body("${state.minTakeOutTime} ~ ${state.maxTakeOutTime}분", color: SGColors.gray4, size: FontSize.normal)
              ])
            ]),

            SizedBox(height: SGSpacing.p3),

            // --------------------------- 배달팁 card ---------------------------
            SGContainer(
                padding: EdgeInsets.all(SGSpacing.p4),
                borderRadius: BorderRadius.circular(SGSpacing.p4),
                color: SGColors.white,
                borderColor: SGColors.line2,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      DeliveryTipScreen(
                        baseDeliveryTip: state.baseDeliveryTip,
                        baseDeliveryTipMax: state.baseDeliveryTipMax,
                        minimumOrderPrice: state.minimumOrderPrice,
                        storeDeliveryTipDTOList: state.storeDeliveryTipDTOList,
                        onSaveFunction: (baseDeliveryTip, minimumOrderPrice, storeDeliveryTipDTOList) {
                          print("onSaveFunction $baseDeliveryTip $minimumOrderPrice $storeDeliveryTipDTOList");
                        },
                      )));
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
                  Table(border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)), children: [
                    TableRow(children: [
                      Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("주문 금액", color: SGColors.black, weight: FontWeight.w700))),
                      Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("배달팁", color: SGColors.gray5, weight: FontWeight.w500))),
                    ]),
                    TableRow(children: [
                      Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("${state.minimumOrderPrice.toKoreanCurrency}원 이상", color: SGColors.black, weight: FontWeight.w700))),
                      Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("${state.baseDeliveryTip.toKoreanCurrency}원", color: SGColors.gray5, weight: FontWeight.w500))),
                    ])
                  ]),
                  SizedBox(height: SGSpacing.p4),
                  // if (state.storeDeliveryTipDTOList.isNotEmpty) ...[
                  SGTypography.body("배달팁 추가", color: SGColors.gray4, weight: FontWeight.w600),
                  SizedBox(height: SGSpacing.p5 / 2),
                  Table(border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)), children: [
                    ...state.storeDeliveryTipDTOList.map((deliveryTipModel) =>
                        TableRow(children: [
                          Center(
                              child: SGContainer(
                                  padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                  child: SGTypography.body("${deliveryTipModel.minPrice.toKoreanCurrency}원 ~ ${deliveryTipModel.maxPrice.toKoreanCurrency}원", color: SGColors.black, weight: FontWeight.w700))),
                          Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("${deliveryTipModel.deliveryTip.toKoreanCurrency}원", color: SGColors.gray5, weight: FontWeight.w500))),
                        ])),
                  ]),
                  // ],
                ])),

            SizedBox(height: SGSpacing.p3),

            // --------------------------- 배달 지역 card ---------------------------
            MultipleInformationBox(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [SGTypography.body("배달 지역", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600), SGTypography.body("현재는 ${state.deliveryAddress}에서만 배달 가능해요.", color: SGColors.gray4, size: FontSize.normal)])
            ])
          ],
        ),
      ),
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
      isButtonEnabled = minimumPriceController.text != minimumPrice.toKoreanCurrency || defaulDelieryTipController.text != defaulDelieryTip.toKoreanCurrency;
    });
  }

  void showFailDialogWithImage({
    required String mainTitle,
    required String subTitle,
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) =>
        [
          if (subTitle.isEmpty) ...[
            Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
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
                child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
              ),
            )
          ] else
            ...[
              Center(child: SGTypography.body(mainTitle, size: FontSize.medium, weight: FontWeight.w700, lineHeight: 1.25, align: TextAlign.center)),
              SizedBox(height: SGSpacing.p4),
              Center(child: SGTypography.body(subTitle, color: SGColors.gray4,
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
                  child: Center(child: SGTypography.body("확인", color: SGColors.white, weight: FontWeight.w700, size: FontSize.normal)),
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
          constraints: BoxConstraints(maxWidth: MediaQuery
              .of(context)
              .size
              .width - SGSpacing.p8, maxHeight: 58),
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
                              style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: SGColors.gray4),
                                contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                                border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              ),
                              onChanged: (value) {
                                value = value.replaceAll(",", "");
                                setState(() {
                                  minimumPrice = int.parse(value);
                                });
                              },
                            ),
                          ),
                          SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 이상", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                              style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: SGColors.gray4),
                                contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                                border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  defaulDelieryTip = int.parse(value.replaceAll(",", ""));
                                });
                              },
                            ),
                          ),
                          SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [SGTypography.body("*", color: SGColors.gray3, lineHeight: 1.25), SizedBox(width: SGSpacing.p1), SGTypography.body("30,000원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는  동일한 배달팁이 적용돼요", color: SGColors.gray3, lineHeight: 1.25)]),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
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

class _AdditionalDeliveryTipForm extends StatefulWidget {
  final List<AdditionalDeliveryTip> additionalDeliveryTips;
  final int minimumPrice;
  final Function(List<AdditionalDeliveryTip>) onAdditionalDeliveryTipsChanged;

  _AdditionalDeliveryTipForm({super.key, required this.minimumPrice, required this.additionalDeliveryTips, required this.onAdditionalDeliveryTipsChanged});

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
    minimumPriceControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.minimumPrice.toKoreanCurrency)).toList();
    maximumPriceControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.maximumPrice.toKoreanCurrency)).toList();
    tipControllers = widget.additionalDeliveryTips.map((tip) => TextEditingController(text: tip.tip.toKoreanCurrency)).toList();
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
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: SGColors.gray4),
                              contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              value = value.replaceAll(",", "");
                              setState(() {
                                additionalDeliveryTips[index] = tip.copyWith(minimumPrice: int.parse(value));
                              });
                            },
                          ),
                        ),
                        SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 이상", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: SGColors.gray3),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              setState(() {
                                additionalDeliveryTips[index] = tip.copyWith(maximumPrice: int.parse(value.replaceAll(",", "")));
                              });
                            },
                          ),
                        ),
                        SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원 미만", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
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
                          additionalDeliveryTips = [...additionalDeliveryTips.sublist(0, index), ...additionalDeliveryTips.sublist(index + 1)];
                          minimumPriceControllers = [...minimumPriceControllers.sublist(0, index), ...minimumPriceControllers.sublist(index + 1)];
                          maximumPriceControllers = [...maximumPriceControllers.sublist(0, index), ...maximumPriceControllers.sublist(index + 1)];
                          tipControllers = [...tipControllers.sublist(0, index), ...tipControllers.sublist(index + 1)];
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
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), comparableNumericInputFormatter(1000000000)],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: SGColors.gray4),
                              contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                              border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                            ),
                            onChanged: (value) {
                              value = value.replaceAll(",", "");
                              setState(() {
                                additionalDeliveryTips[index] = tip.copyWith(tip: int.parse(value));
                              });
                            },
                          ),
                        ),
                        SGContainer(padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4), child: SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500)),
                      ],
                    )),
              ),
            ]),
            SizedBox(height: SGSpacing.p5),
          ])),
      if (!isEditing) ...[
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isEditing = true;

                      if (isEditing) {
                        final newAdditionalDeliveryTip = AdditionalDeliveryTip(id: DateTime
                            .now()
                            .millisecondsSinceEpoch, minimumPrice: widget.minimumPrice, maximumPrice: 0, tip: 3000);
                        additionalDeliveryTips = [...additionalDeliveryTips, newAdditionalDeliveryTip];

                        minimumPriceControllers = [...minimumPriceControllers, TextEditingController(text: widget.minimumPrice.toKoreanCurrency)];

                        maximumPriceControllers = [...maximumPriceControllers, TextEditingController(text: newAdditionalDeliveryTip.maximumPrice.toKoreanCurrency)];

                        tipControllers = [...tipControllers, TextEditingController(text: newAdditionalDeliveryTip.tip.toKoreanCurrency)];
                        widget.onAdditionalDeliveryTipsChanged(additionalDeliveryTips);
                      }
                    });
                  },
                  child: Image.asset("assets/images/accumulative.png", width: 24, height: 24)),
              SizedBox(width: SGSpacing.p1),
              SGTypography.body("배달팁 추가하기", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
            ],
          ),
        )
      ],
    ]);
  }
}
