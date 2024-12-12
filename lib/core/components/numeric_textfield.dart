import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/core/extensions/string.dart';

import 'sizing.dart';
import 'spacing.dart';
import '../constants/colors.dart';

/// 금액 입력 필드. 입력시 자동 콤마 추가.
class NumericTextField extends StatefulWidget {
  final void Function(int) onValueChanged;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int maxLength;
  final int? initialValue;
  final TextEditingController? controller;

  const NumericTextField({
    super.key,
    required this.onValueChanged,
    this.style,
    this.decoration,
    this.maxLength = 10, // 기본 최대 입력 길이
    this.initialValue,
    this.controller,
  });

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  late TextEditingController _internalController; // 내부 컨트롤러

  TextEditingController get _controller =>
      widget.controller ?? _internalController; // 외부 컨트롤러 우선 사용

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(
        text: widget.initialValue?.toKoreanCurrency ?? '',
      );
    } else if (widget.initialValue != null) {
      widget.controller!.text = widget.initialValue!.toKoreanCurrency;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose(); // 내부 컨트롤러 해제
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: widget.style ??
          TextStyle(
            color: SGColors.black,
            fontSize: FontSize.small,
            fontWeight: FontWeight.w500,
          ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: widget.decoration ??
          InputDecoration(
            hintStyle: TextStyle(color: SGColors.gray4),
            contentPadding: EdgeInsets.all(SGSpacing.p4).copyWith(right: 0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
          ),
      onChanged: (input) {
        // 숫자 형식으로 변환
        String numericValue = input.replaceAll(',', '');
        if (numericValue.startsWith('0')) {
          numericValue = numericValue.substring(1);
        }

        // 포맷팅된 값으로 컨트롤러 업데이트
        String formattedValue = int.tryParse(numericValue)?.toKoreanCurrency ?? '';
        _controller.text = formattedValue;
        _controller.selection = TextSelection.collapsed(offset: formattedValue.length);

        widget.onValueChanged(numericValue.toIntFromCurrency);
      },
    );
  }
}
