import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/provider.dart';
import 'package:singleeat/screens/home/storemanagement/delivery/takeouttime/screen.dart';

import 'deliverytime/screen.dart';
import 'deliverytip/screen.dart';

class DeliveryScreen extends ConsumerStatefulWidget {
  const DeliveryScreen({super.key});

  @override
  ConsumerState<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends ConsumerState<DeliveryScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(deliveryNotifierProvider.notifier).getDeliveryTakeoutInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DeliveryState state = ref.watch(deliveryNotifierProvider);

    final DeliveryNotifier provider = ref.read(deliveryNotifierProvider.notifier);

    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: SGColors.primary,
      onRefresh: () async {
        provider.getDeliveryTakeoutInfo();
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // --------------------------- 배달 예상 시간 card ---------------------------
              MultipleInformationBox(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SGTypography.body("배달 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(width: SGSpacing.p2),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DeliveryTimeScreen(
                                      minDeliveryTime: state.minDeliveryTime,
                                      maxDeliveryTime: state.maxDeliveryTime,
                                      onSaveFunction: (minDeliveryTime, maxDeliveryTime) {
                                        // print("onSaveFunction $minDeliveryTime $maxDeliveryTime");
                                        provider.updateDeliveryTime(minDeliveryTime, maxDeliveryTime);
                                      },
                                    )));
                          },
                          child: const Icon(Icons.edit, size: FontSize.small)),
                    ],
                  ),
                  SGTypography.body("${state.minDeliveryTime} ~ ${state.maxDeliveryTime}분", color: SGColors.gray4, size: FontSize.normal)
                ])
              ]),

              SizedBox(height: SGSpacing.p3),

              // --------------------------- 픽업 예상 시간 card ---------------------------
              MultipleInformationBox(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SGTypography.body("픽업 예상 시간", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                      SizedBox(width: SGSpacing.p2),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TakeOutTimeScreen(
                                      minTakeOutTime: state.minTakeOutTime,
                                      maxTakeOutTime: state.maxTakeOutTime,
                                      onSaveFunction: (minTakeOutTime, maxTakeOutTime) {
                                        // print("onSaveFunction $minTakeOutTime $maxTakeOutTime");
                                        provider.updatePickupTime(minTakeOutTime, maxTakeOutTime);
                                      },
                                    )));
                          },
                          child: const Icon(Icons.edit, size: FontSize.small)),
                    ],
                  ),
                  SGTypography.body("${state.minTakeOutTime} ~ ${state.maxTakeOutTime}분", color: SGColors.gray4, size: FontSize.normal)
                ])
              ]),

              SizedBox(height: SGSpacing.p3),

              // --------------------------- 배달팁 card ---------------------------
              SGContainer(
                  padding: EdgeInsets.all(SGSpacing.p4),
                  borderRadius: BorderRadius.circular(SGSpacing.p4),
                  color: SGColors.white,
                  borderColor: SGColors.line2,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DeliveryTipScreen(
                                  baseDeliveryTip: state.baseDeliveryTip,
                                  deliveryTipMax: state.deliveryTipMax,
                                  minimumOrderPrice: state.minimumOrderPrice,
                                  storeDeliveryTipDTOList: state.storeDeliveryTipDTOList,
                                  deliveryTipInfo: state.deliveryDataModel.deliveryTipInfo,
                                  onSaveFunction: (baseDeliveryTip, minimumOrderPrice, storeDeliveryTipDTOList) {
                                    // print("onSaveFunction $baseDeliveryTip $minimumOrderPrice $storeDeliveryTipDTOList");
                                    provider.updateDeliveryTip(baseDeliveryTip, minimumOrderPrice, storeDeliveryTipDTOList);
                                  },
                                )));
                      },
                      child: Row(children: [
                        SGTypography.body("기본 배달팁", color: SGColors.black, size: FontSize.normal, weight: FontWeight.w600),
                        SizedBox(width: SGSpacing.p2),
                        Icon(Icons.edit, size: FontSize.small),
                      ]),
                    ),
                    SizedBox(height: SGSpacing.p5),
                    SGTypography.body("최소 주문 금액", color: SGColors.gray4, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p5 / 2),
                    Table(border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)), children: [
                      TableRow(children: [
                        Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("주문 금액", color: SGColors.black, weight: FontWeight.w700))),
                        Center(child: SGContainer(padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05), child: SGTypography.body("배달팁", color: SGColors.gray5, weight: FontWeight.w500))),
                      ]),
                      TableRow(children: [
                        Center(
                            child: SGContainer(
                                padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                child: SGTypography.body("${state.minimumOrderPrice.toKoreanCurrency}원 이상", color: SGColors.black, weight: FontWeight.w700))),
                        Center(
                            child: SGContainer(
                                padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                child: SGTypography.body("${state.baseDeliveryTip.toKoreanCurrency}원", color: SGColors.gray5, weight: FontWeight.w500))),
                      ])
                    ]),
                    SizedBox(height: SGSpacing.p4),
                    // if (state.storeDeliveryTipDTOList.isNotEmpty) ...[
                    SGTypography.body("배달팁 추가", color: SGColors.gray4, weight: FontWeight.w600),
                    SizedBox(height: SGSpacing.p5 / 2),
                    Table(border: TableBorder.all(color: SGColors.line2, borderRadius: BorderRadius.circular(SGSpacing.p3)), children: [
                      ...state.storeDeliveryTipDTOList.map((deliveryTipModel) => TableRow(children: [
                            Center(
                                child: SGContainer(
                                    padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                    child: SGTypography.body("${deliveryTipModel.minPrice.toKoreanCurrency}원 ~ ${deliveryTipModel.maxPrice.toKoreanCurrency}원",
                                        color: SGColors.black, weight: FontWeight.w700))),
                            Center(
                                child: SGContainer(
                                    padding: EdgeInsets.all(SGSpacing.p3 + SGSpacing.p05),
                                    child: SGTypography.body("${deliveryTipModel.deliveryTip.toKoreanCurrency}원", color: SGColors.gray5, weight: FontWeight.w500))),
                          ])),
                    ]),
                    // ],
                  ])),

              SizedBox(height: SGSpacing.p3),

              // --------------------------- 배달 지역 card ---------------------------
              MultipleInformationBox(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SGTypography.body(
                        "배달 지역",
                        color: SGColors.black,
                        size: FontSize.normal,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: SGSpacing.p2,
                      ),
                      Flexible(
                        child: SGTypography.body(
                          "현재는 ${state.deliveryAddress}에서만 배달 가능해요.",
                          color: SGColors.gray4,
                          size: FontSize.normal,
                          align: TextAlign.end
                        ),
                      ),
                    ],
                  ),
                ],
              ),
        ],
          ),
        ),
      ),
    );
  }
}
