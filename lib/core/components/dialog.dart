import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/spacing.dart';

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
          padding: EdgeInsets.all(SGSpacing.p4 - SGSpacing.p05).copyWith(bottom: 0),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              padding:
                  EdgeInsets.symmetric(horizontal: SGSpacing.p05).copyWith(bottom: SGSpacing.p5, top: SGSpacing.p3),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(SGSpacing.p3),
          padding: EdgeInsets.all(SGSpacing.p4).copyWith(bottom: 0),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGContainer(
              padding: EdgeInsets.only(bottom: SGSpacing.p5, top: SGSpacing.p6),
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
