import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/main.dart';

class TextAreaScreen extends StatefulWidget {
  final String value;
  final String title;
  final String fieldLabel;
  final String hintText;
  final String buttonText;
  final Function(String) onSubmit;

  const TextAreaScreen({
    super.key,
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
  final int maxStoreIntroductionLength = 300;
  final int maxLength = 100;

  Timer? _debounce;

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
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
          maxHeight: 58,
        ),
        child: SGActionButton(
          onPressed: (hasBadWord || controller.text.isEmpty)
              ? () {}
              : () {
            widget.onSubmit(controller.text);
          },
          label: widget.buttonText,
          disabled: hasBadWord || controller.text.isEmpty,
        ),
      ),

      body: SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(
          horizontal: SGSpacing.p4,
          vertical: SGSpacing.p6,
        ),
        child: ListView(
          children: [
            SGTypography.body(
              widget.fieldLabel,
              color: SGColors.black,
              weight: FontWeight.w700,
              size: FontSize.normal,
            ),
            SizedBox(height: SGSpacing.p3),
            SGTextFieldWrapper(
              child: SGContainer(
                color: Colors.white,
                borderColor: SGColors.line3,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    TextField(
                      controller: controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: baseStyle.copyWith(color: SGColors.black),
                      onChanged: (text) {
                        final maxLimit = widget.fieldLabel == "가게 소개" ? maxStoreIntroductionLength : maxLength;

                        if (text.length > maxLimit) {
                          controller.text = text.substring(0, maxLimit);
                          controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: maxLimit),
                          );
                        }

                        if (_debounce?.isActive ?? false) _debounce?.cancel();
                        _debounce = Timer(const Duration(milliseconds: 100), () {
                          _checkBadWord(text);
                        });

                        setState(() {
                          value = controller.text;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(SGSpacing.p4),
                        hintText: widget.hintText,
                        hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(SGSpacing.p3),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (widget.fieldLabel == "가게 소개")
                      Positioned(
                        bottom: SGSpacing.p3,
                        right: SGSpacing.p3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SGTypography.body(
                              "${value.length}",
                            ),
                            SGTypography.body(
                              "/$maxStoreIntroductionLength",
                              color: SGColors.gray3,
                            ),
                          ],
                        ),
                      ),
                    if (widget.fieldLabel != "가게 소개")
                      Positioned(
                        bottom: SGSpacing.p3,
                        right: SGSpacing.p3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SGTypography.body(
                              "${value.length}",
                            ),
                            SGTypography.body(
                              "/$maxLength",
                              color: SGColors.gray3,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
