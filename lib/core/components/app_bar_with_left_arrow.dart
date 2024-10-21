import 'package:flutter/material.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

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
        leading: Padding(
          padding: EdgeInsets.only(left: SGSpacing.p1),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: SGColors.black),
            onPressed: () {
              if (onTap != null) {
                onTap!();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
