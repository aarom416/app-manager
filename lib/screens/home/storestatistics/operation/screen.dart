import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storestatistics/operation/provider.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}

class AppUtils {
  factory AppUtils() {
    return _singleton;
  }

  AppUtils._internal();

  static final AppUtils _singleton = AppUtils._internal();

  double degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  double radianToDegree(double radian) {
    return radian * 180 / math.pi;
  }

// Future<bool> tryToLaunchUrl(String url) async {
//   final uri = Uri.parse(url);
//   if (await canLaunchUrl(uri)) {
//     return await launchUrl(uri);
//   }
//   return false;
// }
}

class SGTooltip extends StatelessWidget {
  const SGTooltip({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      child: child,
    );
  }
}

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final orderStatisticsLabels = ['전체', '자세히'];
  final orderStatisticsPeriodLabels = ['최근 7일', '주간', '월간'];

  String selectedOrderStatisticsLabel = '전체';
  String selectedOrderStatisticsPeriodLabel = '최근 7일';

  bool collapsed = true;

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(storeStatisticsNotifierProvider.notifier)
          .loadStatisticsByStoreId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeStatisticsNotifierProvider);
    final provider = ref.read(storeStatisticsNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "통계"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
            child: ListView(children: [
              SizedBox(height: SGSpacing.p7),
              SGTypography.body("맞춤 식단 추천 횟수",
                  weight: FontWeight.w700,
                  size: FontSize.normal,
                  color: SGColors.black),
              SizedBox(height: SGSpacing.p3),
              MultipleInformationBox(children: [
                Text.rich(TextSpan(children: [
                  WidgetSpan(
                      child: SGTypography.body("최근 7일간",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                ])),
                Text.rich(TextSpan(children: [
                  WidgetSpan(
                      child: SGTypography.body("맞춤 식단 추천이 총 ",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                  WidgetSpan(
                      child: SGTypography.body("${state.dailyTotalCount}회",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.primary,
                          lineHeight: 1.5)),
                  WidgetSpan(
                      child: SGTypography.body("이에요.",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                ])),
                Histogram(
                    data: BarChartItemData(
                  labels: state.totalCharLabelDaily.isNotEmpty
                      ? state.totalCharLabelDaily
                      : ['', '', '', '', '', '', ''],
                  items: [
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[0].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[1].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[2].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[3].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[4].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[5].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                    [
                      BarChartItem(
                          value: state.storeStatistics
                                  .menuRecommendStatisticsDTOList.isNotEmpty
                              ? state.storeStatistics
                                  .menuRecommendStatisticsDTOList[6].count
                                  .toDouble()
                              : 0.0,
                          itemType: "추천"),
                    ],
                  ],
                )),
              ]),
              SizedBox(height: SGSpacing.p8),
              SGTypography.body("주문 고객 수",
                  weight: FontWeight.w700,
                  size: FontSize.normal,
                  color: SGColors.black),
              SizedBox(height: SGSpacing.p3),
              MultipleInformationBox(children: [
                Text.rich(TextSpan(children: [
                  WidgetSpan(
                      child: SGTypography.body("최근 7일간",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                ])),
                Text.rich(TextSpan(children: [
                  WidgetSpan(
                      child: SGTypography.body("주문 고객 수는 총 ",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                  WidgetSpan(
                      child: SGTypography.body("${state.dailyOrderCount}명",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.primary,
                          lineHeight: 1.5)),
                  WidgetSpan(
                      child: SGTypography.body("이에요.",
                          weight: FontWeight.w700,
                          size: FontSize.normal,
                          color: SGColors.black,
                          lineHeight: 1.5)),
                ])),
                SizedBox(height: SGSpacing.p4),
                renderSelectionChips(
                    labels: orderStatisticsLabels,
                    selectedLabel: selectedOrderStatisticsLabel,
                    onTap: (label) {
                      setState(() {
                        selectedOrderStatisticsLabel = label;
                      });
                    }),
                SizedBox(height: SGSpacing.p4),
                if (selectedOrderStatisticsLabel == '전체')
                  Histogram(
                      data: BarChartItemData(
                    labels: state.totalCharLabelDaily.isNotEmpty
                        ? state.totalCharLabelDaily
                        : ['', '', '', '', '', '', ''],
                    items: [
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[0].toDouble() +
                                    state.takeoutDailyCount[0].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[1].toDouble() +
                                    state.takeoutDailyCount[1].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[2].toDouble() +
                                    state.takeoutDailyCount[2].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[3].toDouble() +
                                    state.takeoutDailyCount[3].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[4].toDouble() +
                                    state.takeoutDailyCount[4].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[5].toDouble() +
                                    state.takeoutDailyCount[5].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount.isNotEmpty
                                ? state.deliveryDailyCount[6].toDouble() +
                                    state.takeoutDailyCount[6].toDouble()
                                : 0.0,
                            itemType: "추천"),
                      ],
                    ],
                  ))
                else ...[
                  Histogram(
                      data: BarChartItemData(
                    labels: state.totalCharLabelDaily,
                    items: [
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[0].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[0].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[1].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[1].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[2].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[2].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[3].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[3].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[4].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[4].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[5].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[5].toDouble(),
                            itemType: "포장"),
                      ],
                      [
                        BarChartItem(
                            value: state.deliveryDailyCount[6].toDouble(),
                            itemType: "배달"),
                        BarChartItem(
                            value: state.takeoutDailyCount[6].toDouble(),
                            itemType: "포장"),
                      ],
                    ],
                  )),
                  SizedBox(height: SGSpacing.p5),
                  SGContainer(
                    width: double.infinity,
                      borderColor: SGColors.line3,
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          SGContainer(
                            width: SGSpacing.p7 / 2,
                            height: SGSpacing.p7 / 2,
                            color: SGColors.warningOrange,
                            borderRadius: BorderRadius.circular(SGSpacing.p1),
                          ),
                          SizedBox(width: SGSpacing.p2),
                          SGTypography.body("배달",
                              size: FontSize.small,
                              color: SGColors.gray5,
                              weight: FontWeight.w700),
                          SizedBox(width: SGSpacing.p2),
                          SGTypography.body(
                              "최근 7일, ${state.deliveryCount}명이 배달 주문 했어요.",
                              size: FontSize.small,
                              color: SGColors.gray4),
                        ]),
                      )),
                  SizedBox(height: SGSpacing.p2),
                  SGContainer(
                    width: double.infinity,
                      borderColor: SGColors.line3,
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p3, vertical: SGSpacing.p3),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: [
                          SGContainer(
                            width: SGSpacing.p7 / 2,
                            height: SGSpacing.p7 / 2,
                            color: SGColors.success,
                            borderRadius: BorderRadius.circular(SGSpacing.p1),
                          ),
                          SizedBox(width: SGSpacing.p2),
                          SGTypography.body("포장",
                              size: FontSize.small,
                              color: SGColors.gray5,
                              weight: FontWeight.w700),
                          SizedBox(width: SGSpacing.p2),
                          SGTypography.body(
                              "최근 7일, ${state.takeoutCount}명이 포장 주문 했어요.",
                              size: FontSize.small,
                              color: SGColors.gray4),
                        ]),
                      )),
                  SizedBox(height: SGSpacing.p5),
                ],
                if (!collapsed) ...[
                  Divider(color: SGColors.line3, thickness: 1),
                  SizedBox(height: SGSpacing.p5),
                  renderSelectionChips(
                      labels: orderStatisticsPeriodLabels,
                      selectedLabel: selectedOrderStatisticsPeriodLabel,
                      onTap: (label) {
                        setState(() {
                          selectedOrderStatisticsPeriodLabel = label;
                          if (label == '주간') {
                            provider.loadStatisticsWeekByStoreId();
                          } else if (label == '월간') {
                            provider.loadStatisticsMonthByStoreId();
                          }
                        });
                      }),
                  SizedBox(height: SGSpacing.p4),
                  if (selectedOrderStatisticsPeriodLabel == '최근 7일')
                    SplineChart(
                        data: SplineChartItemData(
                            labels: state.totalCharLabelDaily,
                            items: [
                          // d''(x) > 1
                          FlSpot(
                              0,
                              state.deliveryDailyCount[0].toDouble() +
                                  state.takeoutDailyCount[0].toDouble()),
                          FlSpot(
                              1,
                              state.deliveryDailyCount[1].toDouble() +
                                  state.takeoutDailyCount[1].toDouble()),
                          FlSpot(
                              2,
                              state.deliveryDailyCount[2].toDouble() +
                                  state.takeoutDailyCount[2].toDouble()),
                          FlSpot(
                              3,
                              state.deliveryDailyCount[3].toDouble() +
                                  state.takeoutDailyCount[3].toDouble()),
                          FlSpot(
                              4,
                              state.deliveryDailyCount[4].toDouble() +
                                  state.takeoutDailyCount[4].toDouble()),
                          FlSpot(
                              5,
                              state.deliveryDailyCount[5].toDouble() +
                                  state.takeoutDailyCount[5].toDouble()),
                          FlSpot(
                              6,
                              state.deliveryDailyCount[6].toDouble() +
                                  state.takeoutDailyCount[6].toDouble()),
                        ]))
                  else if (selectedOrderStatisticsPeriodLabel == '주간')
                    SolidLineChart(
                      data: LineChartItemData(
                      labels: [
                        ...state.storeStatisticsWeekList.map((e) => e.weekName)
                      ],
                      items: [
                        FlSpot(0,
                            state.storeStatisticsWeekList[0].count.toDouble()),
                        FlSpot(1,
                            state.storeStatisticsWeekList[1].count.toDouble()),
                        FlSpot(2,
                            state.storeStatisticsWeekList[2].count.toDouble()),
                        FlSpot(3,
                            state.storeStatisticsWeekList[3].count.toDouble()),
                      ],
                    ))
                  else
                    SolidLineChart(
                        data: LineChartItemData(labels: [
                      ...state.storeStatisticsMonthList.map((e) => e.monthName)
                    ], items: [
                      FlSpot(0,
                          state.storeStatisticsMonthList[0].count.toDouble()),
                      FlSpot(1,
                          state.storeStatisticsMonthList[1].count.toDouble()),
                      FlSpot(2,
                          state.storeStatisticsMonthList[2].count.toDouble()),
                    ])),
                ],
                SizedBox(height: SGSpacing.p5),
                Row(children: [
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        collapsed = !collapsed;
                      });
                    },
                    child: SGContainer(
                      borderColor: SGColors.primary,
                      borderRadius: BorderRadius.circular(SGSpacing.p2),
                      padding: EdgeInsets.symmetric(
                          horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                      child: Row(children: [
                        SGTypography.body(collapsed ? "자세히" : "접기",
                            size: FontSize.small, color: SGColors.primary),
                      ]),
                    ),
                  )
                ]),
              ]),
              SizedBox(height: SGSpacing.p32),
            ])));
  }

  Row renderSelectionChips(
      {required String selectedLabel,
      required List<String> labels,
      required Function(String) onTap}) {
    return Row(children: [
      ...labels
          .map((e) => [
                GestureDetector(
                    onTap: () {
                      onTap(e);
                    },
                    child: SGContainer(
                        borderRadius: BorderRadius.circular(SGSpacing.p24),
                        padding: EdgeInsets.symmetric(
                            horizontal: SGSpacing.p4, vertical: SGSpacing.p3),
                        borderColor: e == selectedLabel
                            ? Color(0xFF79DF70).withOpacity(0.2)
                            : SGColors.line2,
                        color: e == selectedLabel
                            ? Color(0xFF79DF70).withOpacity(0.12)
                            : SGColors.white,
                        child: SGTypography.body(e,
                            size: FontSize.small,
                            color: e == selectedLabel
                                ? SGColors.primary
                                : SGColors.gray5))),
                SizedBox(width: SGSpacing.p2)
              ])
          .flattened
    ]);
  }
}

