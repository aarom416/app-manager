import 'package:flutter/services.dart';

TextInputFormatter comparableNumericInputFormatter(int? maximumAmount) {
  return TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.isEmpty) {
      return oldValue;
    }

    int value = int.parse(newValue.text.replaceAll(",", ""));
    if (value == 0) {
      if (newValue.text.length != 1) {
        return oldValue;
      }
      return newValue;
    }

    if (value <= maximumAmount!) {
      String formattedValue =
          value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      bool isLastOffset = newValue.selection.end == newValue.text.length;
      int currentOffset = newValue.selection.end;
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: isLastOffset ? formattedValue.length : currentOffset),
      );
    }
    return oldValue;
  });
}
