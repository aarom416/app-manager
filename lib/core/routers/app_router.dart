import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/screens/allergy_information_screen.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';
import 'package:singleeat/screens/bottom/myinfo/accountstatus/checkpassword/screen.dart';
import 'package:singleeat/screens/bottom/myinfo/accountstatus/screen.dart';
import 'package:singleeat/screens/bottom/myinfo/alarmstatus/business_notification_configuration_screen.dart';
import 'package:singleeat/screens/bottom/myinfo/alarmstatus/notification_configuration_screen.dart';
import 'package:singleeat/screens/bottom/myinfo/operationstatus/screen.dart';
import 'package:singleeat/screens/delivery_agency_screen.dart';
import 'package:singleeat/screens/find_account_screen.dart';
import 'package:singleeat/screens/find_account_webview_screen.dart';
import 'package:singleeat/screens/find_by_password_screen.dart';
import 'package:singleeat/screens/find_by_password_webview_screen.dart';
import 'package:singleeat/screens/home/couponinformation/operation/detail/screen.dart';
import 'package:singleeat/screens/home/couponinformation/operation/screen.dart';
import 'package:singleeat/screens/home/storeVat/operation/screen.dart';
import 'package:singleeat/screens/home/storeinformation/operation/screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/store_management_screen.dart';
import 'package:singleeat/screens/home/storeorderhistory/operation/screen.dart';
import 'package:singleeat/screens/home/storesettlement/operation/screen.dart';
import 'package:singleeat/screens/home/storestatistics/operation/screen.dart';
import 'package:singleeat/screens/home_screen.dart';
import 'package:singleeat/screens/login_screen.dart';
import 'package:singleeat/screens/login_webview_screen.dart';
import 'package:singleeat/screens/notification_screen.dart';
import 'package:singleeat/screens/register_delivery_agency_screen.dart';
import 'package:singleeat/screens/signup_complete_screen.dart';
import 'package:singleeat/screens/signup_screen.dart';
import 'package:singleeat/screens/signup_webview_screen.dart';
import 'package:singleeat/screens/store_registration_form_screen.dart';
import 'package:singleeat/screens/success_change_password_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    navigatorKey: rootNavKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) {
            UniqueKey? extra = state.extra as UniqueKey?;
            if (extra == null) {
              return const NoTransitionPage(child: HomeScreen(title: ''));
            } else {
              return NoTransitionPage(
                  child: HomeScreen(
                title: '',
                key: ValueKey(extra),
              ));
            }
          }),
      GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) {
            UniqueKey? extra = state.extra as UniqueKey?;
            if (extra == null) {
              return const NoTransitionPage(child: LoginScreen());
            } else {
              return NoTransitionPage(child: LoginScreen(key: ValueKey(extra)));
            }
          }),
      GoRoute(
          path: AppRoutes.loginWebView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginWebViewScreen())),
      GoRoute(
          path: AppRoutes.signup,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignupScreen())),
      GoRoute(
          path: AppRoutes.signupWebView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignupWebViewScreen())),
      GoRoute(
          path: AppRoutes.signupComplete,
          pageBuilder: (context, state) {
            UniqueKey? extra = state.extra as UniqueKey?;
            if (extra == null) {
              return const NoTransitionPage(child: SignUpCompleteScreen());
            } else {
              return NoTransitionPage(
                  child: SignUpCompleteScreen(key: ValueKey(extra)));
            }
          }),
      GoRoute(
          path: AppRoutes.authenticateWithPhoneNumber,
          pageBuilder: (context, state) {
            Object? extra = state.extra;
            if (extra != null) {
              final data = extra as Map<String, dynamic>;
              return NoTransitionPage(
                child: AuthenticateWithPhoneNumberScreen(
                  title: data['title'] ?? '로그인',
                ),
              );
            } else {
              return NoTransitionPage(
                child: AuthenticateWithPhoneNumberScreen(title: '로그인'),
              );
            }
          }),
      GoRoute(
          path: AppRoutes.findByPassword,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FindByPasswordScreen())),
      GoRoute(
          path: AppRoutes.findByPasswordWebView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FindByPasswordWebViewScreen())),
      GoRoute(
          path: AppRoutes.findByAccount,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FindAccountScreen())),
      GoRoute(
          path: AppRoutes.findByAccountWebView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FindAccountWebViewScreen())),
      GoRoute(
          path: AppRoutes.profileEdit,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileEditScreen())),
      GoRoute(
          path: AppRoutes.notificationConfiguration,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: NotificationConfigurationScreen())),
      GoRoute(
          path: AppRoutes.businessNotificationConfiguration,
          pageBuilder: (context, state) => const NoTransitionPage(
              child: BusinessNotificationConfigurationScreen())),
      GoRoute(
          path: AppRoutes.deliveryAgency,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: DeliveryAgencyScreen())),
      GoRoute(
          path: AppRoutes.temporaryClosed,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TemporaryClosedScreen())),
      GoRoute(
          path: AppRoutes.profileDeleteSession,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ProfileDeleteSessionScreen())),
      GoRoute(
          path: AppRoutes.checkPassword,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: CheckPasswordScreen(title: "비밀번호 확인"))),
      GoRoute(
          path: AppRoutes.changePassword,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: ChangePasswordScreen(title: "비밀번호 변경"))),
      GoRoute(
          path: AppRoutes.registerDeliveryAgency,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: RegisterDeliveryAgencyScreen())),
      GoRoute(
          path: AppRoutes.successChangePassword,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SuccessChangePasswordScreen())),
      GoRoute(
          path: AppRoutes.storeRegistrationForm,
          pageBuilder: (context, state) {
            UniqueKey? extra = state.extra as UniqueKey?;
            if (extra == null) {
              return const NoTransitionPage(
                  child: StoreRegistrationFormScreen());
            } else {
              return NoTransitionPage(
                  child: StoreRegistrationFormScreen(key: ValueKey(extra)));
            }
          }),
      GoRoute(
          path: AppRoutes.notification,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: NotificationScreen())),
      GoRoute(
          path: AppRoutes.statistics,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: StatisticsScreen())),
      GoRoute(
          path: AppRoutes.settlement,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettlementScreen())),
      GoRoute(
          path: AppRoutes.vat,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TaxesScreen())),
      GoRoute(
          path: AppRoutes.storeManagement,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: StoreManagementScreen())),
      GoRoute(
          path: AppRoutes.storeInformation,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: StoreInformationScreen())),
      GoRoute(
          path: AppRoutes.orderHistory,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: OrderHistoryScreen())),
      GoRoute(
          path: AppRoutes.allergyInformation,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AllergyInformationScreen())),
      GoRoute(
          path: AppRoutes.couponInformation,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CouponInformationScreen())),
      GoRoute(
          path: AppRoutes.couponInformationDetail,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CouponDetailScreen())),
    ],
  );
});
