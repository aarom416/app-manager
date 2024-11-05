import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/main.dart';
import 'package:singleeat/screens/login_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: AppRoutes.login,
    navigatorKey: rootNavKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
          path: AppRoutes.root,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MyApp())),
      GoRoute(
          path: AppRoutes.login,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginScreen())),
    ],
  );
}
