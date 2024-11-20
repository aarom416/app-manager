import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_info_model.freezed.dart';
part 'store_info_model.g.dart';

enum StoreInfoStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreInfoModel with _$StoreInfoModel {
  const factory StoreInfoModel({
    @Default(0) int storeId,
    @Default('') String thumbnail,
    @Default('') String name,
    @Default('') String storeNum,
    @Default('') String brand,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String storePictureURL1,
    @Default('') String storePictureURL2,
    @Default('') String storePictureURL3,
    @Default('') String introduction,
    @Default('') String storeInformationURL,
    @Default('') String originInformation,
  }) = _StoreInfoModel;

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoModelFromJson(json);
}
