import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/utils/file.dart';
import 'package:singleeat/office/models/result_fail_response_model.dart';
import 'package:singleeat/office/models/result_response_model.dart';
import 'package:singleeat/office/models/user_model.dart';
import 'package:singleeat/office/providers/webview_provider.dart';
import 'package:singleeat/office/services/signup_service.dart';

part 'signup_provider.freezed.dart';
part 'signup_provider.g.dart';

@Riverpod(keepAlive: true)
class SignupNotifier extends _$SignupNotifier {
  @override
  SignupState build() {
    return const SignupState();
  }

  void onChangeStatus(SignupStatus status) {
    state = state.copyWith(status: status);
  }

  void onChangeLoginId(String loginId) {
    state = state.copyWith(loginId: loginId, loginIdValid: false);
  }

  void onChangePassword(String password) {
    state = state.copyWith(password: password);
  }

  void onChangeAuthCode(String authCode) {
    state = state.copyWith(authCode: authCode);
  }

  void onChangePasswordConfirm(String passwordConfirm) {
    state = state.copyWith(passwordConfirm: passwordConfirm);
  }

  void onChangeEmail(String email) {
    state = state.copyWith(email: email);
  }

  void onChangeDomain(String domain) {
    state = state.copyWith(domain: domain);
  }

  void onChangeIsSingleeatAgree(bool isSingleeatAgree) {
    state = state.copyWith(isSingleeatAgree: isSingleeatAgree);
  }

  void onChangeIsAdditionalAgree(bool isAdditionalAgree) {
    state = state.copyWith(isAdditionalAgree: isAdditionalAgree);
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

  void loginIdValidation() {
    // 정규식: 8~16자의 영문, 숫자, 특수 문자 포함
    final regExp = RegExp(r'^[A-Za-z0-9]{6,12}$');
    if (state.loginId.isEmpty || !regExp.hasMatch(state.loginId)) {
      state = state.copyWith(
          loginIdError: const ResultFailResponseModel(
              errorMessage: '6~12자 이내, 영문, 숫자만 사용 가능합니다'));
    } else {
      state = state.copyWith(loginIdError: const ResultFailResponseModel());
    }
  }

  void passwordValidation() {
    final regExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,16}$');
    if (!regExp.hasMatch(state.password)) {
      state = state.copyWith(
          passwordError: const ResultFailResponseModel(
              errorMessage: '8~16자의 영문, 숫자, 특수문자를 포함해주세요'));
    } else {
      state = state.copyWith(passwordError: const ResultFailResponseModel());
    }
  }

  void passwordConfirmValidation() {
    if (state.password == state.passwordConfirm) {
      state =
          state.copyWith(passwordValidError: const ResultFailResponseModel());
    } else {
      state = state.copyWith(
          passwordValidError:
              const ResultFailResponseModel(errorMessage: '비밀번호가 일치하지 않습니다.'));
    }
  }

  void checkLoginId() async {
    loginIdValidation();

    if (state.loginIdError.errorMessage.isNotEmpty) {
      return;
    }

    final response = await ref
        .read(signupServiceProvider)
        .checkLoginId(loginId: state.loginId);

    if (response.statusCode == 200) {
      state = state.copyWith(
        loginIdValid: true,
        loginIdError: const ResultFailResponseModel(),
      );
    } else {
      final error = ResultFailResponseModel.fromJson(response.data);
      state = state.copyWith(
        loginIdError: error.copyWith(errorMessage: '이미 존재하는 아이디입니다.'),
      );
    }
  }

  void sendCode() async {
    final response = await ref
        .read(signupServiceProvider)
        .sendCode(email: '${state.email}@${state.domain}');

    if (response.statusCode == 200) {
      state = state.copyWith(
        emailStatus: SignupEmailStatus.push,
        isSendCode: true,
        error: const ResultFailResponseModel(),
      );
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void verifyCode() async {
    final response = await ref.read(signupServiceProvider).verifyCode(
        email: '${state.email}@${state.domain}', authCode: state.authCode);

    if (response.statusCode == 200) {
      state = state.copyWith(emailStatus: SignupEmailStatus.success);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void signUp() async {
    final response = await ref.read(signupServiceProvider).signUp({
      'identityVerificationId':
          ref.read(webViewNotifierProvider).identityVerificationId,
      'loginId': state.loginId,
      'password': state.password,
      'email': '${state.email}@${state.domain}',
    });

    if (response.statusCode == 200) {
      final result = ResultResponseModel.fromJson(response.data);
      final user = UserModel.fromJson(result.data);
      UserHive.set(user: user.copyWith(status: UserStatus.notEntry));

      state = state.copyWith(status: SignupStatus.step3);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  void changeStatus() async {
    Response response = await ref
        .read(signupServiceProvider)
        .singleatResearchStatus({'status': (state.isSingleeatAgree) ? 1 : 0});

    if (response.statusCode != 200) {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
      return;
    }

    response = await ref
        .read(signupServiceProvider)
        .additionalServiceStatus({'status': (state.isAdditionalAgree) ? 1 : 0});

    if (response.statusCode == 200) {
      state = state.copyWith(status: SignupStatus.step4);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }

  Future<bool> checkBusinessNumber() async {
    final response = await ref
        .read(signupServiceProvider)
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
    });

    if (state.businessPermitPicture != null) {
      formData.files.add(MapEntry(
        'businessPermitPicture',
        await MultipartFile.fromFile(state.businessPermitPicture!.path,
            filename: state.businessPermitPicture!.name),
      ));
    }

    final response =
        await ref.read(signupServiceProvider).enroll(formData: formData);
    if (response.statusCode == 200) {
      UserHive.set(user: UserHive.get().copyWith(status: UserStatus.wait));
      state = state.copyWith(status: SignupStatus.step5);
    } else {
      state = state.copyWith(
          error: ResultFailResponseModel.fromJson(response.data));
    }
  }
}

enum SignupStatus {
  step1,
  step2,
  step3,
  step4,
  step5,
  error,
}

enum SignupEmailStatus {
  init,
  push,
  success,
  error,
}

@freezed
abstract class SignupState with _$SignupState {
  const factory SignupState({
    @Default(SignupStatus.step1) SignupStatus status,
    @Default(SignupEmailStatus.init) SignupEmailStatus emailStatus,
    @Default('') String loginId,
    @Default('') String password,
    @Default('') String passwordConfirm,
    @Default('') String email,
    @Default('') String domain,
    @Default('') String authCode,
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
    @Default(false) bool isSendCode,
    @Default(false) bool loginIdValid,
    @Default(false) bool isSingleeatAgree,
    @Default(false) bool isAdditionalAgree,
    @Default(false) bool isBusinessNumber,
    @Default(ResultFailResponseModel()) ResultFailResponseModel error,
    @Default(ResultFailResponseModel()) ResultFailResponseModel loginIdError,
    @Default(ResultFailResponseModel()) ResultFailResponseModel passwordError,
    @Default(ResultFailResponseModel())
    ResultFailResponseModel passwordValidError,
  }) = _SignupState;
}
