class RestApiUri {
  static const String applicationJson = 'application/json';

  static const String multipartFormData = 'multipart/form-data';

  static const String applicationXWwwFormUrlencoded =
      'application/x-www-form-urlencoded';

  static const String host = 'https://singleatapp.com:444';

  /// Coupon
  /// 쿠폰 발급 API
  // POST - 쿠폰 발급
  static const String issueCoupon = '/api/v1/owner/coupon';
  // GET - 쿠폰 정보 조회
  static const String getCouponInfo = '/api/v1/owner/coupon/{storeId}/{page}';
  // DELETE - 발급 쿠폰 삭제
  static const String deleteIssuedCoupon = '/api/v1/owner/coupon/{couponId}';
  // DELETE - 발급 쿠폰 선택 삭제 - 관리자 제한 API TODO
  static const String adminDeleteIssuedCoupon =
      '/api/v1/owner/admin/coupon/{couponId}';

  /// Statistics
  /// 통계 내역 API
  // GET - 통계 내역 전체 조회
  static const String loadStatisticsByStoreId =
      '/api/v1/owner/statistics/{storeId}';
  // GET - 주간 통계 내역 조회
  static const String loadStatisticsWeekByStoreId =
      '/api/v1/owner/statistics/week/{storeId}';
  // GET - 월간 통계 내역 조회
  static const String loadStatisticsMonthByStoreId =
      '/api/v1/owner/statistics/month/{storeId}';

  /// StoreInfoUpdate
  /// 가게 정보 수정 API
  // POST - 가게 로고 등록 및 변경
  static const String updateStoreThumbnail =
      '/api/v1/owner/store-info/thumbnail';
  // POST - 가게 사진 등록 및 변경
  static const String updateStorePicture =
      '/api/v1/owner/store-info/store-picture';
  // POST - 가게 번호 변경
  static const String storePhone = '/api/v1/owner/store-info/store-phone';
  // POST - 포장 상태 수정
  static const String updatePickupStatus =
      '/api/v1/owner/store-info/pickup-status';
  // POST - 가게 원산지 및 알레르기 정보 수정
  static const String originInformation =
      '/api/v1/owner/store-info/origin-information';
  // POST - 가게 영업 시간 변경
  static const String updateOperationTime =
      '/api/v1/owner/store-info/operation-time-detail';
  // POST - 가게 영업 상태 변경
  static const String operationStatus =
      '/api/v1/owner/store-info/operation-status';
  // POST - 가게 이름 변경 TODO
  static const String updateStoreName = '/api/v1/owner/store-info/name';
  // POST - 가게 소개 변경
  static const String storeIntroduction =
      '/api/v1/owner/store-info/introduction';
  // POST - 가게 소개 사진 등록 및 변경
  static const String updateIntroductionPicture =
      '/api/v1/owner/store-info/introduction-picture';
  // POST - 가게 휴무일 변경
  static const String updateHolidayDetail =
      '/api/v1/owner/store-info/holiday-detail';
  // POST - 포장 예상 시간 수정
  static const String updatePickupTime =
      '/api/v1/owner/store-info/expected-pickup-time';
  // POST - 배달 예상 시간 수정
  static const String updateDeliveryTime =
      '/api/v1/owner/store-info/expected-delivery-time';
  // POST - 가게 배달팁 변경
  static const String updateDeliveryTip =
      '/api/v1/owner/store-info/delivery-tip';
  // POST - 배달 상태 수정
  static const String updateDeliveryStatus =
      '/api/v1/owner/store-info/delivery-status';
  // POST - 가게 휴게 시간 변경
  static const String updateBreakTime =
      '/api/v1/owner/store-info/break-time-detail';
  // POST - 가게 로고 등록 및 변경 - 관리자 제한 API TODO
  static const String adminUpdateStoreThumbnail =
      '/api/v1/owner/admin/store-info/thumbnail';
  // POST - 가게 사진 등록 및 변경 - 관리자 제한 API TODO
  static const String adminUpdateStorePicture =
      '/api/v1/owner/admin/store-info/store-picture';
  // POST - 가게 소개 사진 등록 및 변경 - 관리자 제한 API TODO
  static const String adminUpdateIntroductionPicture =
      '/api/v1/owner/admin/store-info/introduction-picture';

