import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';

part 'delivery_agency_provider.freezed.dart';
part 'delivery_agency_provider.g.dart';

@Riverpod(keepAlive: true)
class DeliveryAgencyNotifier extends _$DeliveryAgencyNotifier {
  @override
  DeliveryAgencyState build() {
    return const DeliveryAgencyState();
  }
}

enum DeliveryAgencyStatus {
  init,
  success,
  error,
}

@freezed
abstract class DeliveryAgencyState with _$DeliveryAgencyState {
  const factory DeliveryAgencyState({
    @Default(DeliveryAgencyStatus.init) DeliveryAgencyStatus status,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _DeliveryAgencyState;

  factory DeliveryAgencyState.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAgencyStateFromJson(json);
}
