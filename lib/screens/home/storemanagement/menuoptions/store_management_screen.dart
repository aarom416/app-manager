import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/custom_tab_bar.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storemanagement/infomation/screen.dart';
import 'package:singleeat/screens/home/storemanagement/operation/screen.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/screen.dart';
import 'package:singleeat/screens/home/storemanagement/menuoptions/screen.dart';

class StoreManagementScreen extends StatefulWidget {
  const StoreManagementScreen({super.key});

  @override
  State<StoreManagementScreen> createState() => _StoreManagementScreenState();
}

class _StoreManagementScreenState extends State<StoreManagementScreen> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBarWithLeftArrow(title: "가게 관리"),
            body: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (ctx, _) => [
                      SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  ctx),
                          sliver: SliverPersistentHeader(
                              pinned: true,
                              delegate: CustomTabBar(
                                  tabBar: TabBar(
                                indicatorColor: SGColors.primary,
                                tabs: [
                                  Tab(text: "가게 정보"),
                                  Tab(text: "영업"),
                                  Tab(text: "배달/포장"),
                                  Tab(text: "메뉴/옵션"),
                                ],
                                labelStyle: TextStyle(
                                  fontSize: FontSize.normal,
                                  fontWeight: FontWeight.w600,
                                  color: SGColors.primary,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: FontSize.normal,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFBEBEBE),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorPadding: EdgeInsets.symmetric(
                                    horizontal: SGSpacing.p6),
                                indicatorWeight: 3.0,
                                labelPadding: EdgeInsets.symmetric(
                                    horizontal: SGSpacing.p2),
                              ))))
                    ],
                body: SGContainer(
                    color: Color(0xFFFAFAFA),
                    padding: EdgeInsets.only(top: SGSpacing.p15)
                        .copyWith(left: SGSpacing.p4, right: SGSpacing.p4),
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        const StoreManagementBasicInfoScreen(),
                        const OperationScreen(),
                        DeliveryScreen(),
                        MenuOptionsScreen(),
                      ],
                    )))));
  }
}