  /// StoreMenuCreate
  /// 가게 메뉴 추가 API
  // POST - 옵션 카테고리 추가
  static const String createOptionCategory =
      '/api/v1/owner/store-menu/option-category';
  // POST - 메뉴 추가
  static const String createMenu = '/api/v1/owner/store-menu/menu';
  // POST - 메뉴 카테고리 추가
  static const String createMenuCategory =
      '/api/v1/owner/store-menu/menu-category';
  // POST - 옵션 추가
  static const String createOption =
      '/api/v1/owner/store-menu/option';

  /// StoreInfoGet
  /// 가게 정보 조회 API
  // GET - 가게 정보 조회
  static const String storeInfo = '/api/v1/owner/store-info/{storeId}';
  // GET - 영업 정보 조회
  static const String getOperationInfo =
      '/api/v1/owner/store-info/operation-info/{storeId}';
  // GET - 메뉴/옵션 정보 조회
  static const String getMenuOptionInfo =
      '/api/v1/owner/store-info/menu-option-info/{storeId}';
  // GET - 배달/포장 정보 조회
  static const String getDeliveryTakeoutInfo =
      '/api/v1/owner/store-info/delivery-takeout-info/{storeId}';

  /// Barogo
  /// 바로고 주문 관리 API
  // PUT - 바로고 주문 취소 TODO
  static const String cancelBarogoOrder =
      '/api/v1/owner/barogo/order-cancel/{orderId}';
  // POST - 바로고 배달가능 여부 및 요금 조회 TODO
  static const String getBarogoDeliveryInfo =
      '/api/v1/owner/barogo/delivery-possible/{orderId}';
  // POST - 바로고 주문 접수 TODO
  static const String acceptBarogoOrder =
      '/api/v1/owner/barogo/accepted-order/{orderId}';

  /// StoreMenuDelete
  /// 가게 메뉴 삭제 API
  // DELETE - 메뉴 삭제
  static const String deleteMenu = '/api/v1/owner/store-menu/menu';
  // DELETE - 메뉴 카테고리 삭제
  static const String deleteMenuCategory =
      '/api/v1/owner/store-menu/store-menu-category';
  // DELETE - 메뉴 옵션 삭제
  static const String deleteMenuOption = '/api/v1/owner/store-menu/menu-option';
  // DELETE - 메뉴 옵션 카테고리 삭제
  static const String deleteMenuOptionCategory =
      '/api/v1/owner/store-menu/menu-option-category';

  /// Login
  /// 로그인 API
  // POST - Access Token 재발급 TODO
  static const String refreshAccessToken = '/api/v1/owner/token/access-token';
  // POST - 계정 로그아웃
  static const String logout = '/api/v1/owner/logout';
  // POST - 직접 로그인 TODO
  static const String directLogin = '/api/v1/owner/auth/login/direct-login';
  // POST - '직접 로그인' 이후 본인인증 성공 후 최종 로그인 성공
  static const String verifyPhone =
      '/api/v1/owner/auth/direct-login/verify-phone';
  // POST - 관리자 토큰 발급 TODO
  static const String issueAdminToken = '/api/v1/owner/auth/admin/token';
  // POST - 비정상적인 행위로 인한 사장 계정 정지 - 관리자 제한 API TODO
  static const String adminAccountStop = '/api/v1/owner/admin/account-stop';
  // POST - 정지된 사장님 계정 강제 정지 해제 - 관리자 제한 API TODO
  static const String adminAccountStopCancel =
      '/api/v1/owner/admin/account-stop-cancel';
  // GET - 자동 로그인
  static const String autoLogin = '/api/v1/owner/login/auto-login';

  /// BusinessInformation
  /// 사업자 정보 API
  // POST - 사업자 정보 수정 TODO
  static const String updateBusinessInformation =
      '/api/v1/owner/business-information';
  // GET - 사업자 정보 조회 TODO
  static const String getBusinessInformation =
      '/api/v1/owner/business-information/{storeId}';

