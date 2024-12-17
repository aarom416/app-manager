import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../../main.dart';

class TextAreaEditScreen extends StatefulWidget {
  final String value;
  final String title;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;
  int? maxLength;

  TextAreaEditScreen({
    super.key,
    required this.value,
    required this.title,
    required this.hintText,
    required this.buttonText,
    required this.onSubmit,
    this.maxLength,
  });

  @override
  State<TextAreaEditScreen> createState() => _TextAreaEditScreenState();
}

class _TextAreaEditScreenState extends State<TextAreaEditScreen> {
  late TextEditingController controller;
  late String value;

  bool hasBadWord = false;
  TextStyle baseStyle = const TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
    value = widget.value;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      });
    });

    controller.addListener(() {
      setState(() {
        value = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _checkBadWord(String input) async {
    try {
      final response = await Dio().get(
        'https://singleatapp.com/api/v1/user/auth/bad-word',
        queryParameters: {'word': input},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        setState(() {
          hasBadWord = response.data['data'] == true;
        });
      }
    } catch (e) {
      logger.d("Error occurred: $e");
      setState(() {
        hasBadWord = false;
      });
    }
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
            label: widget.buttonText,
            disabled: controller.text.isEmpty || hasBadWord,
          )),
      body: SGContainer(
          color: const Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.label("변경 전"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(SGSpacing.p4),
                    hintText: widget.value,
                    isCollapsed: true,
                    hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                    enabled: false,
                    border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
                  )),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.label("변경 후"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Stack(alignment: Alignment.bottomRight, children: [
                TextField(
                    controller: controller,
                    maxLines: 5,
                    style: baseStyle.copyWith(color: SGColors.black),
                    onChanged: (value) async {
                      await _checkBadWord(value);

                      setState(() {
                        if (widget.maxLength != null && value.length > widget.maxLength!) {
                          controller.text = value.substring(0, widget.maxLength!);
                          controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.maxLength!));
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
                if (widget.maxLength != null)
                  SGContainer(
                      padding: EdgeInsets.all(SGSpacing.p4),
                      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        SGTypography.body(
                          "${value.length}",
                        ),
                        SGTypography.body(
                          "/${widget.maxLength}",
                          color: SGColors.gray3,
                        ),
                      ]))
              ]),
            ),
            if (hasBadWord)
              Padding(
                padding: EdgeInsets.only(top: SGSpacing.p2),
                child: const Text(
                  '욕설 및 비하 발언이 포함되어있습니다.\n다시 한 번 확인해주세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF62B2B),
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
          ])),
    );
  }
}
