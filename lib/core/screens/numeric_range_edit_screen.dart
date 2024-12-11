import 'package:flutter/material.dart';
import '../components/action_button.dart';
import '../components/container.dart';
import '../components/numeric_textfield.dart';
import '../components/sizing.dart';
import '../components/spacing.dart';
import '../components/typography.dart';
import '../constants/colors.dart';

class NumericRangeEditScreen extends StatelessWidget {
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

  const NumericRangeEditScreen({
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
  Widget build(BuildContext context) {
    final TextEditingController minValueController = TextEditingController(text: minValue.toString());
    final TextEditingController maxValueController = TextEditingController(text: maxValue.toString());

    String minErrorMessage = "";
    String maxErrorMessage = "";

    void validateInputs() {
      minErrorMessage = "";
      maxErrorMessage = "";

      final minValue = int.tryParse(minValueController.text) ?? 0;
      final maxValue = int.tryParse(maxValueController.text) ?? 0;

      if (!allowMinZero && minValue == 0) {
        minErrorMessage = "0은 입력할 수 없습니다.";
      } else if (minValue > maxMinValue) {
        minErrorMessage = "최대 $maxMinValue까지 입력할 수 있습니다.";
      }

      if (!allowMaxZero && maxValue == 0) {
        maxErrorMessage = "0은 입력할 수 없습니다.";
      } else if (maxValue > maxMaxValue) {
        maxErrorMessage = "최대 $maxMaxValue까지 입력할 수 있습니다.";
      }

      if (!hideMinInput && minValue > maxValue) {
        minErrorMessage = "최소값은 최대값보다 클 수 없습니다.";
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: SGColors.white,
        elevation: 0,
        title: SGTypography.body(title, size: FontSize.medium, weight: FontWeight.w700, color: SGColors.black),
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
              onConfirm(minValue, maxValue);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(minErrorMessage.isNotEmpty ? minErrorMessage : maxErrorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          disabled: minValueController.text == "0" || maxValueController.text == "0",
          label: confirmButtonLabel,
        ),
      ),
      body: SGContainer(
        borderWidth: 0,
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: ListView(
          children: [
            SGTypography.body(description, weight: FontWeight.w700, size: FontSize.normal),
            SizedBox(height: SGSpacing.p4),
            if (!hideMinInput) ...[
              SGTypography.body(minLabel, size: FontSize.small, color: SGColors.gray4),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGContainer(
                color: Colors.white,
                borderColor: SGColors.line3,
                borderRadius: BorderRadius.circular(SGSpacing.p3),
                child: Row(
                  children: [
                    Expanded(
                      child: NumericTextField(
                        initialValue: minValue,
                        maxLength: maxMinValue.toString().length,
                        onValueChanged: (value) {
                          minValueController.text = value.toString();
                        },
                      ),
                    ),
                    SGTypography.body(unitLabel, size: FontSize.small, color: SGColors.gray4),
                    SizedBox(width: SGSpacing.p4),
                  ],
                ),
              ),
              if (minErrorMessage.isNotEmpty) ...[
                SizedBox(height: SGSpacing.p2),
                SGTypography.body(minErrorMessage, size: FontSize.small, color: Colors.red),
              ],
              SizedBox(height: SGSpacing.p3),
            ],
            SGTypography.body(maxLabel, size: FontSize.small, color: SGColors.gray4),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: Row(
                children: [
                  Expanded(
                    child: NumericTextField(
                      initialValue: maxValue,
                      maxLength: maxMaxValue.toString().length,
                      onValueChanged: (value) {
                        maxValueController.text = value.toString();
                      },
                    ),
                  ),
                  SGTypography.body(unitLabel, size: FontSize.small, color: SGColors.gray4),
                  SizedBox(width: SGSpacing.p4),
                ],
              ),
            ),
            if (maxErrorMessage.isNotEmpty) ...[
              SizedBox(height: SGSpacing.p2),
              SGTypography.body(maxErrorMessage, size: FontSize.small, color: Colors.red),
            ],
          ],
        ),
      ),
    );
  }
}
