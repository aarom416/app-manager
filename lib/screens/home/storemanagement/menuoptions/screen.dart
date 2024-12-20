import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/menu_tab_bar.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/provider.dart';

import '../../../../core/constants/colors.dart';
import 'menu/tab_menu.dart';
import 'options/tab_options.dart';

class MenuOptionsScreen extends ConsumerStatefulWidget {
  const MenuOptionsScreen({super.key});

  @override
  ConsumerState<MenuOptionsScreen> createState() => _MenuOptionsScreenState();
}

class _MenuOptionsScreenState extends ConsumerState<MenuOptionsScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(menuOptionsNotifierProvider.notifier).getMenuOptionInfo();
    });
  }

  String currentTab = "메뉴 관리";

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: SGColors.primary,
      onRefresh: () async {
        ref.read(menuOptionsNotifierProvider.notifier).getMenuOptionInfo();
      },
      child: ListView(children: [
        MenuTabBar(
            currentTab: currentTab,
            tabs: const ['메뉴 관리', '옵션 관리'],
            onTabChanged: (tab) {
              setState(() {
                currentTab = tab;
              });
            }),
        currentTab == "메뉴 관리" ? const MenuTab() : const OptionsTab()
      ]),
    );
  }
}
