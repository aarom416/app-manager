
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/extensions/string.dart';

import '../../../core/components/sizing.dart';
import '../../../core/components/spacing.dart';
import '../../../core/constants/colors.dart';

/// 금액 입력 필드
class NumericTextField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(int) onValueChanged;
  final String hintText;
  final int maxLength;

  const NumericTextField({
    super.key,
    required this.controller,
    required this.onValueChanged,
    this.hintText = '',
    this.maxLength = 10, // 기본 최대 입력 길이
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: SGColors.black, fontSize: FontSize.small, fontWeight: FontWeight.w500),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: SGColors.gray4),
        contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
        border: const OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none),
      ),
      onChanged: (input) {
        // 숫자 형식으로 변환
        String numericValue = input.replaceAll(',', '');
        if (numericValue.startsWith('0')) {
          numericValue = numericValue.substring(1);
        }

        // 포맷팅된 값으로 컨트롤러 업데이트
        String formattedValue = int.tryParse(numericValue)?.toKoreanCurrency ?? '';
        controller.text = formattedValue;
        controller.selection = TextSelection.collapsed(offset: formattedValue.length);

        // 값 저장 콜백 호출
        onValueChanged(numericValue.toIntFromCurrency);
      },
    );
  }
}
