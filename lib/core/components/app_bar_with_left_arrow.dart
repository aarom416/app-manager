import 'package:flutter/material.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/typography.dart';

class AppBarWithLeftArrow extends StatelessWidget implements PreferredSizeWidget {
  AppBarWithLeftArrow({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (onTap != null) {
          onTap!();
          return false;
        }
        return true;
      },
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: SGTypography.body(title, size: FontSize.medium, weight: FontWeight.w800),
        elevation: 0.0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
