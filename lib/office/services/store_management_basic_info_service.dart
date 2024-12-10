import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreManagementBasicInfoService {
  final Ref ref;

  StoreManagementBasicInfoService(this.ref);

  Future<Response<dynamic>> storeInfo({required String storeId}) async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.storeInfo.replaceAll('{storeId}', storeId),
          );

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> storePhone({required String phone}) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.storePhone,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'storePhone': phone,
        },
      );

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> storeIntroduction({
    required String introduction,
  }) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.storeIntroduction,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'introduction': introduction,
        },
      );

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  Future<Response<dynamic>> storeOriginInformation({
    required String originInformation,
  }) async {
    try {
      final response = await ref.read(requestApiProvider).post(
        RestApiUri.originInformation,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'originURL': originInformation,
        },
      );

      return response;
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 가게 로고 등록 및 변경
  /*
      가게 로고 사진을 등록 및 변경합니다.
      가게 로고 사진 파일은 반드시 첨부해야 합니다.
      가게 로고 사진의 크기는 10MB 까지 전송가능하고 jpg, jpeg, png, gif, bmp, webp 형식만 가능합니다.
   */
  Future<Response<dynamic>> updateStoreThumbnail({
    required String storeId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        'thumbnailName': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      return await ref.read(requestApiProvider).post(
        RestApiUri.updateStoreThumbnail,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 가게 사진 등록 및 변경
  /*
      가게 사진을 등록 및 변경합니다.
      가게 사진은 최대 3개까지 등록 및 변경할 수 있습니다.
      가게 이미지 변경 페이지에서 사진 번호는 왼쪽부터 1번, 2번, 3번 입니다.
      반환된 번호에 따라 URL 이 반환됩니다. ex) { 1 : url, 2 : url, 3 : url}
      변경할 사진에 대해서만 사진 파일을 첨부하여 요청합니다.
      가게 사진의 크기는 10MB 까지 전송가능하고 jpg, jpeg, png, gif, bmp, webp 형식만 가능합니다.
   */
  Future<Response<dynamic>> updateStorePicture({
    required String storeId,
    required List<String> imagePaths,
  }) async {
    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        for (int i = 0; i < imagePaths.length; i++)
          'storePictures${i + 1}': await MultipartFile.fromFile(
            imagePaths[i],
            filename: imagePaths[i].split('/').last,
          ),
      });

      return await ref.read(requestApiProvider).post(
        RestApiUri.updateStorePicture,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }

  /// POST - 가게 소개 사진 등록 및 변경
  /*
      가게 소개 사진을 등록 및 변경합니다.
      가게 소개 사진 파일은 반드시 첨부해야 합니다.
      가게 소개 사진의 크기는 10MB 까지 전송가능하고 jpg, jpeg, png, gif, bmp, webp 형식만 가능합니다.
   */
  Future<Response<dynamic>> updateIntroductionPicture({
    required String storeId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'storeId': UserHive.getBox(key: UserKey.storeId),
        'introductionPicture': await MultipartFile.fromFile(imagePath, filename: imagePath.split('/').last),
      });

      return await ref.read(requestApiProvider).post(
        RestApiUri.updateIntroductionPicture,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
    } on DioException catch (e) {
      logger.e("DioException: ${e.message}");
      return Future.error(e);
    } on Exception catch (e) {
      logger.e(e);
      return Future.error(e);
    }
  }
}

final storeManagementBasicInfoServiceProvider =
    Provider<StoreManagementBasicInfoService>(
        (ref) => StoreManagementBasicInfoService(ref));
