import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/screens/bottom/myinfo/accountstatus/checkpassword/service.dart';

part 'provider.freezed.dart';
part 'provider.g.dart';

@Riverpod(keepAlive: true)
class MyInfoCheckPasswordNotifier extends _$MyInfoCheckPasswordNotifier {
  @override
  MyInfoCheckPasswordState build() {
    return const MyInfoCheckPasswordState();
  }

  Future<bool> checkPassword(String password) async {
    final response = await ref
        .read(myInfoCheckPasswordServiceProvider)
        .checkPassword(password: password);

    final result = ResultResponseModel.fromJson(response.data);
    if (response.statusCode == 200) {
      state = state.copyWith(success: result.success);
      ref.read(goRouterProvider).push(AppRoutes.changePassword);
      return true;
    } else {
      final result = ResultResponseModel.fromJson(response.data);
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data),
          success: result.success);
      return false;
    }
  }
}

enum MyInfoOrderHistoryStatus {
  init,
  success,
  error,
}

@freezed
abstract class MyInfoCheckPasswordState with _$MyInfoCheckPasswordState {
  const factory MyInfoCheckPasswordState({
    @Default(MyInfoOrderHistoryStatus.init) MyInfoOrderHistoryStatus status,
    @Default(false) bool success,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _MyInfoCheckPasswordState;

  factory MyInfoCheckPasswordState.fromJson(Map<String, dynamic> json) =>
      _$MyInfoCheckPasswordStateFromJson(json);
}
