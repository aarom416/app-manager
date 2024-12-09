
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
}