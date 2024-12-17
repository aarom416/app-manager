import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/office/providers/home_provider.dart';
import 'package:singleeat/screens/bottom/myinfo/profile_screen.dart';
import 'package:singleeat/screens/bottom/order/operation/screen.dart';
import 'package:singleeat/screens/main_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextStyle get _textStyle => TextStyle(
        color: SGColors.gray4,
        fontSize: FontSize.tiny,
        fontFamily: "Pretendard",
        fontWeight: FontWeight.w500,
      );

  final List<Widget> _screens = [
    const OrderManagementScreen(),
    const MainScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = ref.read(homeNotifierProvider.notifier);
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor:
          state.selectedIndex != 0 ? const Color(0xFFFAFAFA) : SGColors.black,
      body: SGContainer(
          borderWidth: 0,
          color: state.selectedIndex != 0
              ? const Color(0xFFFAFAFA)
              : SGColors.black,
          boxShadow: SGBoxShadow.large,
          child: _screens[state.selectedIndex]),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(SGSpacing.p4),
            topEnd: Radius.circular(SGSpacing.p4)),
        child: SGContainer(
            // borderRadius: BorderRadiusDirectional.only(
            //     topStart: Radius.circular(SGSpacing.p4), topEnd: Radius.circular(SGSpacing.p4)),
            borderRadius: BorderRadius.circular(SGSpacing.p4),
            borderColor:
                state.selectedIndex != 0 ? SGColors.line2 : SGColors.lineDark,
            borderWidth: 1,
            child: BottomNavigationBar(
              backgroundColor:
                  state.selectedIndex == 0 ? SGColors.black : SGColors.white,
              selectedItemColor: SGColors.primary,
              unselectedItemColor: SGColors.gray4,
              selectedLabelStyle: _textStyle.copyWith(color: SGColors.primary),
              unselectedLabelStyle: _textStyle,
              currentIndex: state.selectedIndex,
              showUnselectedLabels: true,
              onTap: provider.onChangeSelectedIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/orders-off.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('assets/images/orders-on.png',
                      width: 24, height: 24),
                  label: '주문 접수',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/main-off.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('assets/images/main-on.png',
                      width: 24, height: 24),
                  label: '홈',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset('assets/images/profile-off.png',
                      width: 24, height: 24),
                  activeIcon: Image.asset('assets/images/profile-on.png',
                      width: 24, height: 24),
                  label: '내 정보',
                ),
              ],
            )),
      ),
    );
  }
}
