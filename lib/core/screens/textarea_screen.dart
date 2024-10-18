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
  late String value;

  TextStyle baseStyle = TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);
  int maxLength = 100;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
    value = widget.value;
    controller.text = widget.value;
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
                  child:  SGContainer(
                    color: Colors.white,
                    borderColor: SGColors.line3,
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Stack(alignment: Alignment.bottomRight, children: [
                      TextField(
                          controller: controller,
                          maxLines: 5,
                          style: baseStyle.copyWith(color: SGColors.black),
                          onChanged: (value) {
                            setState(() {
                              if (maxLength != null && value.length > maxLength!) {
                                controller.text = value.substring(0, maxLength!);
                                controller.selection = TextSelection.fromPosition(TextPosition(offset: maxLength!));
                                return;
                              }
                              this.value = value;
                            });
                          },
                          decoration: InputDecoration(
                            // vertically stretched suffix Icon
                            // suffixIcon: SGContainer(
                            //     width: SGSpacing.p16,
                            //     height: SGSpacing.p28 - SGSpacing.p2,
                            //     color: SGColors.success,
                            //     child: Column(children: [Icon(Icons.visibility)])),
                            //
                            // suffixIconConstraints: BoxConstraints(minHeight: 0),
                            isDense: true,
                            contentPadding: EdgeInsets.all(SGSpacing.p4),
                            isCollapsed: true,
                            hintText: widget.hintText,
                            hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                            border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                          )),
                      if (maxLength != null)
                        SGContainer(
                            padding: EdgeInsets.all(SGSpacing.p4),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              SGTypography.body(
                                "${value.length}",
                              ),
                              SGTypography.body(
                                "/${maxLength}",
                                color: SGColors.gray3,
                              ),
                            ]))
                    ]),
                  )),
            ]
            )));
  }
}
