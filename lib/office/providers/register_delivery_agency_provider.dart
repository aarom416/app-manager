import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'register_delivery_agency_provider.freezed.dart';
part 'register_delivery_agency_provider.g.dart';

@Riverpod(keepAlive: true)
class RegisterDeliveryAgencyNotifier extends _$RegisterDeliveryAgencyNotifier {
  @override
  RegisterDeliveryAgencyState build() {
    return const RegisterDeliveryAgencyState();
  }
}

enum RegisterDeliveryAgencyStatus {
  init,
  success,
  error,
}

@freezed
abstract class RegisterDeliveryAgencyState with _$RegisterDeliveryAgencyState {
  const factory RegisterDeliveryAgencyState({
    @Default(RegisterDeliveryAgencyStatus.init)
    RegisterDeliveryAgencyStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _RegisterDeliveryAgencyState;

  factory RegisterDeliveryAgencyState.fromJson(Map<String, dynamic> json) =>
      _$RegisterDeliveryAgencyStateFromJson(json);
}
