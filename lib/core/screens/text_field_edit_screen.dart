import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class TextFieldEditScreen extends StatefulWidget {
  final String value;
  final String title;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;

  TextFieldEditScreen({
    Key? key,
    required this.value,
    required this.title,
    required this.hintText,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TextFieldEditScreen> createState() => _TextFieldEditScreenState();
}

class _TextFieldEditScreenState extends State<TextFieldEditScreen> {
  late String value;
  late TextEditingController controller = TextEditingController();

  TextStyle baseStyle =
      TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  @override
  void initState() {
    super.initState();
    value = widget.value;
    controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
              onPressed: () {
                widget.onSubmit(controller.text);
                // Navigator.of(context).pop();
              },
              label: widget.buttonText)),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.label("변경 전"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(SGSpacing.p4),
                hintText: widget.value,
                isCollapsed: true,
                hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                enabled: false,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none),
              )),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.label("변경 후"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  controller: controller,
                  style: baseStyle.copyWith(color: SGColors.black),
                  onChanged: (value) {
                    setState(() {
                      this.value = value;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(SGSpacing.p4),
                    isCollapsed: true,
                    hintText: widget.hintText,
                    hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                  )),
            ),
          ])),
    );
  }
}
