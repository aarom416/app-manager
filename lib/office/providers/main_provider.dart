import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/home_model.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/services/main_service.dart';

part 'main_provider.freezed.dart';
part 'main_provider.g.dart';

@Riverpod(keepAlive: true)
class MainNotifier extends _$MainNotifier {
  @override
  MainState build() {
    return const MainState();
  }

  void ownerHome() async {
    final response = await ref.read(mainServiceProvider).ownerHome();

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final home = HomeModel.fromJson(result.data);
      state = state.copyWith(
        result: home,
        operationStatus: home.operationStatus,
      );

      UserHive.setBox(
          key: UserKey.storeId, value: state.result.storeId.toString());
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void onChangeOperationStatus(int operationStatus) async {
    final response = await ref.read(mainServiceProvider).operationStatus(
        storeId: UserHive.getBox(key: UserKey.storeId),
        operationStatus: operationStatus);

    if (response.statusCode == 200) {
      state = state.copyWith(
          error: const ResultFailResponseModel(),
          operationStatus: operationStatus);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum MainStatus {
  init,
  success,
  error,
}

@freezed
abstract class MainState with _$MainState {
  const factory MainState({
    @Default(MainStatus.init) MainStatus status,
    @Default(HomeModel()) HomeModel result,
    @Default(0) int operationStatus,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MainState;

  factory MainState.fromJson(Map<String, dynamic> json) =>
      _$MainStateFromJson(json);
}
