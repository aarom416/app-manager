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
  late String currentTab;

  Map<String, List<Event>> events = {
    "가게": [
      Event(
          id: 1,
          title: "가게 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "가게 이름 변경",
          beforeModifiedAt: DateTime.now()),
      Event(
          id: 2,
          title: "가게 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "가게 이름 변경",
          beforeModifiedAt: DateTime.now()),
      Event(
          id: 3,
          title: "가게 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "가게 이름 변경",
          beforeModifiedAt: DateTime.now()),
    ],
    "메뉴": [
      Event(
          id: 4,
          title: "메뉴 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "메뉴 이름 변경",
          beforeModifiedAt: DateTime.now()),
      Event(
          id: 5,
          title: "메뉴 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "메뉴 이름 변경",
          beforeModifiedAt: DateTime.now()),
      Event(
          id: 6,
          title: "메뉴 이름 변경",
          datetime: DateTime.now(),
          modifiedBy: "김매니저",
          modifiedAt: DateTime.now(),
          reason: "메뉴 이름 변경",
          beforeModifiedAt: DateTime.now()),
    ],
  };

  List<Event> get currentEvents => events[currentTab] ?? [];

  @override
  void initState() {
    super.initState();
    dateRange = DateRange(start: DateTime.now(), end: DateTime.now());
    currentTab = '가게';
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
          child: ListView(shrinkWrap: false, children: [
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
                            dateRange = dateRange.copyWith(start: startDate);
                          });
                        },
                        onEndDateChanged: (DateTime endDate) {
                          setState(() {
                            dateRange = dateRange.copyWith(end: endDate);
                          });
                        },
                      ),
                      SizedBox(height: SGSpacing.p4),
                      SGContainer(
                        padding: EdgeInsets.symmetric(
                            horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                        width: double.infinity,
                        color: SGColors.primary,
                        borderRadius: BorderRadius.circular(SGSpacing.p2),
                        child: SGActionButton(
                            onPressed: () {
                              provider.getStoreHistory();
                            },
                            label: "조회"),
                      ),
                      SizedBox(height: SGSpacing.p4),
                      MenuTabBar(
                          currentTab: currentTab,
                          tabs: ["가게", "메뉴"],
                          onTabChanged: (String tab) {
                            setState(() {
                              currentTab = tab;
                            });
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
                      ...currentEvents.map((Event event) {
                        return _EventCard(
                            key: Key("${event.id}"), event: event);
                      }),
                    ]))
          ]),
        ));
  }
}

class _EventCard extends StatefulWidget {
  _EventCard({super.key, required this.event});
  Event event;

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
                              formatDateTime(widget.event.datetime),
                              color: SGColors.gray4,
                              size: FontSize.small,
                              weight: FontWeight.w500),
                          SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                          SGTypography.body(widget.event.title,
                              weight: FontWeight.w700, size: FontSize.normal),
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
                      ["작업자", widget.event.modifiedBy],
                      ["변경 시간", "${formatDateTime(widget.event.modifiedAt)}"],
                    ].map((List<String> pair) {
                      return [
                        DataTableRow(left: pair[0], right: pair[1]),
                        SizedBox(height: SGSpacing.p3)
                      ];
                    }).flattened,
                  ]),
              DataTableRow(
                  left: "변경 전",
                  right: "${formatDateTime(widget.event.beforeModifiedAt)}"),
            ],
          ],
        )));
  }
}
