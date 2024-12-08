import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/home/storeVat/operation/model.dart';
import 'package:singleeat/screens/home/storeVat/operation/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class StoreVatNotifier extends _$StoreVatNotifier {
  @override
  StoreVatState build() {
    return const StoreVatState();
  }

  /// 매출 부가세 조회
  void getVatSalesInfo() async {
    final response = await ref
        .read(storeVatServiceProvider)
        .getVatSalesInfo(storeId: UserHive.getBox(key: UserKey.storeId));

    try {
      if (response.statusCode == 200) {
        final result = ResultResponseModel.fromJson(response.data);
        final storeVatSale = StoreVatSaleModel.fromJson(result.data);
        state = state.copyWith(
            storeVatSale: storeVatSale, error: const ResultFailResponseModel());
      } else {
        state = state.copyWith(
            status: StoreVatStatus.error,
            error: ResultFailResponseModel.fromJson(response.data));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getVatPurchasesInfo() async {
    final response = await ref
        .read(storeVatServiceProvider)
        .getVatPurchasesInfo(storeId: UserHive.getBox(key: UserKey.storeId));

    try {
      if (response.statusCode == 200) {
        final result = ResultResponseModel.fromJson(response.data);
        final storeVatPurchases = StoreVatPurchasesModel.fromJson(result.data);
        state = state.copyWith(
            storeVatPurchases: storeVatPurchases,
            error: const ResultFailResponseModel());
      } else {
        state = state.copyWith(
            status: StoreVatStatus.error,
            error: ResultFailResponseModel.fromJson(response.data));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> onChangeEndDate({required String endDate}) async {
    state = state.copyWith(endDate: endDate);
    getVatSalesInfo();
  }

  Future<void> onChangeMonth(
      {required String startDate, required String endDate}) async {
    state = state.copyWith(startDate: startDate, endDate: endDate);
    getVatSalesInfo();
  }

  Future<void> onChangeEmail({required String email}) async {
    state = state.copyWith(email: email);
  }

  void generateVatReport() async {
    final response = await ref.read(storeVatServiceProvider).generateVatReport(
        storeId: UserHive.getBox(key: UserKey.storeId),
        email: state.email,
        startDate: state.startDate,
        endDate: state.endDate);

    if (response.statusCode == 200) {
      state = state.copyWith(
          status: StoreVatStatus.success,
          error: const ResultFailResponseModel());

      ref.read(goRouterProvider).push(AppRoutes.vat);
    } else {
      state = state.copyWith(
          status: StoreVatStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum StoreVatStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreVatState with _$StoreVatState {
  const factory StoreVatState({
    @Default(StoreVatStatus.init) StoreVatStatus status,
    @Default('') String email,
    @Default('') String startDate,
    @Default('') String endDate,
    @Default(StoreVatSaleModel()) StoreVatSaleModel storeVatSale,
    @Default(StoreVatPurchasesModel()) StoreVatPurchasesModel storeVatPurchases,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreVatState;

  factory StoreVatState.fromJson(Map<String, dynamic> json) =>
      _$StoreVatStateFromJson(json);
}
