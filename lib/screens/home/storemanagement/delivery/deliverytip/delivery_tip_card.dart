import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../../../../../core/components/multiple_information_box.dart';
import '../../../../common/components/numeric_textfield.dart';
import '../model.dart';

class DeliveryTipCard extends StatefulWidget {
  final List<DeliveryTipModel> storeDeliveryTipDTOList;
  final Function(List<DeliveryTipModel>) onEditFunction;

  const DeliveryTipCard({
    super.key,
    required this.storeDeliveryTipDTOList,
    required this.onEditFunction,
  });

  @override
  State<DeliveryTipCard> createState() => _DeliveryTipCardState();
}

class _DeliveryTipCardState extends State<DeliveryTipCard> {
  late List<TextEditingController> minPriceControllers;
  late List<TextEditingController> maxPriceControllers;
  late List<TextEditingController> deliveryTipControllers;

  @override
  void initState() {
    super.initState();
    minPriceControllers = widget.storeDeliveryTipDTOList.map((deliveryTip) => TextEditingController(text: deliveryTip.minPrice.toKoreanCurrency)).toList();
    maxPriceControllers = widget.storeDeliveryTipDTOList.map((deliveryTip) => TextEditingController(text: deliveryTip.maxPrice.toKoreanCurrency)).toList();
    deliveryTipControllers = widget.storeDeliveryTipDTOList.map((deliveryTip) => TextEditingController(text: deliveryTip.deliveryTip.toKoreanCurrency)).toList();
  }

  @override
  void dispose() {
    for (var controller in minPriceControllers) {
      controller.dispose();
    }
    for (var controller in maxPriceControllers) {
      controller.dispose();
    }
    for (var controller in deliveryTipControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultipleInformationBox(children: [
      ...widget.storeDeliveryTipDTOList.mapIndexed((index, deliveryTipModel) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.body("주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            Row(children: [
              Expanded(
                child: SGTextFieldWrapper(
                    child: Row(
                  children: [
                    Expanded(
                      child: NumericTextField(
                        controller: minPriceControllers[index],
                        onValueChanged: (minPrice) {
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(minPrice: minPrice);
                          widget.onEditFunction(updatedStoreDeliveryTipDTOList);
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
                      child: NumericTextField(
                        controller: maxPriceControllers[index],
                        onValueChanged: (maxPrice) {
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(maxPrice: maxPrice);
                          widget.onEditFunction(updatedStoreDeliveryTipDTOList);
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
                        minPriceControllers.removeAt(index).dispose();
                        maxPriceControllers.removeAt(index).dispose();
                        deliveryTipControllers.removeAt(index).dispose();
                        final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                        updatedStoreDeliveryTipDTOList.removeAt(index);
                        widget.onEditFunction(updatedStoreDeliveryTipDTOList);
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
                      child: NumericTextField(
                        controller: deliveryTipControllers[index],
                        onValueChanged: (deliveryTip) {
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(deliveryTip: deliveryTip);
                          widget.onEditFunction(updatedStoreDeliveryTipDTOList);
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
      GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    const newDeliveryTip = DeliveryTipModel();
                    minPriceControllers.add(TextEditingController(text: newDeliveryTip.minPrice == 0 ? "" : newDeliveryTip.minPrice.toKoreanCurrency));
                    maxPriceControllers.add(TextEditingController(text: newDeliveryTip.maxPrice == 0 ? "" : newDeliveryTip.maxPrice.toKoreanCurrency));
                    deliveryTipControllers.add(TextEditingController(text: newDeliveryTip.deliveryTip == 0 ? "" : newDeliveryTip.deliveryTip.toKoreanCurrency));
                    final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                    updatedStoreDeliveryTipDTOList.add(newDeliveryTip);
                    widget.onEditFunction(updatedStoreDeliveryTipDTOList);
                  });
                },
                child: Image.asset("assets/images/accumulative.png", width: 24, height: 24)),
            SizedBox(width: SGSpacing.p1),
            SGTypography.body("배달팁 추가하기", color: SGColors.black, size: FontSize.small, weight: FontWeight.w600),
          ],
        ),
      )
    ]);
  }
}