  /// Settlement
  /// 정산 API
  // POST - 정산 내역 보고서 생성 및 이메일 전송 TODO
  static const String generateSettlementReport =
      '/api/v1/owner/settlement/report';
  // POST - 정산일에 따른 정산 상태 변경 - 관리자 제한 API TODO
  static const String adminUpdateSettlementStatus =
      '/api/v1/owner/admin/settlement/{settlementDate}';
  // GET - 정산 내역 조회 TODO
  static const String getSettlementInfo = '/api/v1/owner/settlement/{storeId}';

  /// News
  /// 공지사항 API
  // POST - 사장님 공지사항 생성 및 일괄 푸시 알람 전송 - 관리자 제한 API TODO
  static const String adminCreateNewsAndSendPush =
      '/api/v1/owner/admin/news/batch';

  /// SafePhone
  /// 안심번호 API
  // POST - 안심번호 등록 생성 - 관리자 제한 API TODO
  static const String adminRegisterSafePhone =
      '/api/v1/owner/admin/safe-phone/register-safe-phone';
  // POST - 안심번호 해제 TODO
  static const String adminClearSafePhone =
      '/api/v1/owner/admin/safe-phone/clear';

  /// Notification
  /// 알림 API
  // POST - FCM TOKEN 저장
  static const String fcmToken = '/api/v1/owner/notification/push/fcm-token';
  // POST - 주문 알림 설정 변경
  static const String orderNotificationStatus =
      '/api/v1/owner/notification/order-notification-status';
  // GET - 일반 알림 조회
  static const String loadNotification = '/api/v1/owner/notification/{page}';
  // GET - 모든 알림 상태 조회
  static const String notificationStatus = '/api/v1/owner/notification/status';

  /// Owner
  /// 사장 API
  // POST - 이메일 재설정 TODO
  static const String resetEmail = '/api/v1/owner/{email}';
  // POST - 이메일 인증 코드 확인 TODO
  static const String verifyEmailCode = '/api/v1/owner/verify-code';
  // POST - 비밀번호 변경 TODO
  static const String updateOwnerPassword = '/api/v1/owner/update-password';
  // POST - 싱그릿 식단 연구소 수신 동의 항목 변경
  static const String singleatResearchStatus =
      '/api/v1/owner/singleat-research-status';
  // POST - 이메일 인증 코드 발송 TODO
  static const String sendEmailCode = '/api/v1/owner/send-code';
  // POST - 부가 서비스 및 혜택 안내 동의 항목 변경
  static const String additionalServiceStatus =
      '/api/v1/owner/additional-service-status';
  // GET - 하루 매출 조회
  static const String totalOrderAmount =
      '/api/v1/owner/total-order-amount/{storeId}';
  // GET - 지난 주문 내역 조회 TODO
  static const String getOrderHistory =
      '/api/v1/owner/order-info/{storeId}/{page}/{filter}';
  // GET - 비밀번호 확인 TODO
  static const String checkPassword = '/api/v1/owner/find-password';
  // DELETE - 회원 탈퇴 - 관리자 제한 API TODO
  static const String adminDeleteOwner =
      '/api/v1/owner/admin/{storeId}/{ownerId}';

  /// Vat
  /// 부가세 API
  // POST - 부가세 내역 보고서 생성 및 이메일 전송
  static const String generateVatReport = '/api/v1/owner/vat/report';
  // GET - 부가세 내역 조회 TODO
  static const String getVatInfo = '/api/v1/owner/vat/{storeId}';

  /// StoreMenuGet
  /// 가게 메뉴 조회 API
  // GET - 메뉴 정보 조회
  static const String getMenu = '/api/v1/owner/store-menu/menu/{menuId}';
  // GET - 메뉴 옵션 정보 조회
  static const String getMenuInfo =
      '/api/v1/owner/store-menu/menu-option/{menuOptionId}';

  /// Encryption
  /// 암호화 및 복호화 API
  // POST - 암호화 데이터 복호화 - 관리자 제한 API TODO
  static const String decryptData =
      '/api/v1/owner/admin/encryption/decrypt/{encryptedData}';

  /// AllowIp
  /// 허용 아이피 API
  // POST - 허용 아이피 설정 - 관리자 제한 API TODO
  static const String adminAllowIp = '/api/v1/owner/admin/allow-ip';

