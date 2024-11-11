import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/utils/file.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/user_model.dart';
import 'package:singleeat/office/services/store_registration_form_service.dart';

part 'store_registration_form_provider.freezed.dart';

part 'store_registration_form_provider.g.dart';

@Riverpod(keepAlive: true)
class StoreRegistrationFormNotifier extends _$StoreRegistrationFormNotifier {
  @override
  StoreRegistrationFormState build() {
    return const StoreRegistrationFormState();
  }

  void onChangeBusinessNumber(String businessNumber) {
    state = state.copyWith(businessNumber: businessNumber);
  }

  void onChangeCeoName(String ceoName) {
    state = state.copyWith(ceoName: ceoName);
  }

  void onChangeStoreName(String storeName) {
    state = state.copyWith(storeName: storeName);
  }

  void onChangeAddress(String address) {
    state = state.copyWith(address: address);
  }

  void onChangePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void onChangeCategory(List<String> categories) {
    /*
    브랜드 카테고리
      0 : 샐러드
      1 : 포케
      2 : 샌드위치
      3 : 카페
      4 : 베이커리
      5 : 버거
      중복 가능합니다.
      예를 들어 샌드위치, 카페, 베이커리 인 경우 '234' 입니다.
     */
    String category = categories.join();
    category = category.replaceAll('샐러드', '0');
    category = category.replaceAll('포케', '1');
    category = category.replaceAll('샌드위치', '2');
    category = category.replaceAll('카페', '3');
    category = category.replaceAll('베이커리', '4');
    category = category.replaceAll('버거', '5');

    // 0~5 정렬
    List<String> sortedCategoryList = category.split('')..sort();
    state = state.copyWith(category: sortedCategoryList.join());
  }

  void onChangeBusinessType(String businessType) {
    /*
    사업자 구분
      0 : 일반 과세자
      1 : 간이 과세자
      2 : 법인 과세자
      3 : 부가가치세 면세 사업자
      4 : 면세법인 사업자
     */

    switch (businessType) {
      case '일반 과세자':
        state = state.copyWith(businessType: 0);
        break;
      case '간이 과세자':
        state = state.copyWith(businessType: 1);
        break;
      case '법인 과세자':
        state = state.copyWith(businessType: 2);
        break;
      case '부가가치세 면세 사업자':
        state = state.copyWith(businessType: 3);
        break;
      case '면세 법인 사업자':
        state = state.copyWith(businessType: 4);
        break;
    }
  }

  Future<String> onChangeAccountPicture() async {
    final image = await pickImage();
    state = state.copyWith(accountPicture: image);
    return await checkFile(image);
  }

  Future<String> onChangeBusinessRegistrationPicture() async {
    final image = await pickImage();
    state = state.copyWith(businessRegistrationPicture: image);
    return await checkFile(image);
  }

  Future<String> onChangeBusinessPermitPicture() async {
    final image = await pickImage();
    state = state.copyWith(businessPermitPicture: image);
    return await checkFile(image);
  }

  Future<bool> checkBusinessNumber() async {
    final response = await ref
        .read(storeRegistrationFormServiceProvider)
        .checkBusinessNumber(state.businessNumber);

    if (response.statusCode == 200) {
      state = state.copyWith(isBusinessNumber: true);
      return true;
    } else {
      state = state.copyWith(
          isBusinessNumber: false,
          error: ResultFailResponseModel.fromJson(response.data));
    }

    return false;
  }

  void enroll() async {
    final formData = FormData.fromMap({
      'businessNumber': state.businessNumber,
      'ceoName': state.ceoName,
      'storeName': state.storeName,
      'address': state.address,
      'phone': state.phone,
      'category': state.category,
      'businessType': state.businessType,
      'accountPicture': await MultipartFile.fromFile(state.accountPicture!.path,
          filename: state.accountPicture!.name),
      'businessRegistrationPicture': await MultipartFile.fromFile(
          state.businessRegistrationPicture!.path,
          filename: state.businessRegistrationPicture!.name),
      'businessPermitPicture': await MultipartFile.fromFile(
          state.businessPermitPicture!.path,
          filename: state.businessPermitPicture!.name),
    });

    final response = await ref
        .read(storeRegistrationFormServiceProvider)
        .enroll(formData: formData);
    if (response.statusCode == 200) {
      UserHive.set(user: UserHive.get().copyWith(status: UserStatus.wait));
      state = state.copyWith(status: StoreRegistrationFormStatus.success);
    } else {
      state = state.copyWith(
        error: ResultFailResponseModel.fromJson(response.data),
      );
    }
  }
}

enum StoreRegistrationFormStatus {
  init,
  success,
  error,
}

@freezed
abstract class StoreRegistrationFormState with _$StoreRegistrationFormState {
  const factory StoreRegistrationFormState({
    @Default(StoreRegistrationFormStatus.init)
    StoreRegistrationFormStatus status,
    @Default(false) bool isBusinessNumber,
    @Default('') String businessNumber,
    @Default('') String ceoName,
    @Default('') String storeName,
    @Default('') String address,
    @Default('') String phone,
    @Default('') String category,
    @Default(0) int businessType,
    XFile? businessRegistrationPicture, // string($binary)
    XFile? businessPermitPicture, // string($binary)
    XFile? accountPicture, // string($binary)
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
  }) = _StoreRegistrationFormState;
}
