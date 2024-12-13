import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/extensions/integer.dart';

import '../model.dart';

class MenuModelCard extends StatelessWidget {
  final MenuModel menuModel;
  final VoidCallback? onRemove;

  const MenuModelCard({super.key, required this.menuModel, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return SGContainer(
      color: SGColors.white,
      borderRadius: BorderRadius.circular(SGSpacing.p4),
      boxShadow: SGBoxShadow.large,
      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4, horizontal: SGSpacing.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(SGSpacing.p4),
                child: Image.network(menuModel.menuPictureURL, width: SGSpacing.p18, height: SGSpacing.p18),
              ),
              SizedBox(width: SGSpacing.p3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 191,
                    child: SGTypography.body(
                      menuModel.menuName,
                      color: SGColors.black,
                      size: FontSize.normal,
                      weight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis
                    )),
                  SizedBox(height: SGSpacing.p2),
                  SGTypography.body("${menuModel.price.toKoreanCurrency}원", color: SGColors.gray4, size: FontSize.normal, weight: FontWeight.w400),
                ],
              ),
            ],
          ),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: SGContainer(
                borderWidth: 0,
                width: SGSpacing.p5,
                height: SGSpacing.p5,
                borderRadius: BorderRadius.circular(SGSpacing.p1 + SGSpacing.p05),
                color: SGColors.warningRed,
                child: Center(child: Image.asset('assets/images/minus-white.png', width: 16, height: 16)),
              ),
            ),
        ],
      ),
    );
  }
}
