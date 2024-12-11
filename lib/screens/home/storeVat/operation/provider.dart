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

  void clear() {
    state = build();
  }

  void getVat(String type) {
    if (type == '매출') {
      getVatSalesInfo();
    } else {
      getVatPurchasesInfo();
    }
  }

  /// 매출 부가세 조회
  void getVatSalesInfo() async {
    final queryParameters = {
      'startDateString': state.startDate,
      'endDateString': state.endDate,
    };

    final response = await ref.read(storeVatServiceProvider).getVatSalesInfo(
          storeId: UserHive.getBox(key: UserKey.storeId),
          queryParameters: queryParameters,
        );

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
    final queryParameters = {
      'startDateString': state.startDate,
      'endDateString': state.endDate,
    };

    final response =
        await ref.read(storeVatServiceProvider).getVatPurchasesInfo(
              storeId: UserHive.getBox(key: UserKey.storeId),
              queryParameters: queryParameters,
            );

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

  void generateVatReport() async {
    final searchMonth =
        '${DateTime.parse(state.startDate).year}-${DateTime.parse(state.startDate).month.toString().padLeft(2, '0')}';

    final request = {
      'storeId': UserHive.getBox(key: UserKey.storeId),
      'email': state.email,
      if (state.currentDateRangeType == '월별') 'searchMonth': searchMonth,
      'searchStartDate': state.startDate,
      'searchEndDate': state.endDate,
    };

    final response = await ref
        .read(storeVatServiceProvider)
        .generateVatReport(data: request);

    if (response.statusCode == 200) {
      state = state.copyWith(
          status: StoreVatStatus.success,
          error: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          status: StoreVatStatus.error,
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeCurrentDateRangeType(String currentDateRangeType) {
    state = state.copyWith(currentDateRangeType: currentDateRangeType);
  }

  void onChangeStartDate({required String startDate}) {
    state = state.copyWith(startDate: startDate);
  }

  void onChangeEndDate({required String endDate}) {
    state = state.copyWith(endDate: endDate);
  }

  void onChangeEmail({required String email}) {
    state = state.copyWith(email: email);
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
    @Default('월별') String currentDateRangeType,
    @Default(StoreVatSaleModel()) StoreVatSaleModel storeVatSale,
    @Default(StoreVatPurchasesModel()) StoreVatPurchasesModel storeVatPurchases,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreVatState;

  factory StoreVatState.fromJson(Map<String, dynamic> json) =>
      _$StoreVatStateFromJson(json);
}
