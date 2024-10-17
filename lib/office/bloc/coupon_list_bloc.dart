import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:singleeat/office/models/coupon_model.dart';

sealed class CouponListEvent {}

class AddCoupon extends CouponListEvent {
  CouponModel coupon;

  AddCoupon(this.coupon);
}

class DeleteCoupon extends CouponListEvent {
  final String couponId;

  DeleteCoupon(this.couponId);
}

class CouponListState {
  final List<CouponModel> coupons;

  CouponListState({this.coupons = const []});

  copyWith({List<CouponModel>? coupons}) {
    return CouponListState(coupons: coupons ?? this.coupons);
  }
}

class CouponListBloc extends Bloc<CouponListEvent, CouponListState> {
  CouponListBloc() : super(CouponListState()) {
    on<AddCoupon>(_addCoupon);
    on<DeleteCoupon>(_deleteCoupon);
  }

  Future<void> _addCoupon(AddCoupon event, Emitter<CouponListState> emit) async {
    emit(state.copyWith(coupons: [...state.coupons, event.coupon]));
  }

  Future<void> _deleteCoupon(DeleteCoupon event, Emitter<CouponListState> emit) async {
    emit(state.copyWith(coupons: state.coupons.where((coupon) => coupon.id != event.couponId).toList()));
  }
}
