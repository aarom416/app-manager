enum OrderStatus { newOrder, inProgress, completed, cancelled }

class OrderModel {
  int id;
  final String orderName;
  final int price;
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
      this.orderType = "포장",
      this.estimationTime = 30,
      this.elapsedTime = 30});
}
