import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/flex.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/model.dart';

class OrderMenuList extends StatefulWidget {
  OrderMenuList(
      {super.key,
      required this.orderMenuOptionDTOList,
      required this.orderMenu,
      required this.colorType});
  final List<OrderMenuOptionDTO> orderMenuOptionDTOList;
  final OrderMenuDTO orderMenu;
  final Color colorType;

  @override
  State<OrderMenuList> createState() => _OrderMenuListState();
}

class _OrderMenuListState extends State<OrderMenuList> {
  @override
  Widget build(BuildContext context) {
    return SGContainer(
      child: Column(
        children: [
          Row(children: [
            SGFlexible(
                flex: 2,
                child: SGTypography.body(widget.orderMenu.menuName,
                    size: FontSize.small, color: widget.colorType)),
            SGFlexible(
                flex: 1,
                child: Center(
                    child: SGTypography.body(
                  widget.orderMenu.count.toString(),
                  size: FontSize.small,
                  color: widget.colorType,
                ))),
            SGFlexible(
                flex: 1,
                child: SGTypography.body(
                    widget.orderMenu.menuPrice.toKoreanCurrency,
                    align: TextAlign.right,
                    size: FontSize.small,
                    color: widget.colorType)),
          ]),
          SizedBox(height: SGSpacing.p3),
          ...widget.orderMenuOptionDTOList
              .map((e) => _OrderMenuOptionList(orderMenuOption: e)),
        ],
      ),
    );
  }
}

class _OrderMenuOptionList extends StatefulWidget {
  _OrderMenuOptionList({super.key, required this.orderMenuOption});
  final OrderMenuOptionDTO orderMenuOption;
  @override
  State<_OrderMenuOptionList> createState() => _OrderMenuOptionListState();
}

class _OrderMenuOptionListState extends State<_OrderMenuOptionList> {
  @override
  Widget build(BuildContext context) {
    return SGContainer(
      child: Row(children: [
        SGFlexible(
            flex: 2,
            child: SGTypography.body(
              "ㄴ ${widget.orderMenuOption.menuOptionName}",
              size: FontSize.small,
              color: SGColors.gray3,
            )),
        SGFlexible(
            flex: 1,
            child: Center(
                child: SGTypography.body(
              widget.orderMenuOption.count.toString(),
              size: FontSize.small,
            ))),
        SGFlexible(
            flex: 1,
            child: SGTypography.body(
                widget.orderMenuOption.menuOptionPrice.toKoreanCurrency,
                align: TextAlign.right,
                size: FontSize.small)),
      ]),
    );
  }
}