  /// SignUp
  /// 회원가입 API
  // POST - 회원가입 최종 완료
  static const String signUp = '/api/v1/owner/auth/sign-up';
  // POST - 이메일 인증 코드 확인
  static const String verifyCode = '/api/v1/owner/auth/sign-up/verify-code';
  // POST - 비밀번호 재설정
  static const String updatePassword =
      '/api/v1/owner/auth/sign-up/update-password';
  // POST - 이메일 인증 코드 발송
  static const String sendCode = '/api/v1/owner/auth/sign-up/send-code';
  // POST - 비밀번호 찾기
  static const String findPassword = '/api/v1/owner/auth/sign-up/find-password';
  // POST - 아이디 중복 확인
  static const String checkLoginId =
      '/api/v1/owner/auth/sign-up/check-loginId/{loginId}';

  /// StoreMenuUpdate
  /// 가게 메뉴 수정 API
  // POST - 메뉴 품절 상태 변경
  static const String updateMenuSoldOutStatus =
      '/api/v1/owner/store-menu/menu-sold-out';
  // POST - 메뉴 가격 변경
  static const String updateMenuPrice = '/api/v1/owner/store-menu/menu-price';
  // POST - 메뉴 인기 상태 변경
  static const String updateMenuPopularity =
      '/api/v1/owner/store-menu/menu-popularity';
  // POST - 가게 메뉴 사진 등록 및 변경
  static const String updateMenuPicture =
      '/api/v1/owner/store-menu/menu-picture';
  // POST - 메뉴 옵션 품절 상태 변경
  static const String updateMenuOptionSoldOutStatus =
      '/api/v1/owner/store-menu/menu-option/sold-out';
  // POST - 메뉴 옵션 가격 변경
  static const String updateMenuOptionPrice =
      '/api/v1/owner/store-menu/menu-option/price';
  // POST - 메뉴 옵션 이름 변경
  static const String updateMenuOptionName =
      '/api/v1/owner/store-menu/menu-option/name';

  // POST - 메뉴 옵션 정보 변경
  static const String updateMenuOptionInfo =
      '/api/v1/owner/store-menu/menu-option/info';
  // POST - 메뉴 옵션 카테고리 사용 메뉴 변경
  static const String updateMenuOptionCategoryUseMenu =
      '/api/v1/owner/store-menu/menu-option-category/use-menu';
  // POST - 메뉴 옵션 카테고리 품절 상태 변경
  static const String updateMenuOptionCategorySoldOutStatus =
      '/api/v1/owner/store-menu/menu-option-category/sold-out';
  // POST - 메뉴 옵션 카테고리 이름 변경
  static const String updateMenuOptionCategoryName =
      '/api/v1/owner/store-menu/menu-option-category/name';
  // POST - 메뉴 옵션 카테고리 최대, 최소 개수 변경
  static const String updateMenuOptionCategoryMaxChoice =
      '/api/v1/owner/store-menu/menu-option-category/max-choice';
  // POST - 메뉴 옵션 카테고리 필수 여부 변경
  static const String updateMenuOptionCategoryEssential =
      '/api/v1/owner/store-menu/menu-option-category/essential';
  // POST - 메뉴 이름 변경
  static const String updateMenuName = '/api/v1/owner/store-menu/menu-name';
  // POST - 메뉴 구성 변경
  static const String updateMenuMadeOf =
      '/api/v1/owner/store-menu/menu-made-of';
  // POST - 메뉴 설명 변경
  static const String updateMenuIntroduction =
      '/api/v1/owner/store-menu/menu-introduction';
  // POST - 메뉴 정보 변경
  static const String updateMenuInfo = '/api/v1/owner/store-menu/menu-info';
  // POST - 메뉴 카테고리 이름 및 설명 수정
  static const String updateMenuCategoryName =
      '/api/v1/owner/store-menu/menu-category/name';
  // POST - 메뉴 베스트 상태 변경
  static const String updateMenuBestStatus =
      '/api/v1/owner/store-menu/menu-best';

  /// OrderReceive
  /// 주문 접수 완료 전 API
  // POST - 포장 주문 거절 TODO
  static const String rejectTakeoutOrder =
      '/api/v1/owner/order/receive/takeout-order/reject';
  // POST - 배달 주문 거절 TODO
  static const String rejectDeliveryOrder =
      '/api/v1/owner/order/receive/delivery-order/reject';
  // POST - 주문 접수 TODO
  static const String acceptOrder = '/api/v1/owner/order/receive/accept';
  // GET - 신규 주문 상세 정보 조회 TODO
  static const String getNewOrderDetail =
      '/api/v1/owner/order/receive/new/{orderInformationId}';
  // GET - 신규 주문 내역 조회 TODO
  static const String getNewOrderList =
      '/api/v1/owner/order/receive/new/list/{storeId}';

