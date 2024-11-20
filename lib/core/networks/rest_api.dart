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
  static const String autoLogin = '/api/v1/owner/login/auto-login';
  static const String storeInfo = '/api/v1/owner/store-info/{storeId}';
  static const String storePhone = '/api/v1/owner/store-info/store-phone';
  static const String storeIntroduction =
      '/api/v1/owner/store-info/introduction';
  static const String ownerHome = '/api/v1/owner/owner-home';
  static const String originInformation =
      '/api/v1/owner/store-info/origin-information';
  static const String totalOrderAmount =
      '/api/v1/owner/total-order-amount/{storeId}';
  static const String operationStatus =
      '/api/v1/owner/store-info/operation-status';
  static const String loadNotification = '/api/v1/owner/notification/{page}';
  static const String notificationStatus = '/api/v1/owner/notification/status';
  static const String orderNotificationStatus =
      '/api/v1/owner/notification/order-notification-status';
  static const String loadStatisticsByStoreId =
      '/api/v1/owner/statistics/{storeId}';
}
