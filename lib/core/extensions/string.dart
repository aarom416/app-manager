/// String 확장함수
extension StringExtensions on String {
  /// 금액 문자열에 포함된 콤마를 제거하고 int로 변환
  int get toIntFromCurrency {
    try {
      return int.parse(replaceAll(',', ''));
    } catch (e) {
      return 0; // 변환에 실패한 경우 기본값으로 0 반환
    }
  }

  /// 전화번호 포맷
  String get toPhoneNumberFormat {
    // 숫자만 남기기
    final numericString = replaceAll(RegExp(r'\D'), '');

    // 숫자의 길이에 따라 포맷 적용
    if (numericString.length == 10) {
      // 10자리 전화번호
      return '${numericString.substring(0, 3)}-${numericString.substring(3, 6)}-${numericString.substring(6)}';
    } else if (numericString.length == 11) {
      // 11자리 휴대전화번호
      return '${numericString.substring(0, 3)}-${numericString.substring(3, 7)}-${numericString.substring(7)}';
    } else {
      // 포맷 불가능한 경우 원래 문자열 반환
      return this;
    }
  }

  /// 전화번호 포맷
  String get toBizNumberFormat {
    // 숫자만 남기기
    final numericString = replaceAll(RegExp(r'\D'), '');

    // 숫자의 길이에 따라 포맷 적용
    if (numericString.length == 10) {
      // 10자리 전화번호
      return '${numericString.substring(0, 3)}-${numericString.substring(3, 5)}-${numericString.substring(5)}';
    } else {
      // 포맷 불가능한 경우 원래 문자열 반환
      return this;
    }
  }
}
