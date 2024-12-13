import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/components/typography.dart';
import '../core/constants/colors.dart';
import '../office/providers/login_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loginNotifierProvider.notifier).autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SGColors.primary,
              const Color(0xFF65DD7F),
            ],
          ),
        ),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 78, right: 78),
              child: Image.asset("assets/images/splash-logo.png"),
            ),
            Positioned(
              bottom: 54,
              left: 16,
              right: 16,
              child: Center(child: SGTypography.body("현재는 천안시로 서비스가 한정되어 있습니다.", color: SGColors.white, size: 14, weight: FontWeight.w700)),
            )
          ],
        ),
      ),
    );
  }
}