class Histogram extends StatefulWidget {
  Histogram({super.key, required this.data});

  final Color totalColor = SGColors.primary;
  final Color deliveredColor = SGColors.warningOrange;
  final Color takeoutColor = SGColors.success;

  final BarChartItemData data;

  @override
  State<StatefulWidget> createState() => HistogramState();
}

class BarChartItem {
  final double value;
  final String itemType;

  BarChartItem({required this.value, required this.itemType});
}

class BarChartItemData {
  List<String> labels;
  List<List<BarChartItem>> items;

  BarChartItemData({required this.labels, required this.items}) {}
}

class SplineChartItemData {
  List<String> labels;
  List<FlSpot> items;

  SplineChartItemData({required this.labels, required this.items}) {
    final maxValue = items.fold(
        0.0, (previousValue, element) => math.max(previousValue, element.x));
    assert(labels.length >= maxValue.toInt() - 1);
  }
}

class LineChartItemData {
  List<String> labels;
  List<FlSpot> items;

  LineChartItemData({required this.labels, required this.items}) {
    final maxValue = items.fold(
        0.0, (previousValue, element) => math.max(previousValue, element.x));
    assert(labels.length >= maxValue.toInt() - 1);
  }
}

class HistogramState extends State<Histogram> {
  Widget bottomTitles(double value, TitleMeta meta) {
    assert(value.toInt() <= widget.data.labels.length);
    const style = TextStyle(fontSize: FontSize.tiny, fontFamily: 'Pretendard');
    return SGContainer(
      padding: EdgeInsets.only(top: SGSpacing.p1),
      child: Text(
        widget.data.labels[value.toInt()],
        style: style,
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 20.0 * constraints.maxWidth / 400;
            final barsWidth = 40.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: EdgeInsets.all(SGSpacing.p2)
                        .copyWith(bottom: SGSpacing.p1),
                    fitInsideHorizontally: true,
                    tooltipMargin: SGSpacing.p4,
                    tooltipBorder: BorderSide(
                      color: SGColors.line3,
                      width: 1,
                    ),
                    getTooltipColor: (value) {
                      return SGColors.white;
                    },
                    tooltipRoundedRadius: 8,
                    // tooltipPadding: EdgeInsets.all(8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "",
                        textAlign: TextAlign.start,
                        TextStyle(
                          color: AppColors.contentColorWhite,
                          fontSize: FontSize.tiny,
                          height: 1.25,
                        ),
                        children: [
                          // WidgetSpan(child: SGContainer()),
                          TextSpan(
                            text: "${widget.data.labels[groupIndex]}",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              color: SGColors.black,
                              fontSize: FontSize.tiny,
                              height: 1.25,
                            ),
                          ),
                          ...widget.data.items[groupIndex]
                              .map((e) => [
                                    TextSpan(
                                      text: "\n${e.itemType} ",
                                      style: TextStyle(
                                          color: SGColors.black,
                                          fontSize: FontSize.tiny,
                                          fontFamily: 'Pretendard'),
                                    ),
                                    TextSpan(
                                      text: "${e.value.toInt()}명",
                                      style: TextStyle(
                                        color: labelToColorMap[e.itemType],
                                        fontSize: FontSize.tiny,
                                        fontFamily: 'Pretendard',
                                      ),
                                    )
                                  ])
                              .flattened,
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 10,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 10),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: AppColors.borderColor.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                  // drawVerticalLine: true,
                  // checkToShowVerticalLine: (value) => value % 1 == 0,
                  // getDrawingVerticalLine: (value) => FlLine(
                  //   color: AppColors.borderColor.withOpacity(0.1),
                  //   strokeWidth: 1,
                  // ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return widget.data.items
        .mapIndexed((index, item) => BarChartGroupData(
              x: index,
              barsSpace: barsSpace,
              barRods: [
                BarChartRodData(
                  toY: item.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + element.value),
                  rodStackItems: extractRodStackItems(item),
                  borderRadius: BorderRadius.circular(SGSpacing.p1),
                  width: barsWidth,
                ),
              ],
            ))
        .toList();
  }

