import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:singleeat/core/permissions/app_permission.dart';
import 'package:singleeat/main.dart';

Future<String> saveHtmlFile(String htmlContent) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  final file = File('$path/identity_verification.html');

  await file.writeAsString(htmlContent);

  return file.path;
}

Future<XFile?> pickImage() async {
  await requestPermissions();

  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    logger.i("선택한 이미지 경로: ${image.path}");
    return image;
  } else {
    logger.i("이미지를 선택하지 않았습니다.");
  }

  return null;
}

Future<String> checkFile(XFile? image) async {
  if (image == null) return '이미지를 선택하지 않았습니다.';

  // 파일 크기 및 확장자 검증
  final file = File(image.path);
  final fileSize = await file.length();
  final fileExtension = image.path.split('.').last.toLowerCase();

  // 10MB 이하인지 확인 (10MB = 10 * 1024 * 1024 bytes)
  if (fileSize > 10 * 1024 * 1024) {
    logger.i("파일 크기가 10MB를 초과합니다.");
    return '파일 크기가 10MB를 초과합니다.';
  }

  // 허용된 확장자인지 확인
  if (fileExtension != 'jpg' &&
      fileExtension != 'jpeg' &&
      fileExtension != 'png' &&
      fileExtension != 'pdf') {
    logger.i("허용되지 않은 파일 형식입니다. jpg, png, pdf만 가능합니다.");
    return '허용되지 않은 파일 형식입니다. jpg, png, pdf만 가능합니다.';
  }

  return '';
}
