import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/switch.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/utils/int.dart';
import 'package:singleeat/utils/string.dart';

import '../../../../../core/components/dialog.dart';
import '../../../../../core/components/multiple_information_box.dart';
import '../../../../../core/utils/formatter.dart';
import '../../../../../utils/time_utils.dart';
import '../model.dart';

class DeliveryTipBox extends StatefulWidget {
  final List<DeliveryTipModel> storeDeliveryTipDTOList;
  final Function(List<DeliveryTipModel>) onEditFunction;

  const DeliveryTipBox({
    super.key,
    required this.storeDeliveryTipDTOList,
    required this.onEditFunction,
  });

  @override
  State<DeliveryTipBox> createState() => _DeliveryTipBoxState();
}

class _DeliveryTipBoxState extends State<DeliveryTipBox> {
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
                      child: TextField(
                        controller: minPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (minPrice) {
                          String numericValue = minPrice.replaceAll(',', '');
                          if (numericValue.startsWith('0')) {
                            numericValue = numericValue.substring(1);
                          }
                          String formattedValue = int.tryParse(numericValue)?.toStringAsCurrency ?? '';
                          minPriceControllers[index].text = formattedValue;
                          minPriceControllers[index].selection = TextSelection.collapsed(offset: formattedValue.length);
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(minPrice: numericValue.toIntFromCurrency);
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
                      child: TextField(
                        controller: maxPriceControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (maxPrice) {
                          String numericValue = maxPrice.replaceAll(',', '');
                          if (numericValue.startsWith('0')) {
                            numericValue = numericValue.substring(1);
                          }
                          String formattedValue = int.tryParse(numericValue)?.toStringAsCurrency ?? '';
                          maxPriceControllers[index].text = formattedValue;
                          maxPriceControllers[index].selection = TextSelection.collapsed(offset: formattedValue.length);
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(maxPrice: numericValue.toIntFromCurrency);
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
                      child: TextField(
                        controller: deliveryTipControllers[index],
                        style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: SGColors.gray4),
                          contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onChanged: (deliveryTip) {
                          String numericValue = deliveryTip.replaceAll(',', '');
                          if (numericValue.startsWith('0')) {
                            numericValue = numericValue.substring(1);
                          }
                          String formattedValue = int.tryParse(numericValue)?.toStringAsCurrency ?? '';
                          deliveryTipControllers[index].text = formattedValue;
                          deliveryTipControllers[index].selection = TextSelection.collapsed(offset: formattedValue.length);
                          final updatedStoreDeliveryTipDTOList = List<DeliveryTipModel>.from(widget.storeDeliveryTipDTOList);
                          updatedStoreDeliveryTipDTOList[index] = deliveryTipModel.copyWith(deliveryTip: numericValue.toIntFromCurrency);
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
