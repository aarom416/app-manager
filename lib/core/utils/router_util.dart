import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void popUntil({required BuildContext context, required String path}) {
  if (!context.mounted) return;

  final goRouter = GoRouter.of(context);
  while (goRouter.routerDelegate.currentConfiguration.last.matchedLocation !=
      path) {
    if (!goRouter.canPop()) {
      break;
    }

    goRouter.pop();
  }
}