  List<BarChartRodStackItem> extractRodStackItems(List<BarChartItem> item) {
    return item.mapIndexed((index, element) {
      final previousValue = item
          .sublist(0, index)
          .fold(0.0, (previousValue, element) => previousValue + element.value);
      return BarChartRodStackItem(previousValue, previousValue + element.value,
          labelToColorMap[element.itemType]!);
    }).toList();
  }

  Map<String, Color> labelToColorMap = {
    "추천": SGColors.primary,
    "배달": SGColors.warningOrange,
    "포장": SGColors.success,
  };
}

const horizontalLineColor = Color(0xFFF2F2F2);

class SplineChart extends StatefulWidget {
  final SplineChartItemData data;

  SplineChart({super.key, required this.data});

  @override
  State<SplineChart> createState() => _SplineChartState();
}

class _SplineChartState extends State<SplineChart> {
  List<Color> gradientColors = [
    SGColors.primary,
    Color(0xFF65DD7F),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSize.tiny,
      fontFamily: 'Pretendard',
      color: SGColors.gray5,
    );
    Widget text;
    assert(value.toInt() <= widget.data.labels.length);

    text = Text(widget.data.labels[value.toInt()], style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Container();
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (lineChartData, indices) {
          return [
            ...indices.map((index) => TouchedSpotIndicatorData(
                  FlLine(color: SGColors.line3, strokeWidth: 1, dashArray: [4]),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: SGColors.primary,
                        strokeWidth: 1,
                        strokeColor: SGColors.white,
                      );
                    },
                  ),
                )),
          ];
        },
        touchSpotThreshold: 20,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: SGSpacing.p2,
          tooltipPadding: EdgeInsets.all(SGSpacing.p1),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              final label = widget.data.labels[flSpot.x.toInt()];
              return LineTooltipItem(
                "$label\n",
                TextStyle(
                  color: SGColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.tiny,
                ),
                children: [
                  TextSpan(
                      text: "전체 ", style: TextStyle(color: SGColors.black)),
                  TextSpan(
                      text: "${flSpot.y.toInt()}",
                      style: TextStyle(color: SGColors.primary)),
                  TextSpan(text: "명", style: TextStyle(color: SGColors.black)),
                ],
                textAlign: TextAlign.start,
              );
            }).toList();
          },
          getTooltipColor: (value) {
            return SGColors.white;
          },
          tooltipBorder: BorderSide(
            color: SGColors.line3,
            width: 1,
          ),
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 20,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: horizontalLineColor, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: 0,
      maxX: widget.data.labels.length.toDouble() - 1,
      baselineY: 20,
      // showingTooltipIndicators: [ShowingTooltipIndicators([])],
      lineBarsData: [
        LineChartBarData(
          // show: false,
          spots: widget.data.items,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          // isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}

class SolidLineChart extends StatefulWidget {
  final LineChartItemData data;

  SolidLineChart({super.key, required this.data});

  @override
  State<SolidLineChart> createState() => _SolidLineChartState();
}

class _SolidLineChartState extends State<SolidLineChart> {
  List<Color> gradientColors = [
    SGColors.primary,
    Color(0xFF65DD7F),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: FontSize.tiny,
      fontFamily: 'Pretendard',
      color: SGColors.gray5,
    );
    Widget text;
    print(value);
    assert(value.toInt() <= widget.data.labels.length);

    text = Text(widget.data.labels[value.toInt()], style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Container();
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        getTouchedSpotIndicator: (lineChartData, indices) {
          return [
            ...indices.map((index) => TouchedSpotIndicatorData(
                  FlLine(color: SGColors.line3, strokeWidth: 1, dashArray: [4]),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: SGColors.primary,
                        strokeWidth: 1,
                        strokeColor: SGColors.white,
                      );
                    },
                  ),
                )),
          ];
        },
        touchSpotThreshold: 20,
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: SGSpacing.p2,
          tooltipPadding: EdgeInsets.all(SGSpacing.p1),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              final label = widget.data.labels[flSpot.x.toInt()];
              return LineTooltipItem(
                "$label\n",
                TextStyle(
                  color: SGColors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.tiny,
                ),
                children: [
                  TextSpan(
                      text: "전체 ", style: TextStyle(color: SGColors.black)),
                  TextSpan(
                      text: "${flSpot.y.toInt()}",
                      style: TextStyle(color: SGColors.primary)),
                  TextSpan(text: "명", style: TextStyle(color: SGColors.black)),
                ],
                textAlign: TextAlign.start,
              );
            }).toList();
          },
          getTooltipColor: (value) {
            return SGColors.white;
          },
          tooltipBorder: BorderSide(
            color: SGColors.line3,
            width: 1,
          ),
        ),
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 20,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: horizontalLineColor, strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: 0,
      maxX: widget.data.labels.length.toDouble() - 1,
      baselineY: 20,
      // showingTooltipIndicators: [ShowingTooltipIndicators([])],
      lineBarsData: [
        LineChartBarData(
          // show: false,
          spots: widget.data.items,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          // isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
    );
  }
}
