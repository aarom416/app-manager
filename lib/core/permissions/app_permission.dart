import 'package:permission_handler/permission_handler.dart';
import 'package:singleeat/main.dart';

Future<void> requestPermissions() async {
  if (await Permission.photos.request().isGranted) {
    logger.i("사진 라이브러리 권한이 부여 되었습니다.");
  } else {
    logger.i("사진 라이브러리 권한이 필요합니다.");
  }

  if (await Permission.camera.request().isGranted) {
    logger.i("카메라 권한이 부여 되었습니다.");
  } else {
    logger.i("카메라 권한이 필요합니다.");
  }
}
