import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';

import '../constants/colors.dart';

void showSGDialogWithCloseButton({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding:
              EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Icon(Icons.close, color: Colors.black)),
                  ],
                ),
                SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05)
                      .copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showSGDialogWithImage({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding:
              EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05)
                      .copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: SGSpacing.p2),
                      Image.asset("assets/images/warning.png",
                          width: SGSpacing.p12),
                      SizedBox(height: SGSpacing.p3),
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showFailDialogWithImage({
  required BuildContext context,
  required String mainTitle,
  String? subTitle,
  VoidCallback? onTapFunction,
  VoidCallback? onNonEmptySubTitleTapFunction,
  String confirmButtonText = "확인",
}) {
  defaultTapAction() => Navigator.pop(context);
  final VoidCallback onTapAction = (subTitle == null || subTitle.isEmpty)
      ? (onTapFunction ?? defaultTapAction)
      : (onNonEmptySubTitleTapFunction ?? (onTapFunction ?? defaultTapAction));

  showSGDialogWithImage(
    context: context,
    childrenBuilder: (ctx) => [
      Center(
        child: SGTypography.body(
          mainTitle,
          size: FontSize.medium,
          weight: FontWeight.w700,
          lineHeight: 1.25,
          align: TextAlign.center,
        ),
      ),
      if (subTitle != null && subTitle.isNotEmpty) ...[
        SizedBox(height: SGSpacing.p4),
        Center(
          child: SGTypography.body(
            subTitle,
            color: SGColors.gray4,
            size: FontSize.small,
            weight: FontWeight.w700,
            lineHeight: 1.25,
            align: TextAlign.center,
          ),
        ),
      ],
      SizedBox(height: SGSpacing.p6),
      GestureDetector(
        onTap: onTapAction,
        child: SGContainer(
          color: SGColors.primary,
          width: double.infinity,
          borderColor: SGColors.primary,
          padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          child: Center(
            child: SGTypography.body(
              confirmButtonText,
              color: SGColors.white,
              weight: FontWeight.w700,
              size: FontSize.normal,
            ),
          ),
        ),
      ),
    ],
  );
}

void showSGDialogWithImageBoth({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding:
              EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding: EdgeInsets.symmetric(horizontal: SGSpacing.p05)
                      .copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: SGSpacing.p2),
                      Image.asset("assets/images/warning.png",
                          width: SGSpacing.p12),
                      SizedBox(height: SGSpacing.p3),
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}
void showAccountDeleteSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 193,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showLogOutSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 153,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 410,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showOperationSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 178,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  padding:
                  EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}

void showNewOrderSGDialog({
  required BuildContext context,
  required List<Widget> Function(BuildContext) childrenBuilder,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: SGContainer(
          height: 420,
          width: 303,
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SGContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...childrenBuilder(ctx),
                    ],
                  ),
                )
              ]),
        ),
      );
    },
  );
}
