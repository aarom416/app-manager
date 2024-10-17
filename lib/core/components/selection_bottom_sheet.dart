import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class SelectionOption<T> {
  final String label;
  final T value;

  SelectionOption({required this.label, required this.value});
}

void showSelectionBottomSheet<T>(
    {required BuildContext context,
    required String title,
    required List<SelectionOption<T>> options,
    required void Function(T) onSelect,
    required T selected}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    builder: (ctx) {
      return _SelectionBottomSheet(
        title: title,
        options: options,
        onSelect: onSelect,
        selected: selected,
      );
    },
  );
}

class _SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<SelectionOption<T>> options;
  final void Function(T) onSelect;
  final T selected;

  const _SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.onSelect,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SGContainer(
        color: Colors.transparent,
        padding: EdgeInsets.all(SGSpacing.p2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Container()),
            SGTypography.body(title, size: FontSize.medium, weight: FontWeight.w700),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    child: IconButton(
                        iconSize: SGSpacing.p6,
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
              ],
            )),
          ],
        ),
      ),
      Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        child: SGContainer(
          padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4).copyWith(bottom: SGSpacing.p4),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (ctx, idx) => GestureDetector(
                    onTap: () {
                      onSelect(options[idx].value);
                      Navigator.of(context).pop();
                    },
                    child: SGContainer(
                      padding: EdgeInsets.symmetric(vertical: SGSpacing.p4 + SGSpacing.p05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SGTypography.body(options[idx].label,
                              color: Color(0xFF444444), size: FontSize.normal, weight: FontWeight.w500),
                          if (selected == options[idx].value)
                            Image.asset("assets/images/check.png", width: 24, height: 24)
                        ],
                      ),
                    ),
                  ),
              separatorBuilder: (ctx, _) => Divider(
                    thickness: 1,
                    color: Color(0xFFF2F2F2),
                  ),
              itemCount: options.length),
        ),
      )
    ]);
  }
}
