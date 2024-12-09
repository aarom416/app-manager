

import 'dart:convert';

extension DynamicExtensions on dynamic {
  /// JSON 데이터를 예쁘게 포맷하거나 문자열로 변환
  String toFormattedJson({String indent = '  '}) {
    try {
      final encoder = JsonEncoder.withIndent(indent);
      return encoder.convert(this);
    } catch (e) {
      return toString();
    }
  }
}

