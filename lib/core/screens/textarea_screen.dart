import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class TextAreaScreen extends StatefulWidget {
  final String value;
  final String title;
  final String fieldLabel;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;

  TextAreaScreen({
    required this.value,
    required this.title,
    required this.fieldLabel,
    required this.buttonText,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  State<TextAreaScreen> createState() => _TextAreaScreenState();
}

class _TextAreaScreenState extends State<TextAreaScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: widget.title),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  widget.onSubmit(controller.text);
                  Navigator.of(context).pop();
                },
                label: widget.buttonText)),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body(widget.fieldLabel,
                  color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
              SizedBox(height: SGSpacing.p3),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p2),
                child: TextField(
                  controller: controller,
                  maxLines: 5,
                  style: TextStyle(
                    color: SGColors.black,
                    fontSize: FontSize.small,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: SGColors.gray3,
                      fontSize: FontSize.small,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              )),
            ])));
  }
}
