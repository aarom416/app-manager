class SettlementModel {
  final String from;
  final String settlementType;
  final DateTime createdAt;
  final DateTime settlementStartAt;
  final DateTime settlementEndAt;
  final int amount;
  final int deliveryFee;
  final int commissionFee;
  final int settlementFee;
  final int tax;

  int get totalAmount => amount + deliveryFee - settlementFee - commissionFee - tax;

  SettlementModel({
    required this.from,
    required this.settlementType,
    required this.createdAt,
    required this.settlementStartAt,
    required this.settlementEndAt,
    required this.amount,
    required this.deliveryFee,
    required this.settlementFee,
    required this.commissionFee,
    required this.tax,
  });
}
