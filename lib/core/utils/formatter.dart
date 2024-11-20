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
      value.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      bool isLastOffset = newValue.selection.end == newValue.text.length;
      int currentOffset = newValue.selection.end;
      return TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(
            offset: isLastOffset ? formattedValue.length : currentOffset),
      );
    }
    return oldValue;
  });
}

String formatDate(String date) {
  if (date == '') return date;

  // 문자열을 DateTime 형식으로 변환
  DateTime parsedDate = DateTime.parse(
    '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)} '
        '${date.substring(8, 10)}:${date.substring(10, 12)}:${date.substring(
        12, 14)}',
  );

  // DateTime 객체를 문자열로 변환
  String formattedDate =
      "${parsedDate.year}.${parsedDate.month.toString().padLeft(
      2, '0')}.${parsedDate.day.toString().padLeft(2, '0')} ${parsedDate.hour
      .toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(
      2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";

  return formattedDate;
}