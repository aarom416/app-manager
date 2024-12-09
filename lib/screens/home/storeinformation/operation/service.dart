import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class StoreInformationService {
  final Ref ref;

  StoreInformationService(this.ref);

  /// GET - 사업자 정보 페이지의 모든 정보를 조회
  Future<Response<dynamic>> getBusinessInformation(
      {required String storeId}) async {
    try {
      final response = ref.read(requestApiProvider).get(
        path:
            RestApiUri.getBusinessInformation.replaceAll('{storeId}', storeId),
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
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

  /// POST - 사업자 정보 업데이트
  /// 사업자 구분만 수정이 가능
  Future<Response<dynamic>> updateBusinessInformation(
      {required String storeId, required int businessType}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.updateBusinessInformation,
        data: {
          'storeId': UserHive.getBox(key: UserKey.storeId),
          'businessType': businessType,
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

  /// POST - 이메일 인증코드 전송
  Future<Response<dynamic>> sendEmailCode({required String email}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.sendEmailCode,
        queryParameters: {
          'email': email,
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

  /// POST - 이메일 인증코드 확인
  Future<Response<dynamic>> verifyEmailCode(
      {required String email, required String authCode}) async {
    try {
      final response = ref.read(requestApiProvider).post(
        RestApiUri.verifyEmailCode,
        data: {
          'email': email,
          'authCode': authCode,
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
}

final storeInformationServiceProvider =
    Provider<StoreInformationService>((ref) => StoreInformationService(ref));
