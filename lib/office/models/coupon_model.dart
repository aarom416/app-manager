enum CouponDiscountType {
  percentage,
  fixed;

  String get labelName => switch (this) {
        percentage => "~% 할인",
        fixed => "~원 할인",
      };
}

enum CouponExpirationType {
  d3,
  w1,
  w3,
  m1,
  m3;

  String get labelName => switch (this) {
        d3 => "3일",
        w1 => "1주",
        w3 => "3주",
        m1 => "1개월",
        m3 => "3개월",
      };
}

enum OrderType {
  delivery,
  takeout,
  all;

  String get labelName => switch (this) {
        delivery => "배달",
        takeout => "포장",
        all => "전체",
      };
}

class CouponModel {
  final String id;
  final String name;
  final CouponDiscountType discountType;
  final int discountAmount;
  final int minimumOrderAmount;
  final int maximumDiscountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final CouponExpirationType expirationType;
  final OrderType orderType;

  CouponModel({
    required this.id,
    required this.name,
    required this.discountType,
    required this.discountAmount,
    required this.minimumOrderAmount,
    required this.maximumDiscountAmount,
    required this.startDate,
    required this.endDate,
    required this.expirationType,
    required this.orderType,
  });
}
