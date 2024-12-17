import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/snackbar.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../core/components/dialog.dart';
import '../../../../../core/components/multiple_information_box.dart';
import '../../../../../core/components/numeric_textfield.dart';
import '../model.dart';
import 'delivery_tip_card.dart';

class DeliveryTipScreen extends StatefulWidget {
  final int baseDeliveryTip;
  final int deliveryTipMax;
  final int minimumOrderPrice;
  final List<DeliveryTipModel> storeDeliveryTipDTOList;
  final String deliveryTipInfo;
  final Function(int, int, List<DeliveryTipModel>) onSaveFunction;

  const DeliveryTipScreen(
      {super.key,
      required this.baseDeliveryTip,
      required this.deliveryTipMax,
      required this.minimumOrderPrice,
      required this.storeDeliveryTipDTOList,
      required this.deliveryTipInfo,
      required this.onSaveFunction});

  @override
  State<DeliveryTipScreen> createState() => _DeliveryTipScreenState();
}

class _DeliveryTipScreenState extends State<DeliveryTipScreen> {
  late int baseDeliveryTip;
  late int minimumOrderPrice;
  late List<DeliveryTipModel> storeDeliveryTipDTOList;

  @override
  void initState() {
    super.initState();
    baseDeliveryTip = widget.baseDeliveryTip;
    minimumOrderPrice = widget.minimumOrderPrice;
    storeDeliveryTipDTOList = widget.storeDeliveryTipDTOList;
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
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
            onPressed: () {
              FocusScope.of(context).unfocus();

              for (int i = storeDeliveryTipDTOList.length - 1; i > 0; i--) {
                if (storeDeliveryTipDTOList[i].minPrice !=
                    storeDeliveryTipDTOList[i - 1].maxPrice) {
                  showFailDialogWithImage(
                      mainTitle: "배달팁 등록 실패",
                      subTitle: "현재 최대 주문 금액이 다음\n최소 주문 금액과 같아야 합니다.");
                  return;
                }

                if (storeDeliveryTipDTOList[i].deliveryTip >
                    storeDeliveryTipDTOList[i - 1].deliveryTip) {
                  showFailDialogWithImage(
                      mainTitle: "배달팁 등록 실패",
                      subTitle: "다음 배달팁은 이전 배달팁보다 작아야합니다.");
                  return;
                }
              }

              if (baseDeliveryTip > widget.deliveryTipMax ||
                  storeDeliveryTipDTOList.any((deliveryTipModel) =>
                      deliveryTipModel.deliveryTip > widget.deliveryTipMax)) {
                showFailDialogWithImage(
                    mainTitle: "배달팁 등록 실패",
                    subTitle:
                        "배달팁은 ${widget.deliveryTipMax.toKoreanCurrency}원 이하만 설정 가능합니다.");
              } else {
                /*
                    todo storeDeliveryTipDTOList 의 입력값 validation 필요
                    가게 배달팁을 변경합니다.
                    현재 최대 가격 금액이 다음 설정하려는 최소 주문 금액과 같아야 합니다. 예를 들어 '8000원 이상 10000원 이하' -> '10000원 이상 30000원 이하'
                    '8000원 이상' 인 경우 최소 가격은 8000원, 최대 가격은 null 입니다.
                    배달팁 내용, 최소 가격, 최대 가겨, 배달 팁 리스트의 크기는 모두 같고 인덱스 순으로 같은 배달팁입니다.
                    배달팁 변경 페이지에 존재하는 배달팁에 대한 정보를 전송해야 합니다. (기존에 설정되어 있는 배달팁 포함)
                 */
                widget.onSaveFunction(baseDeliveryTip, minimumOrderPrice,
                    storeDeliveryTipDTOList);
                showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
              }
            },
            label: "변경하기",
            disabled: widget.minimumOrderPrice == minimumOrderPrice &&
                widget.baseDeliveryTip == baseDeliveryTip &&
                const DeepCollectionEquality().equals(
                    widget.storeDeliveryTipDTOList, storeDeliveryTipDTOList),
          )),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: ListView(children: [
            // --------------------------- 기본 배달팁 ---------------------------
            SGTypography.body("기본 배달팁",
                color: SGColors.black,
                size: FontSize.normal,
                weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            MultipleInformationBox(children: [
              SGTypography.body("최소 주문 금액 설정",
                  color: SGColors.black,
                  size: FontSize.small,
                  weight: FontWeight.w600),
              SizedBox(height: SGSpacing.p4),
              Row(children: [
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: NumericTextField(
                          initialValue: widget.minimumOrderPrice,
                          decoration: InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding:
                                EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          ),
                          onValueChanged: (minimumOrderPrice) {
                            setState(() {
                              this.minimumOrderPrice = minimumOrderPrice;
                            });
                            // print("Updated minimumOrderPrice tip: $minimumOrderPrice");
                          },
                        ),
                      ),
                      SGContainer(
                          padding:
                              EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원 이상",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500)),
                    ],
                  )),
                ),
                SizedBox(width: SGSpacing.p2),
                Expanded(
                  child: SGTextFieldWrapper(
                      child: Row(
                    children: [
                      Expanded(
                        child: NumericTextField(
                          initialValue: widget.baseDeliveryTip,
                          decoration: InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(color: SGColors.gray4),
                            contentPadding:
                                EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide.none),
                          ),
                          onValueChanged: (baseDeliveryTip) {
                            setState(() {
                              this.baseDeliveryTip = baseDeliveryTip;
                            });
                            // print("Updated delivery tip: $baseDeliveryTip");
                          },
                        ),
                      ),
                      SGContainer(
                          padding:
                              EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                          child: SGTypography.body("원",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500)),
                    ],
                  )),
                ),
              ])
            ]),

            SizedBox(height: SGSpacing.p5),

            // --------------------------- 배달팁 추가 ---------------------------
            SGTypography.body("배달팁 추가",
                color: SGColors.black,
                size: FontSize.normal,
                weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p3),
            DeliveryTipCard(
              storeDeliveryTipDTOList: storeDeliveryTipDTOList,
              onEditFunction: (storeDeliveryTipDTOList) {
                print(
                    "onEditFunction storeDeliveryTipDTOList $storeDeliveryTipDTOList");
                setState(() {
                  this.storeDeliveryTipDTOList = storeDeliveryTipDTOList;
                });
              },
            ),

            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGTypography.body("* ${widget.deliveryTipInfo}",
                color: SGColors.gray3, lineHeight: 1.25),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
}
