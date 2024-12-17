import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/office/models/home_model.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/services/main_service.dart';

part 'home_provider.freezed.dart';
part 'home_provider.g.dart';

@Riverpod(keepAlive: true)
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    return const HomeState();
  }

  void onChangeSelectedIndex(int selectedIndex) {
    state = state.copyWith(selectedIndex: selectedIndex);
  }
}

enum HomeStatus {
  init,
  success,
  error,
}

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(1) int selectedIndex,
    @Default(HomeStatus.init) HomeStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}
