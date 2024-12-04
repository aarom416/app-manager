enum OrderStatus {
  deliveryAccept('deliveryAccept', '배달 접수'),
  takeoutAccept('takeoutAccept', '포장 접수'),
  cancelled('cancelled', '주문 취소'),
  inProgress('inProgress', ''),
  completed('completed', ''),
  newOrder('newOrder', '');

  const OrderStatus(this.orderStatus, this.orderStatusName);
  final String orderStatus;
  final String orderStatusName;
}

class OrderModel {
  int id;
  final String orderName;
  final int price;
  final String receiveFoodType;
  final String orderType;
  final OrderStatus status;
  final DateTime orderTime;

  int estimationTime;
  int elapsedTime;

  OrderModel(
      {this.id = 0,
      required this.orderName,
      required this.price,
      required this.status,
      required this.orderTime,
      this.receiveFoodType = "DELIVERY",
      this.orderType = "DELIVERY",
      this.estimationTime = 30,
      this.elapsedTime = 30});
}
