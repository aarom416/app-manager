import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

enum StoreInformationStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreInformationModel with _$StoreInformationModel {
  const factory StoreInformationModel({
    @Default('') String ownerPhoneNumber, // 휴대폰 번호
    @Default('') String ownerEmail, // 이메일
    @Default('') String representativeType, // 대표자 구분
    @Default('') String businessName, // 사업자 이름
    @Default('') String businessNumber, // 사업자등록번호
    @Default('') String taxReportingInformation, // 세금신고자료 발행정보
    @Default('') String salesScaleClassification, // 매출 규모 분류
    @Default('') String businessType, // 사업자 구분
    @Default('') String businessActivityStatus, // 업태
    @Default('') String businessCategory, // 종목
    @Default('') String postalCode, // 우편번호
    @Default('') String baseAddress, // 기본 주소
    @Default('') String lotAddress, // 지번 주소
    @Default('') String detailAddress, // 상세 주소
    @Default('') String businessRegistrationNumber, // 영업신고증 고유번호
    @Default('') String ceoName, // 대표자명
    @Default('') String storeName, // 영업소 명칭
    @Default('') String operationType, // 영업의 종류
    @Default('') String ecommerceRegistrationInformation, // 통신판매신고증 정보
  }) = _StoreInformationModel;

  factory StoreInformationModel.fromJson(Map<String, dynamic> json) =>
      _$StoreInformationModelFromJson(json);
}
