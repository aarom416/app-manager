class RestApiUri {
  static const String applicationJson = 'application/json';
  static const String applicationXWwwFormUrlencoded =
      'application/x-www-form-urlencoded';

  static const String host = 'https://singleatapp.com:444';
  static const String sendCode = '/api/v1/owner/auth/sign-up/send-code';
  static const String verifyCode = '/api/v1/owner/auth/sign-up/verify-code';
  static const String signUp = '/api/v1/owner/auth/sign-up';
  static const String singleatResearchStatus =
      '/api/v1/owner/singleat-research-status';
  static const String additionalServiceStatus =
      '/api/v1/owner/additional-service-status';
  static const String directLogin = '/api/v1/owner/auth/login/direct-login';
  static const String checkLoginId =
      '/api/v1/owner/auth/sign-up/check-loginId/{loginId}';
  static const String findPassword = '/api/v1/owner/auth/sign-up/find-password';
  static const String identityVerification =
      '/owner/pages/identity-verification';
}