  /// StoreHistory
  /// 가게 이력 API
  // GET - 가게 이력 조회
  static const String getStoreHistory =
      '/api/v1/owner/store-history/{storeId}/{page}/{filter}';

  /// OrderAccept
  /// 주문 접수 완료 후 API
  // POST - 포장 주문 취소 TODO
  static const String cancelTakeoutOrder =
      '/api/v1/owner/order/accept/takeout-order/cancel';
  // POST - 배달 주문 취소 TODO
  static const String cancelDeliveryOrder =
      '/api/v1/owner/order/accept/delivery-order/cancel';
  // POST - 배달 완료 처리 알림 전송 TODO
  static const String notifyDeliveryComplete =
      '/api/v1/owner/order/accept/delivery-complete/{orderInformationId}';
  // POST - 준비 완료 알림 전송 TODO
  static const String notifyCookingComplete =
      '/api/v1/owner/order/accept/cooking-complete/{orderInformationId}';
  // GET - 접수 주문 상세 정보 조회 TODO
  static const String getAcceptedOrderDetail =
      '/api/v1/owner/order/accept/{orderInformationId}';
  // GET - 접수 주문 내역 조회 TODO
  static const String getAcceptedOrderList =
      '/api/v1/owner/order/accept/list/{storeId}';
  // GET - 완료 주문 상세 정보 조회 TODO
  static const String getCompletedOrderDetail =
      '/api/v1/owner/order/accept/complete/{orderInformationId}';
  // GET - 완료 주문 내역 조회 TODO
  static const String getCompletedOrderList =
      '/api/v1/owner/order/accept/complete/list/{storeId}';

  /// Enroll
  /// 입점 API
  // POST - 입점 신청서 제출
  static const String enroll = '/api/v1/owner/enroll';
  // POST - 사업자 등록 번호 조회
  static const String checkBusinessNumber =
      '/api/v1/owner/enroll/check-business-registration-number/{businessRegistrationNumber}';
  // POST - 입점 신청 확인 - 관리자 제한 API TODO
  static const String adminConfirmEnroll = '/api/v1/owner/admin/enroll-store';

  /// OrderHistory
  /// 주문 내역 API
  // GET - 주문 내역 조회 TODO
  static const String getOrderHistoryByFilter =
      '/api/v1/owner/order-history/{storeId}/{page}/{filter}';

  /// OwnerHome
  /// 사장님 홈 API
  // GET - 홈 조회
  static const String ownerHome = '/api/v1/owner/owner-home';

  /// PortOne
  /// 포트원 API
  // POST - 파트너 복원 - 관리자 제한 API TODO
  static const String adminRecoverPartner =
      '/api/v1/owner/admin/port-one/recover-partner/{partnerId}';
  // POST - 파트너 생성 및 안심번호 발급 - 관리자 제한 API TODO
  static const String adminCreatePartner =
      '/api/v1/owner/admin/port-one/create-partner';
  // POST - 파트너 보관 - 관리자 제한 API TODO
  static const String adminArchivePartner =
      '/api/v1/owner/admin/port-one/archive-partner/{partnerId}';
  // PATCH - 파트너 수정 - 관리자 제한 API TODO
  static const String adminUpdatePartner =
      '/api/v1/owner/admin/port-one/update-partner';

  /// health-check-controller
  /// 헬스 체크 API
  // GET - 헬스 체크 TODO
  static const String healthCheck = '/api/v1/owner/health-check';

  /// 사장님 전화번호 변경
  static const String identityVerification =
      '/owner/pages/identity-verification';
  // GET - 매출 부가세 내역 조회
  static const String getVatSalesInfo = '/api/v1/owner/vat/sales/{storeId}';
  // GET - 매입 부가세 내역 조회
  static const String getVatPurchasesInfo =
      '/api/v1/owner/vat/purchases/{storeId}';
}
