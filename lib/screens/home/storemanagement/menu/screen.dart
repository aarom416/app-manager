import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/menu_tab_bar.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/reload_button.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/office/models/cuisine_model.dart';
import 'package:singleeat/screens/home/storemanagement/menu/options/cuisine_option_category_screen.dart';
import 'package:singleeat/screens/cuisine_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/tab_menu.dart';
import 'package:singleeat/screens/home/storemanagement/menu/options/tab_options.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/new_cuisine_category_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/options/new_cuisine_option_category_screen.dart';
import 'package:singleeat/screens/home/storemanagement/menu/menu/new_cuisine_screen.dart';
import 'package:singleeat/screens/update_cuisine_category_screen.dart';

class MenuOptionScreen extends ConsumerStatefulWidget {
  const MenuOptionScreen({super.key});

  @override
  ConsumerState<MenuOptionScreen> createState() => _MenuOptionScreenState();
}

class _MenuOptionScreenState extends ConsumerState<MenuOptionScreen> {

  @override
  void initState() {
    Future.microtask(() {
      // ref.read(operationNotifierProvider.notifier).getOperationInfo();
    });
  }

  String currentTab = "메뉴 관리";

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      MenuTabBar(
          currentTab: currentTab,
          tabs: const ['메뉴 관리', '옵션 관리'],
          onTabChanged: (tab) {
            setState(() {
              currentTab = tab;
            });
          }),
      currentTab == "메뉴 관리" ? const MenuTab() : OptionsTab()
    ]);
  }
}
