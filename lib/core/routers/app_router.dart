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
import 'package:singleeat/screens/webview_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    navigatorKey: rootNavKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HomeScreen(title: ''))),
      GoRoute(
          path: AppRoutes.webView,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WebViewScreen())),
      GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginScreen())),
      GoRoute(
          path: AppRoutes.signup,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignupScreen())),
      GoRoute(
          path: AppRoutes.signupComplete,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SignUpCompleteScreen())),
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
    ],
  );
}
