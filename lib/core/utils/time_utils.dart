/// 주어진 24시간 형식의 시간 문자열(예: "17:00")을 오전/오후가 포함된 12시간 형식의 문자열로 변환.
///
/// [time]: "HH:mm" 형식의 24시간 시간 문자열 (예: "17:00")
/// 반환값: 오전/오후와 함께 12시간 형식으로 변환된 문자열 (예: "오후 05:00")
///
/// ex:
/// ```dart
/// convert24HourTimeToAmPmWithHourMinute("17:00"); // "오후 05:00"
/// convert24HourTimeToAmPmWithHourMinute("09:30"); // "오전 09:30"
/// convert24HourTimeToAmPmWithHourMinute("00:15"); // "오전 12:15"
/// ```
String convert24HourTimeToAmPmWithHourMinute(String time) {
  final parts = time.split(':');
  if (parts.length != 2) {
    throw ArgumentError("올바른 HH:MM 형식의 시간을 입력해주세요.");
  }

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);

  if (hour == null ||
      minute == null ||
      hour < 0 ||
      hour > 24 ||
      minute < 0 ||
      minute > 59) {
    throw ArgumentError("시간은 00:00에서 23:59 사이여야 합니다.");
  }

  final amPm = hour < 12 ? "오전" : "오후";
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;

  return "$amPm $displayHour:${parts[1]}";
}

/// 주어진 시간(hour)을 오전/오후 형식과 함께 한국어 접미사("시")로 반환하는 함수
///
/// [hourString] - 한 자리 또는 두 자리 숫자로 된 시간 (예: "3", "03", "15").
///
/// - 0에서 11 사이의 시간은 "오전"으로 반환됩니다.
/// - 12에서 23 사이의 시간은 "오후"로 반환됩니다.
/// - 시간은 12시간제로 변환되며, "0"시가 아닌 "12"시로 표시됩니다.
///
/// 예제:
/// ```dart
/// formatHourToAmPmWithKoreanSuffix("3");  // "오전 3시"
/// formatHourToAmPmWithKoreanSuffix("03"); // "오전 3시"
/// formatHourToAmPmWithKoreanSuffix("15"); // "오후 3시"
/// ```
///
/// 예외:
/// - [ArgumentError]가 발생할 수 있는 경우:
///   - 입력이 숫자가 아닌 경우.
///   - 입력이 "0"에서 "23" 범위를 벗어나는 경우.
String formatHourToAmPmWithKoreanSuffix(String hour) {
  if (hour.isEmpty || int.tryParse(hour) == null) {
    throw ArgumentError("유효한 숫자 형식의 시간 값을 입력해야 합니다. 예: '03', '15'");
  }

  // 입력 값을 정수로 변환
  int hourInt = int.parse(hour);

  if (hourInt < 0 || hourInt > 23) {
    throw ArgumentError("시간 값은 0부터 23 사이의 값이어야 합니다. 입력된 값: $hourInt");
  }

  // 오전/오후 판단
  String period = hourInt < 12 ? "오전" : "오후";

  // 24시간 형식을 12시간 형식으로 변환 (0은 그대로 유지)
  int hourIn12HourFormat =
      hourInt == 0 ? 0 : (hourInt % 12 == 0 ? 12 : hourInt % 12);

  // 결과 문자열 반환
  return "$period $hourIn12HourFormat시";
}

// 해당 월의 첫날 반환
DateTime getFirstDayOfMonth(String yearMonth) {
  final parts = yearMonth.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  return DateTime(year, month, 1);
}

// 해당 월의 마지막날 반환
DateTime getLastDayOfMonth(String yearMonth) {
  final parts = yearMonth.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  return DateTime(year, month + 1, 0);
}

String getFirstDayOfMonthWithDateTime(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-01";
}

String getLastDayOfMonthWithDateTime(DateTime date) {
  final lastDay = DateTime(date.year, date.month + 1, 0);
  return "${lastDay.year}-${lastDay.month.toString().padLeft(2, '0')}-${lastDay.day.toString().padLeft(2, '0')}";
}
