import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';

import '../components/snackbar.dart';

class ImageUploadScreen extends StatefulWidget {
  List<String> imagePaths = [];
  final String title;
  final String fieldLabel;
  final String buttonText;
  final int maximumImages;
  final Function(List<String>) onSubmit;

  ImageUploadScreen({
    super.key,
    required this.imagePaths,
    required this.title,
    required this.fieldLabel,
    required this.buttonText,
    required this.maximumImages,
    required this.onSubmit,
  });

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  static const columns = 3;

  /// 이미지 추가
  Future<void> addImage() async {
    if (widget.imagePaths.length >= widget.maximumImages) {
      showFailDialogWithImage(
        context: context,
        mainTitle: "최대 이미지 수 초과",
        subTitle: "이미지는 최대 ${widget.maximumImages}개까지 등록할 수 있습니다.",
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return; // 유저가 이미지를 선택하지 않음
    }

    final String imagePath = pickedFile.path;

    // 파일 확장자 확인
    final String fileExtension = imagePath.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png'];
    if (!allowedExtensions.contains(fileExtension)) {
      showFailDialogWithImage(
        context: context,
        mainTitle: "유효하지 않은 파일 형식",
        subTitle: "10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.",
      );
      return;
    }

    // 파일 크기 확인
    final File file = File(imagePath);
    final int fileSizeInBytes = await file.length();
    const int maxFileSizeInBytes = 10 * 1024 * 1024; // 10MB
    if (fileSizeInBytes > maxFileSizeInBytes) {
      showFailDialogWithImage(
        context: context,
        mainTitle: "파일 크기 초과",
        subTitle: "10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.",
      );
      return;
    }

    setState(() {
      widget.imagePaths.add(imagePath);
    });
  }

  /// 이미지 삭제
  void removeImage(int index) {
    setState(() {
      widget.imagePaths.removeAt(index);
    });
  }

  /// 이미지 슬롯 생성
  List<(int, String?)> get imageSlots => [
        ...widget.imagePaths,
        ...List.generate(
            widget.maximumImages - widget.imagePaths.length, (_) => null),
        ...List.generate(
            (widget.maximumImages + columns - 1) ~/ columns * columns -
                widget.maximumImages,
            (_) => null),
      ].mapIndexed((index, value) => (index, value)).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(title: widget.title),
      floatingActionButton: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
            maxHeight: 58),
        child: SGActionButton(
          onPressed: () {
            widget.onSubmit(widget.imagePaths);
            showGlobalSnackBar(context, "성공적으로 변경되었습니다.");
          },
          label: widget.buttonText,
        ),
      ),
      body: SGContainer(
        color: const Color(0xFFFAFAFA),
        padding: EdgeInsets.symmetric(
            horizontal: SGSpacing.p4, vertical: SGSpacing.p6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SGTypography.body(widget.fieldLabel,
                    color: SGColors.black,
                    weight: FontWeight.w700,
                    size: FontSize.normal),
                SGTypography.body(
                    "${widget.imagePaths.length}/${widget.maximumImages}",
                    color: SGColors.gray5,
                    weight: FontWeight.w500),
              ],
            ),
            SizedBox(height: SGSpacing.p3),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.maximumImages, (index) {
                  final imagePath = index < widget.imagePaths.length
                      ? widget.imagePaths[index]
                      : null;
                  return Padding(
                    padding: EdgeInsets.only(right: SGSpacing.p3),
                    child: GestureDetector(
                      onTap: imagePath == null
                          ? addImage
                          : () => removeImage(index),
                      child: SGContainer(
                        width: 110,
                        height: 110,
                        borderColor: SGColors.line2,
                        color: SGColors.white,
                        borderRadius: BorderRadius.circular(SGSpacing.p2),
                        child: imagePath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black, BlendMode.modulate),
                                    child: Image.asset(
                                      "assets/images/plus.png",
                                      width: SGSpacing.p6,
                                      height: SGSpacing.p6,
                                    ),
                                  ),
                                  SizedBox(height: SGSpacing.p2),
                                  SGTypography.body("이미지 등록",
                                      weight: FontWeight.w600,
                                      color: SGColors.gray5),
                                ],
                              )
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.file(
                                      File(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => removeImage(index),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: SGSpacing.p3),
            SGTypography.body("10MB 이하, JPG, PNG 형식의 파일을 등록해 주세요.",
                color: SGColors.gray4, weight: FontWeight.w500),
          ],
        ),
      ),
    );
  }
}
