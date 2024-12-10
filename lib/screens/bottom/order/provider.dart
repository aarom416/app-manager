import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_list_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/bottom/myinfo/orderlist/model.dart';
import 'package:singleeat/screens/bottom/order/model.dart';
import 'package:singleeat/screens/bottom/order/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class OrderNotifier extends _$OrderNotifier {
  @override
  OrderState build() {
    return const OrderState();
  }

  /// 신규 주문 목록 조회
  void getNewOrderList() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response =
        await ref.read(orderServiceProvider).getNewOrderList(storeId: storeId);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);

      List<NewOrderModel> list = [];

      for (var item in result.data) {
        final newOrderModel = NewOrderModel.fromJson(item);
        list.add(newOrderModel);
      }
      state = state.copyWith(
          newOrderList: list, acceptOrderList: [], completeOrderList: []);
    } else {}
  }

  /// 접수 주문 목록 조회
  void getAcceptOrderList() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(orderServiceProvider)
        .getAcceptedOrderList(storeId: storeId);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);

      List<NewOrderModel> list = [];

      for (var item in result.data) {
        final acceptOrderModel = NewOrderModel.fromJson(item);
        list.add(acceptOrderModel);
      }
      state = state.copyWith(
          acceptOrderList: list, newOrderList: [], completeOrderList: []);
    } else {}
  }

  /// 완료 주문 목록 조회
  void getCompletedOrderList() async {
    final storeId = UserHive.getBox(key: UserKey.storeId);

    final response = await ref
        .read(orderServiceProvider)
        .getCompletedOrderList(storeId: storeId);

    if (response.statusCode == 200) {
      final result = ResultResponseListModel.fromJson(response.data);
      List<NewOrderModel> list = [];

      for (var item in result.data) {
        final completeOrderModel = NewOrderModel.fromJson(item);
        list.add(completeOrderModel);
      }
      state = state.copyWith(
          completeOrderList: list, newOrderList: [], acceptOrderList: []);
    } else {}
  }

  /// 신규 주문 상세
  Future<bool> getNewOrderDetail(int orderInformationId) async {
    final response = await ref
        .read(orderServiceProvider)
        .getNewOrderDetail(orderInformationId: orderInformationId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      final orderDetail = MyInfoOrderHistoryModel.fromJson(result.data);

      state = state.copyWith(
        orderDetail: orderDetail,
      );
      return true;
    } else {
      return false;
    }
  }

  /// 접수 주문 상세
  Future<bool> getAcceptedOrderDetail(int orderInformationId) async {
    final response = await ref
        .read(orderServiceProvider)
        .getAcceptedOrderDetail(orderInformationId: orderInformationId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      final orderDetail = MyInfoOrderHistoryModel.fromJson(result.data);

      state = state.copyWith(
        orderDetail: orderDetail,
      );
      return true;
    } else {
      return false;
    }
  }

  /// 완료 주문 상세
  Future<bool> getCompletedOrderDetail(int orderInformationId) async {
    final response = await ref
        .read(orderServiceProvider)
        .getCompletedOrderDetail(orderInformationId: orderInformationId);

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);

      final orderDetail = MyInfoOrderHistoryModel.fromJson(result.data);

      state = state.copyWith(
        orderDetail: orderDetail,
      );
      return true;
    } else {
      return false;
    }
  }

  /// 주문 접수
  Future<bool> acceptOrder(int orderInformationId, int cookTime) async {
    final storeId = UserHive.getBox(key: UserKey.storeId);
    final response = await ref.read(orderServiceProvider).acceptOrder(
        orderInformationId: orderInformationId,
        storeId: int.parse(storeId),
        cookTime: cookTime);

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
      return true;
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
      return false;
    }
  }

  /// 배달 주문 취소
  Future<bool> deliveryOrderCancel(
      int orderInformationId, int cancelReason) async {
    final storeId = UserHive.getBox(key: UserKey.storeId);
    final response = await ref.read(orderServiceProvider).deliveryOrderCancel(
          orderInformationId: orderInformationId,
          cancelReason: cancelReason,
        );

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
      return true;
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
      return false;
    }
  }

  /// 포장 주문 취소
  Future<bool> takeoutOrderCancel(
      int orderInformationId, int cancelReason) async {
    final storeId = UserHive.getBox(key: UserKey.storeId);
    final response = await ref.read(orderServiceProvider).takeoutOrderCancel(
          orderInformationId: orderInformationId,
          cancelReason: cancelReason,
        );

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
      return true;
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
      return false;
    }
  }

  /// 포장 주문 거절
  Future<bool> takeoutOrderReject(
      int orderInformationId, int rejectReason) async {
    final response = await ref.read(orderServiceProvider).takeoutOrderReject(
        orderInformationId: orderInformationId, rejectReason: rejectReason);

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
      return true;
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
      return false;
    }
  }

  /// 배달 주문 거절
  Future<bool> deliveryOrderReject(
      int orderInformationId, int rejectReason) async {
    final response = await ref.read(orderServiceProvider).deliveryOrderReject(
        orderInformationId: orderInformationId, rejectReason: rejectReason);

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
      return true;
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
      return false;
    }
  }

  /// 배달 완료 알림 보내기
  Future<void> notifyDeliveryComplete(int orderInformationId) async {
    final response = await ref
        .read(orderServiceProvider)
        .notifyDeliveryComplete(orderInformationId: orderInformationId);

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
    }
  }

  /// 배달 주문 거절
  Future<void> notifyCookingComplete(int orderInformationId) async {
    final response = await ref
        .read(orderServiceProvider)
        .notifyCookingComplete(orderInformationId: orderInformationId);

    if (response.statusCode == 200) {
      state = state.copyWith(
        status: OrderServiceStatus.success,
      );
    } else {
      state = state.copyWith(
        status: OrderServiceStatus.error,
      );
    }
  }
}

enum OrderServiceStatus {
  init,
  success,
  error,
}

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState({
    @Default(OrderServiceStatus.init) OrderServiceStatus status,
    @Default([]) List<NewOrderModel> newOrderList,
    @Default(MyInfoOrderHistoryModel()) MyInfoOrderHistoryModel orderDetail,
    @Default([]) List<NewOrderModel> acceptOrderList,
    @Default([]) List<NewOrderModel> completeOrderList,
    @Default(0) int pageNumber,
    @Default('0') String filter,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _OrderState;

  factory OrderState.fromJson(Map<String, dynamic> json) =>
      _$OrderStateFromJson(json);
}
