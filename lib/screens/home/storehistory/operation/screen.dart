import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/date_range_picker.dart';
import 'package:singleeat/core/components/menu_tab_bar.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/datetime.dart';
import 'package:singleeat/core/utils/throttle.dart';
import 'package:singleeat/screens/home/storeHistory/operation/model.dart';
import 'package:singleeat/screens/home/storeHistory/operation/provider.dart';

class Event {
  final int id;
  final String title;
  final DateTime datetime;

  final String modifiedBy;
  final DateTime modifiedAt;
  final String reason;
  final DateTime beforeModifiedAt;

  Event(
      {required this.id,
        required this.title,
        required this.datetime,
        required this.modifiedBy,
        required this.modifiedAt,
        required this.reason,
        required this.beforeModifiedAt});
}

class EventHistoryScreen extends ConsumerStatefulWidget {
  const EventHistoryScreen({super.key});

  @override
  ConsumerState<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends ConsumerState<EventHistoryScreen> {
  late DateRange dateRange;

  Map<String, List<StoreHistoryModel>> events = {};

  List<StoreHistoryModel> currentEvents = [];
  ScrollController scrollController = ScrollController();
  final throttle = Throttle(
    delay: const Duration(milliseconds: 300),
  );

  @override
  void initState() {
    super.initState();
    dateRange = DateRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now(),
    );

    scrollController.addListener(loadMore);

    Future.microtask(() {
      final provider = ref.read(storeHistoryNotifierProvider.notifier);

      provider.clear();
      provider.getStoreHistory(
        dateRange.start.toShortDateStringWithZeroPadding,
        dateRange.end.toShortDateStringWithZeroPadding,
      );
    });
  }

  void loadMore() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final storeHistoryState = ref.read(storeHistoryNotifierProvider);
      // 마지막 조회한 페이지에서 데이터 없는 경우 더 조회하지 않음
      if (!storeHistoryState.hasMoreData) {
        return;
      }

      final storeHistoryProvider =
      ref.read(storeHistoryNotifierProvider.notifier);
      final page = storeHistoryState.page;

      storeHistoryProvider.onChangePage(page + 1);
      throttle.run(
            () => storeHistoryProvider.getStoreHistory(
          dateRange.start.toShortDateStringWithZeroPadding,
          dateRange.end.toShortDateStringWithZeroPadding,
        ),
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeHistoryNotifierProvider);
    final provider = ref.read(storeHistoryNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "이력"),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          borderWidth: 0,
          child: ListView(
              shrinkWrap: false,
              controller: scrollController,
              children: [
                SGContainer(
                    padding: EdgeInsets.symmetric(
                        horizontal: SGSpacing.p4, vertical: SGSpacing.p4),
                    borderWidth: 0,
                    color: Colors.white,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateRangePicker(
                            dateRange: dateRange,
                            onStartDateChanged: (DateTime startDate) {
                              setState(() {
                                dateRange =
                                    dateRange.copyWith(start: startDate);
                              });

                              provider.clearFilter();
                              provider.getStoreHistory(
                                dateRange
                                    .start.toShortDateStringWithZeroPadding,
                                dateRange.end.toShortDateStringWithZeroPadding,
                              );
                            },
                            onEndDateChanged: (DateTime endDate) {
                              setState(() {
                                dateRange = dateRange.copyWith(end: endDate);
                              });

                              provider.clearFilter();
                              provider.getStoreHistory(
                                dateRange
                                    .start.toShortDateStringWithZeroPadding,
                                dateRange.end.toShortDateStringWithZeroPadding,
                              );
                            },
                          ),
                          SizedBox(height: SGSpacing.p4),
                          SGContainer(
                            padding:
                            EdgeInsets.symmetric(horizontal: SGSpacing.p4),
                            width: double.infinity,
                            color: SGColors.primary,
                            borderRadius: BorderRadius.circular(SGSpacing.p2),
                            child: SGActionButton(
                                onPressed: () {
                                  provider.clearFilter();
                                  provider.getStoreHistory(
                                    dateRange
                                        .start.toShortDateStringWithZeroPadding,
                                    dateRange
                                        .end.toShortDateStringWithZeroPadding,
                                  );
                                },
                                label: "조회"),
                          ),
                          SizedBox(height: SGSpacing.p4),
                          MenuTabBar(
                              currentTab: state.filter,
                              tabs: ["가게", "메뉴"],
                              onTabChanged: (String tab) {
                                provider.onChangeFilter(tab);
                                provider.clearFilter();
                                provider.getStoreHistory(
                                  dateRange
                                      .start.toShortDateStringWithZeroPadding,
                                  dateRange
                                      .end.toShortDateStringWithZeroPadding,
                                );
                              }),
                        ])),
                SGContainer(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(SGSpacing.p4),
                  borderWidth: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...state.storeHistoryList.mapIndexed((index, StoreHistoryModel event) {
                        return _EventCard(
                          key: ValueKey('${event.hashCode}_$index'), // 고유 키 생성
                          event: event,
                        );
                      }),
                    ],
                  ),
                ),

              ]),
        ));
  }
}

class _EventCard extends StatefulWidget {
  _EventCard({super.key, required this.event});
  StoreHistoryModel event;

  @override
  State<_EventCard> createState() => _EventCardState();
}

final COLLAPSED_DIVIDER = () => Divider(
  height: SGSpacing.p8,
  color: SGColors.line1,
  thickness: 1,
);

class _EventCardState extends State<_EventCard> {
  bool collapsed = true;

  String formatDateTime(DateTime datetime) {
    return datetime.toFullDateTimeString;
  }

  @override
  Widget build(BuildContext context) {
    return SGContainer(
        margin: EdgeInsets.only(bottom: SGSpacing.p3),
        color: Colors.white,
        borderColor: SGColors.line3,
        borderWidth: 1.0,
        borderRadius: BorderRadius.circular(SGSpacing.p3),
        padding: EdgeInsets.all(SGSpacing.p4),
        child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      collapsed = !collapsed;
                    });
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SGTypography.body(
                                  widget.event.createdDate,
                                  color: SGColors.gray4,
                                  size: FontSize.small,
                                  weight: FontWeight.w500),
                              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                              Container(
                                width: 220,
                                child: SGTypography.body(
                                  widget.event.content,
                                  weight: FontWeight.w700,
                                  size: FontSize.normal,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ]),
                        Icon(collapsed
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                      ]),
                ),
                if (!collapsed) ...[
                  COLLAPSED_DIVIDER(),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...[
                          ["작업자", "사장님"],
                          ["변경 시간", widget.event.createdDate],
                        ].map((List<String> pair) {
                          return [
                            DataTableRow(left: pair[0], right: pair[1]),
                            SizedBox(height: SGSpacing.p3)
                          ];
                        }).flattened,
                      ]),
                  DataTableRow(left: "변경 전", right: widget.event.previousDate),
                ],
              ],
            )));
  }
}

class SearchButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool disabled;
  final SGActionButtonVariant variant;

  SearchButton(
      {required this.onPressed,
        required this.label,
        this.variant = SGActionButtonVariant.primary,
        this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SGContainer(
          padding: EdgeInsets.symmetric(vertical: SGSpacing.p4),
          width: double.infinity,
          color: disabled
              ? SGColors.gray3
              : (variant == SGActionButtonVariant.danger ? SGColors.warningRed.withOpacity(0.08) : SGColors.primary),
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          child: Center(
              child: SGTypography.body(label,
                  color: SGActionButtonVariant.primary == variant ? Colors.white : SGColors.warningRed,
                  weight: FontWeight.w700,
                  size: FontSize.medium))),
    );
  }
}
