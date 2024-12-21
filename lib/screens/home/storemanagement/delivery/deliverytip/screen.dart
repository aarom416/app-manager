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
  final Function(int, int, List<DeliveryTipModel>) onSaveFunction;

  const DeliveryTipScreen(
      {super.key,
      required this.baseDeliveryTip,
      required this.deliveryTipMax,
      required this.minimumOrderPrice,
      required this.storeDeliveryTipDTOList,
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

              // 첫 번째 최소 주문 금액과 첫 번째 배달팁 유효성 검사
              if (storeDeliveryTipDTOList.isNotEmpty) {
                // 첫 번째 최소 주문 금액과 최소 주문 금액 비교
                if (storeDeliveryTipDTOList[0].minPrice < minimumOrderPrice) {
                  showFailDialogWithImage(
                    mainTitle: "배달팁 등록 실패",
                    subTitle: "첫 번째 최소 주문 금액은 최소 주문 금액보다 작을 수 없습니다.",
                  );
                  return;
                }

                // 첫 번째 배달팁과 최소 배달팁 비교
                if (storeDeliveryTipDTOList[0].deliveryTip > baseDeliveryTip) {
                  showFailDialogWithImage(
                    mainTitle: "배달팁 등록 실패",
                    subTitle: "첫 번째 배달팁은 최소 배달팁보다 작을 수 없습니다.",
                  );
                  return;
                }
              }

              // 배달팁 유효성 검사 (배달팁 > 5000원, 최소/최대 주문 금액 불일치 등)
              for (int i = 0; i < storeDeliveryTipDTOList.length; i++) {
                int minPrice = storeDeliveryTipDTOList[i].minPrice;
                int maxPrice = storeDeliveryTipDTOList[i].maxPrice;

                // 최소 주문 금액이 최대 주문 금액보다 클 수 없음
                if (minPrice > maxPrice) {
                  showFailDialogWithImage(
                      mainTitle: "배달팁 등록 실패",
                      subTitle: "금액을 다시 한 번 확인해주세요.");
                  return;
                }
              }


              if (!(baseDeliveryTip == widget.baseDeliveryTip &&
                  minimumOrderPrice == widget.minimumOrderPrice &&
                  const DeepCollectionEquality().equals(
                      widget.storeDeliveryTipDTOList, storeDeliveryTipDTOList))) {
                widget.onSaveFunction(baseDeliveryTip, minimumOrderPrice, storeDeliveryTipDTOList);
                showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
              }
            },
            label: "변경하기",
            disabled: baseDeliveryTip == widget.baseDeliveryTip &&
                minimumOrderPrice == widget.minimumOrderPrice &&
                const DeepCollectionEquality().equals(
                    widget.storeDeliveryTipDTOList, storeDeliveryTipDTOList),
          ),
      ),
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
              Row(
                children: [
                  Expanded(
                    child: SGTextFieldWrapper(
                      child: Row(
                        children: [
                          Expanded(
                            child: NumericTextField(
                              initialValue: minimumOrderPrice,
                              decoration: InputDecoration(
                                hintText: "",
                                hintStyle: TextStyle(color: SGColors.gray4),
                                contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              ),
                              onValueChanged: (value) {
                                setState(() {
                                  minimumOrderPrice = value;
                                });
                              },
                            ),
                          ),
                          SGContainer(
                            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                            child: SGTypography.body(
                              "원 이상",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: SGSpacing.p2),
                  Expanded(
                    child: SGTextFieldWrapper(
                      child: Row(
                        children: [
                          Expanded(
                            child: NumericTextField(
                              initialValue: baseDeliveryTip,
                              decoration: InputDecoration(
                                hintText: "",
                                hintStyle: TextStyle(color: SGColors.gray4),
                                contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                              ),
                              onValueChanged: (value) {
                                setState(() {
                                  baseDeliveryTip = value;
                                });
                              },
                            ),
                          ),
                          SGContainer(
                            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                            child: SGTypography.body(
                              "원",
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
            SGTypography.body("30,000원 이상, 0원 미만으로 설정하시면 30,000원 이상부터는\n동일한 배달팁이 적용돼요!",
                color: SGColors.gray3, lineHeight: 1.25),
            SizedBox(height: SGSpacing.p20),
          ])),
    );
  }
}
