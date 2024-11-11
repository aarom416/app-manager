import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/screens/authenticate_with_phone_number_screen.dart';
import 'package:singleeat/screens/find_account_screen.dart';
import 'package:singleeat/screens/find_by_password_screen.dart';
import 'package:singleeat/screens/home_screen.dart';
import 'package:singleeat/screens/login_screen.dart';
import 'package:singleeat/screens/signup_complete_screen.dart';
import 'package:singleeat/screens/signup_screen.dart';
import 'package:singleeat/screens/store_registration_form_screen.dart';
import 'package:singleeat/screens/webview_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
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
          path: AppRoutes.webView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WebViewScreen())),
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
          path: AppRoutes.signup,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignupScreen())),
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
          path: AppRoutes.findByAccount,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FindAccountScreen())),
      GoRoute(
          path: AppRoutes.profileEdit,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProfileEditScreen())),
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
    ],
  );
}
