
import 'package:intl/intl.dart';

/// int 확장함수
extension CurrencyFormatting on int {

  /// 콤마가 붙은 숫자단위 문자열로 변환
  String get toStringAsCurrency {
    final formatter = NumberFormat('#,###');
    return formatter.format(this);
  }
}
