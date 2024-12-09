extension DateTimeExtension on DateTime {
  String get weekDay {
    return this.weekday == 1
        ? "월"
        : this.weekday == 2
            ? "화"
            : this.weekday == 3
                ? "수"
                : this.weekday == 4
                    ? "목"
                    : this.weekday == 5
                        ? "금"
                        : this.weekday == 6
                            ? "토"
                            : "일";
  }

  String get koreanDateFormat {
    return "$year년 $month월 $day일";
  }

  String get toFullDateTimeString {
    return "$year년 $month월 $day일 ($weekDay) ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
  }

  String get toShortDateTimeString {
    return "$year. ${month.toString().padLeft(2, '0')}. ${day.toString().padLeft(2, '0')}";
  }

  String get toShortDateStringWithoutZeroPadding {
    return "$year. $month. $day";
  }

  String get toShortDateStringWithZeroPadding {
    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  String get toShortTimeString {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}
