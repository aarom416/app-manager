import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/components/loading.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storesettlement/operation/model.dart';
import 'package:singleeat/screens/home/storesettlement/operation/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreSettlementNotifier extends _$StoreSettlementNotifier {
  @override
  StoreSettlementState build() {
    return const StoreSettlementState();
  }

  void getSettlementInfo(BuildContext context) async {
    try {
      Loading.show(context);
      final response = await ref
          .read(storeSettlementServiceProvider)
          .getSettlementInfo(
          storeId: UserHive.getBox(key: UserKey.storeId),
          startDate: state.startDate,
          endDate: state.endDate);
      if (response.statusCode == 200) {
        final result = ResultResponseModel.fromJson(response.data);
        final storeSettlement = StoreSettlementModel.fromJson(result.data);
        state = state.copyWith(
            storeSettlement: storeSettlement,
            error: const ResultFailResponseModel());
      } else {
        state = state.copyWith(
            status: StoreSettlementStatus.error,
            error: ResultFailResponseModel.fromJson(response.data));
      }
    } catch(e) {
    } finally {
      Loading.hide();
    }
  }

  Future<void> onChangeStartDate({required String startDate}) async {
    state = state.copyWith(startDate: startDate);
  }

  Future<void> onChangeEndDate({required BuildContext context, required String endDate}) async {
    state = state.copyWith(endDate: endDate);
    getSettlementInfo(context);
  }

  Future<void> onChangeMonth(
      {required BuildContext context, required String startDate, required String endDate}) async {
    state = state.copyWith(startDate: startDate, endDate: endDate);
    getSettlementInfo(context);
  }

  Future<void> onChangeEmail({required String email}) async {
    state = state.copyWith(email: email);
  }

  void generateSettlementReport() async {
    final response = await ref
        .read(storeSettlementServiceProvider)
        .generateSettlementReport(
            storeId: UserHive.getBox(key: UserKey.storeId),
            email: state.email,
            startDate: state.startDate,
            endDate: state.endDate);

    if (response.statusCode == 200) {
      state = state.copyWith(
          status: StoreSettlementStatus.success,
          error: const ResultFailResponseModel());

      ref.read(goRouterProvider).push(AppRoutes.settlement);
    } else {
      state = state.copyWith(
          status: StoreSettlementStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StoreSettlementStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreSettlementState with _$StoreSettlementState {
  const factory StoreSettlementState({
    @Default(StoreSettlementStatus.init) StoreSettlementStatus status,
    @Default('') String email,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default(StoreSettlementModel()) StoreSettlementModel storeSettlement,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreSettlementState;

  factory StoreSettlementState.fromJson(Map<String, dynamic> json) =>
      _$StoreSettlementStateFromJson(json);
}
