import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

class ImageUploadScreen extends StatefulWidget {
  List<String> images = [];
  final String title;
  final String fieldLabel;
  final String buttonText;
  final int maximumImages;
  final Function(List<String>) onSubmit;

  ImageUploadScreen({
    Key? key,
    required this.images,
    required this.title,
    required this.fieldLabel,
    required this.buttonText,
    required this.maximumImages,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  static const columns = 3;
  List<(int, String?)> get imageSlots => [
        ...List.generate(widget.maximumImages, (index) => ""),
        ...List.generate(
            (widget.maximumImages + columns - 1) ~/ columns * columns - widget.maximumImages, (index) => null),
      ].mapIndexed((index, value) => (index, value)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: widget.title),
        floatingActionButton: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8, maxHeight: 58),
            child: SGActionButton(
                onPressed: () {
                  // widget.onSubmit(controller.text);
                  Navigator.of(context).pop();
                },
                label: widget.buttonText)),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
            child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SGTypography.body(widget.fieldLabel,
                      color: SGColors.black, weight: FontWeight.w700, size: FontSize.normal),
                  SGTypography.body("${widget.images.length}/${widget.maximumImages}",
                      color: SGColors.gray5, weight: FontWeight.w500),
                ],
              ),
              SizedBox(height: SGSpacing.p3),
              ...groupBy(imageSlots, (entry) => entry.$1 ~/ columns).entries.map((entry) {
                return Row(
                    children: entry.value
                        .mapIndexed(
                          (idx, image) => [
                            if (idx != 0) SizedBox(width: SGSpacing.p3),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: entry.value[idx].$2 == null
                                    ? Container()
                                    : SGContainer(
                                        borderColor: SGColors.line2,
                                        color: SGColors.white,
                                        borderRadius: BorderRadius.circular(SGSpacing.p2),
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                          ColorFiltered(
                                              colorFilter: ColorFilter.mode(Colors.black, BlendMode.modulate),
                                              child: Image.asset("assets/images/plus.png",
                                                  width: SGSpacing.p6, height: SGSpacing.p6)),
                                          SizedBox(height: SGSpacing.p2),
                                          SGTypography.body("이미지 등록", weight: FontWeight.w600, color: SGColors.gray5)
                                        ])),
                              ),
                            ),
                          ],
                        )
                        .flattened
                        .toList());
              }).toList(),
              Row(
                children: [],
              ),
              SizedBox(height: SGSpacing.p3),
              SGTypography.body("10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.", color: SGColors.gray4, weight: FontWeight.w500),
            ])));
  }
}
