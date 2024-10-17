import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/custom_tab_bar.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';

class NoticeModel {
  final String title;
  final String category;
  final DateTime date;

  NoticeModel({required this.title, required this.category, required this.date});
}

class NoticeScreen extends StatefulWidget {
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class NoticeCategoryChip extends StatelessWidget {
  final String text;

  const NoticeCategoryChip({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        color: SGColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
        padding: EdgeInsets.all(SGSpacing.p1 + SGSpacing.p05).copyWith(bottom: SGSpacing.p1, top: SGSpacing.p1),
        margin: EdgeInsets.only(right: SGSpacing.p12),
        child: SGTypography.body(text, color: SGColors.primary));
  }
}

class _NoticeScreenState extends State<NoticeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  ScrollController scrollController = ScrollController();

  static List<String> noticeCategories = ["전체", "서비스 안내", "점검 안내", "약관 안내"];

  static List<Tab> tabs = noticeCategories
      .map((e) => Tab(
            text: e,
          ))
      .toList();

  static List<NoticeModel> notices = [
    NoticeModel(title: "[공지] 싱그릿 앱 혜택 모아보기 신규 지면 안내", category: "서비스 안내", date: DateTime.now()),
    NoticeModel(title: "[공지] 싱그릿 앱 새벽 점검 실시 안내", category: "점검 안내", date: DateTime.now()),
    NoticeModel(title: "[공지] 싱그릿 앱 개인정보 처리방침 관련 약관 안내", category: "약관 안내", date: DateTime.now()),
    NoticeModel(title: "[공지] 싱그릿 앱 사장님을 위한 혜택 모아보기", category: "서비스 안내", date: DateTime.now()),
    NoticeModel(title: "[공지] 싱그릿 앱 버전 업데이트로 인한 점검 안내", category: "점검 안내", date: DateTime.now()),
  ];

  List<NoticeModel> getFilteredNotices(String category) {
    if (category == "전체") {
      return notices;
    }
    return notices.where((element) => element.category == category).toList();
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: "공지사항"),
      body: NestedScrollView(
        physics: const ClampingScrollPhysics(),
        controller: scrollController,
        headerSliverBuilder: (ctx, _) => [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(ctx),
            sliver: SliverPersistentHeader(
                pinned: true,
                delegate: CustomTabBar(
                    tabBar: TabBar(
                  controller: tabController,
                  indicatorColor: SGColors.primary,
                  tabs: tabs,
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
                  indicatorPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p6),
                  indicatorWeight: 3.0,
                  labelPadding: EdgeInsets.symmetric(horizontal: SGSpacing.p2),
                ))),
          ),
        ],
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.only(top: SGSpacing.p15).copyWith(left: SGSpacing.p3, right: SGSpacing.p3),
          child: TabBarView(physics: const NeverScrollableScrollPhysics(), controller: tabController, children: [
            ...noticeCategories.map((e) {
              final noticesList = getFilteredNotices(e);
              return ListView.separated(
                  itemBuilder: (ctx, index) {
                    return SGContainer(
                        color: SGColors.white,
                        borderColor: SGColors.gray2,
                        padding: EdgeInsets.all(SGSpacing.p3).copyWith(bottom: SGSpacing.p4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              NoticeCategoryChip(text: noticesList[index].category),
                              SGTypography.body(noticesList[index].date.toShortDateTimeString, color: SGColors.gray3),
                            ]),
                            SizedBox(height: SGSpacing.p3),
                            SGTypography.body(noticesList[index].title,
                                size: FontSize.small, color: SGColors.black, weight: FontWeight.w500),
                          ],
                        ));
                  },
                  separatorBuilder: (_, __) => SizedBox(height: SGSpacing.p3),
                  itemCount: noticesList.length);
            })
          ]),
        ),
      ),
    );
  }
}
