import 'package:flutter/material.dart';
import '../components/numeric_textfield.dart';


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
  final Function(int, int) onConfirm;

  const NumericRangeEditScreen({
    super.key,
    required this.title,
    required this.description,
    this.minLabel = "최소",
    this.maxLabel = "최대",
    this.unitLabel= "개",
    this.allowMinZero = false,
    this.allowMaxZero = false,
    this.maxMinValue = 99999,
    this.maxMaxValue = 99999,
    this.hideMinInput = false,
    this.minValue = 0,
    this.maxValue = 0,
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
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton.extended(
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
          label: const Text("확인"),
          icon: const Icon(Icons.check),
        );
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (!hideMinInput) ...[
              Text(minLabel, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              NumericTextField(
                initialValue: minValue,
                maxLength: maxMinValue.toString().length,
                onValueChanged: (value) {
                  minValueController.text = value.toString();
                },
              ),
              if (minErrorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(minErrorMessage, style: const TextStyle(color: Colors.red, fontSize: 12)),
              ],
              const SizedBox(height: 16),
            ],
            Text(maxLabel, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            NumericTextField(
              initialValue: maxValue,
              maxLength: maxMaxValue.toString().length,
              onValueChanged: (value) {
                maxValueController.text = value.toString();
              },
            ),
            if (maxErrorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(maxErrorMessage, style: const TextStyle(color: Colors.red, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
