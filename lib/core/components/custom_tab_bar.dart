import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';

class CustomTabBar extends SliverPersistentHeaderDelegate {
  CustomTabBar({required this.tabBar, this.header = null});

  final TabBar tabBar;
  Widget? header;

  double get headerHeight => 0;

  @override
  double get minExtent => tabBar.preferredSize.height + headerHeight;

  @override
  double get maxExtent => tabBar.preferredSize.height + headerHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Align(
      child: SGContainer(
          borderWidth: 0,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (header != null) header!,
              tabBar,
            ],
          )),
    );
  }

  @override
  bool shouldRebuild(CustomTabBar oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
