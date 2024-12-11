import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../components/numeric_textfield.dart';

class PriceFieldEditScreen extends StatefulWidget {
  final int price;
  final String title;
  final String hintText;
  final String buttonText;
  final Function(int) onSubmit;

  const PriceFieldEditScreen({
    super.key,
    required this.price,
    required this.title,
    required this.hintText,
    this.buttonText = "변경하기",
    required this.onSubmit,
  });

  @override
  State<PriceFieldEditScreen> createState() => _PriceFieldEditScreenState();
}

class _PriceFieldEditScreenState extends State<PriceFieldEditScreen> {
  late int price;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    price = widget.price;
    controller = TextEditingController(text: widget.price.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SGColors.white,
        elevation: 0,
        title: SGTypography.body(widget.title, size: FontSize.medium, weight: FontWeight.w700, color: SGColors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: SGColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
          maxHeight: 58,
        ),
        child: SGActionButton(
          onPressed: () {
            widget.onSubmit(price);
            Navigator.of(context).pop();
          },
          label: widget.buttonText,
        ),
      ),
      body: SGContainer(
        borderWidth: 0,
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            SGTypography.body("변경 전", weight: FontWeight.w700, size: FontSize.normal),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4, horizontal: SGSpacing.p3),
                      child: SGTypography.body(
                        widget.price.toKoreanCurrency,
                        size: FontSize.small,
                        color: SGColors.gray4,
                      ),
                    ),
                  ),
                  SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.body("변경 후", weight: FontWeight.w700, size: FontSize.normal),
            SizedBox(height: SGSpacing.p3),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4, horizontal: SGSpacing.p3),
                      child: NumericTextField(
                        initialValue: widget.price,
                        decoration: InputDecoration(
                          isDense: true,
                          isCollapsed: true,
                          hintText: widget.hintText,
                          hintStyle: TextStyle(color: SGColors.gray3, fontSize: FontSize.small, fontWeight: FontWeight.w400),
                          border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                        ),
                        onValueChanged: (value) {
                          setState(() {
                            price = value;
                          });
                        },
                      ),
                    ),
                  ),
                  SGTypography.body("원", color: SGColors.gray4, size: FontSize.small, weight: FontWeight.w500),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
