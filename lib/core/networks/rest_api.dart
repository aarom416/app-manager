class RestApiUri {
  static const String applicationJson = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
  static const String applicationXWwwFormUrlencoded =
      'application/x-www-form-urlencoded';

  static const String host = 'https://singleatapp.com:444';
  static const String sendCode = '/api/v1/owner/auth/sign-up/send-code';
  static const String verifyCode = '/api/v1/owner/auth/sign-up/verify-code';
  static const String signUp = '/api/v1/owner/auth/sign-up';
  static const String enroll = '/api/v1/owner/enroll';
  static const String singleatResearchStatus =
      '/api/v1/owner/singleat-research-status';
  static const String additionalServiceStatus =
      '/api/v1/owner/additional-service-status';
  static const String directLogin = '/api/v1/owner/auth/login/direct-login';
  static const String checkBusinessNumber =
      '/api/v1/owner/enroll/check-business-registration-number/{businessRegistrationNumber}';
  static const String checkLoginId =
      '/api/v1/owner/auth/sign-up/check-loginId/{loginId}';
  static const String findPassword = '/api/v1/owner/auth/sign-up/find-password';
  static const String identityVerification =
      '/owner/pages/identity-verification';
  static const String verifyPhone =
      '/api/v1/owner/auth/direct-login/verify-phone';
  static const String fcmToken = '/api/v1/owner/notification/push/fcm-token';
  static const String logout = '/api/v1/owner/logout';
  static const String updatePassword =
      '/api/v1/owner/auth/sign-up/update-password';
}
