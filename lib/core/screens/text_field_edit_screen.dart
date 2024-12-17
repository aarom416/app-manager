import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/office/providers/bad_word_provider.dart';
import 'package:singleeat/office/providers/text_field_edit_provider.dart';

class TextFieldEditScreen extends ConsumerStatefulWidget {
  final String value;
  final String title;
  final String hintText;
  final String buttonText;
  final TextInputType? keyboardType;
  final Function(String) onSubmit;

  const TextFieldEditScreen({
    Key? key,
    required this.value,
    required this.title,
    required this.hintText,
    required this.buttonText,
    this.keyboardType,
    required this.onSubmit,
  }) : super(key: key);

  @override
  ConsumerState<TextFieldEditScreen> createState() =>
      _TextFieldEditScreenState();
}

class _TextFieldEditScreenState extends ConsumerState<TextFieldEditScreen> {
  late String value;
  late TextEditingController controller = TextEditingController();

  TextStyle baseStyle =
      TextStyle(fontFamily: "Pretendard", fontSize: FontSize.small);

  @override
  void initState() {
    super.initState();
    value = widget.value;
    controller.text = widget.value;

    Future.microtask(() {
      ref.read(textFieldEditNotifierProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasBadWord = ref.watch(badWordNotifierProvider).hasBadWord;
    final isButton = ref.watch(textFieldEditNotifierProvider).isButton;
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      floatingActionButton: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
              maxHeight: 58),
          child: SGActionButton(
              disabled: hasBadWord
                  ? true
                  : isButton
                      ? false
                      : true,
              onPressed: () {
                if (isButton) {
                  if (!hasBadWord) {
                    widget.onSubmit(controller.text);
                  }
                }
              },
              label: widget.buttonText)),
      body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SGTypography.label("변경 전"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.all(SGSpacing.p4),
                hintText: widget.value,
                isCollapsed: true,
                hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                enabled: false,
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none),
              )),
            ),
            SizedBox(height: SGSpacing.p8),
            SGTypography.label("변경 후"),
            SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
            SGContainer(
              color: Colors.white,
              borderColor: SGColors.line3,
              borderRadius: BorderRadius.circular(SGSpacing.p3),
              child: TextField(
                  keyboardType: widget.keyboardType,
                  controller: controller,
                  style: baseStyle.copyWith(color: SGColors.black),
                  onChanged: (value) {
                    ref
                        .read(textFieldEditNotifierProvider.notifier)
                        .onChangeButton(true);

                    ref
                        .read(badWordNotifierProvider.notifier)
                        .checkBadWord(value);

                    setState(() {
                      this.value = value;
                    });
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(SGSpacing.p4),
                    isCollapsed: true,
                    hintText: widget.hintText,
                    hintStyle: baseStyle.copyWith(color: SGColors.gray3),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                  )),
            ),
            if (hasBadWord) ...[
              Padding(
                padding: EdgeInsets.only(top: SGSpacing.p2),
                child: const Text(
                  '욕설 및 비하 발언이 포함되어있습니다.\n다시 한 번 확인해주세요.',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFF62B2B),
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ),
            ],
          ])),
    );
  }
}
