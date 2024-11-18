import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class DeliveryAgencyScreen extends StatelessWidget {
  List<String> deliveryAgencies = ["바로고", "생각대로", "부릉"];

  DeliveryAgencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "배달 대행사 설정"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              SGTypography.body("연결 가능한 배달대행사",
                  size: FontSize.large, weight: FontWeight.w700),
              SizedBox(height: SGSpacing.p6),
              ...deliveryAgencies
                  .map((agency) => [
                        SGContainer(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
                          borderRadius: BorderRadius.circular(SGSpacing.p4),
                          borderColor: SGColors.line3,
                          boxShadow: SGBoxShadow.large,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SGTypography.body(agency,
                                      size: FontSize.normal),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {},
                                      child: Image.asset(
                                          "assets/images/plus-filled.png",
                                          width: 24,
                                          height: 24)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: SGSpacing.p2),
                      ])
                  .flattened,
            ])));
  }
}
