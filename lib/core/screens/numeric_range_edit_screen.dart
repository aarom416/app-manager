import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/snackbar.dart';

import '../components/action_button.dart';
import '../components/container.dart';
import '../components/numeric_textfield.dart';
import '../components/sizing.dart';
import '../components/spacing.dart';
import '../components/typography.dart';
import '../constants/colors.dart';

class NumericRangeEditScreen extends ConsumerStatefulWidget {
  NumericRangeEditScreen({
    super.key,
    required this.title,
    required this.description,
    this.minLabel = "최소",
    this.maxLabel = "최대",
    this.unitLabel = "개",
    this.allowMinZero = false,
    this.allowMaxZero = false,
    this.maxMinValue = 99999,
    this.maxMaxValue = 99999,
    this.hideMinInput = false,
    this.minValue = 0,
    this.maxValue = 0,
    this.confirmButtonLabel = "변경하기",
    required this.onConfirm,
  });

  @override
  ConsumerState<NumericRangeEditScreen> createState() =>
      _NumericRangeEditScreen();

  final String title;
  final String description;
  final String minLabel;
  final String maxLabel;
  final String unitLabel;
  final bool allowMinZero;
  final bool allowMaxZero;
  final int maxMinValue;
  final int maxMaxValue;
  final bool hideMinInput;
  final int minValue;
  final int maxValue;
  final String confirmButtonLabel;
  final Function(int, int) onConfirm;
}

class _NumericRangeEditScreen extends ConsumerState<NumericRangeEditScreen> {
  /*const NumericRangeEditScreen({
    super.key,
    required this.title,
    required this.description,
    this.minLabel = "최소",
    this.maxLabel = "최대",
    this.unitLabel = "개",
    this.allowMinZero = false,
    this.allowMaxZero = false,
    this.maxMinValue = 99999,
    this.maxMaxValue = 99999,
    this.hideMinInput = false,
    this.minValue = 0,
    this.maxValue = 0,
    this.confirmButtonLabel = "변경하기",
    required this.onConfirm,
  });*/
  bool isEnable = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController minValueController =
        TextEditingController(text: widget.minValue.toString());
    final TextEditingController maxValueController =
        TextEditingController(text: widget.maxValue.toString());

    String minErrorMessage = "";
    String maxErrorMessage = "";

    void validateInputs() {
      minErrorMessage = "";
      maxErrorMessage = "";

      final minValue = int.tryParse(minValueController.text) ?? 0;
      final maxValue = int.tryParse(maxValueController.text) ?? 0;

      if (!widget.allowMinZero && minValue == 0) {
        minErrorMessage = "0은 입력할 수 없습니다.";
      } else if (minValue > widget.maxMinValue) {
        minErrorMessage = "최대 ${widget.maxMinValue}까지 입력할 수 있습니다.";
      }

      if (!widget.allowMaxZero && maxValue == 0) {
        maxErrorMessage = "0은 입력할 수 없습니다.";
      } else if (maxValue > widget.maxMaxValue) {
        maxErrorMessage = "최대 ${widget.maxMaxValue}까지 입력할 수 있습니다.";
      }

      if (!widget.hideMinInput && minValue > maxValue) {
        minErrorMessage = "최소값은 최대값보다 클 수 없습니다.";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SGColors.white,
        elevation: 0,
        title: SGTypography.body(widget.title,
            size: FontSize.medium,
            weight: FontWeight.w700,
            color: SGColors.black),
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
            validateInputs();
            if (minErrorMessage.isEmpty && maxErrorMessage.isEmpty) {
              final minValue = int.tryParse(minValueController.text) ?? 0;
              final maxValue = int.tryParse(maxValueController.text) ?? 0;
              widget.onConfirm(minValue, maxValue);
              showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(minErrorMessage.isNotEmpty
                      ? minErrorMessage
                      : maxErrorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          disabled: isEnable,
          label: widget.confirmButtonLabel,
        ),
      ),
      body: SGContainer(
        borderWidth: 0,
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            SGTypography.body(widget.description,
                weight: FontWeight.w700, size: FontSize.normal),
            SizedBox(height: SGSpacing.p4),
            if (!widget.hideMinInput) ...[
              SGTypography.body(widget.minLabel,
                  size: FontSize.small, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                color: Colors.white,
                borderColor: SGColors.line3,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Row(
                  children: [
                    Expanded(
                      child: NumericTextField(
                        initialValue: widget.minValue,
                        maxLength: widget.maxMinValue.toString().length,
                        onValueChanged: (value) {
                          setState(() {
                            minValueController.text = value.toString();
                            if (minValueController.text == '0' ||
                                maxValueController.text == '0') {
                              isEnable = true;
                            } else {
                              isEnable = false;
                            }
                          });
                        },
                      ),
                    ),
                    SGTypography.body(widget.unitLabel,
                        size: FontSize.small, color: SGColors.gray4),
                    SizedBox(width: SGSpacing.p4),
                  ],
                ),
              ),
              if (minErrorMessage.isNotEmpty) ...[
                SizedBox(height: SGSpacing.p2),
                SGTypography.body(minErrorMessage,
                    size: FontSize.small, color: Colors.red),
              ],
              SizedBox(height: SGSpacing.p3),
            ],
            SGTypography.body(widget.maxLabel,
                size: FontSize.small, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: NumericTextField(
                      initialValue: widget.maxValue,
                      maxLength: widget.maxMaxValue.toString().length,
                      onValueChanged: (value) {
                        setState(() {
                          maxValueController.text = value.toString();
                          if (minValueController.text == '0' ||
                              maxValueController.text == '0') {
                            isEnable = true;
                          } else {
                            isEnable = false;
                          }
                        });
                      },
                    ),
                  ),
                  SGTypography.body(widget.unitLabel,
                      size: FontSize.small, color: SGColors.gray4),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
            if (maxErrorMessage.isNotEmpty) ...[
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(maxErrorMessage,
                  size: FontSize.small, color: Colors.red),
            ],
          ],
        ),
      ),
    );
  }
}
