import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/core/networks/dio_service.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/main.dart';
import 'package:singleeat/office/models/result_response_model.dart';

class RequestApi {
  final Ref ref;

  RequestApi(this.ref);

  static Map<String, Object> getHeader({String? contentType}) {
    Map<String, Object> header = {
      'Authorization': 'Bearer ${UserHive.get().accessToken}'
    };

    if (contentType == null) {
      header['content-Type'] = RestApiUri.applicationJson;
    } else {
      header['content-Type'] = contentType;
    }

    return header;
  }

  Future<bool> dioException(Response response) async {
    logger.e("dioException: ${response.data}, $response");

    if (response.statusCode == 401) {
      try {
        final response = await Dio().post(
          '${RestApiUri.host}/api/v1/owner/token/access-token',
          options: Options().copyWith(headers: {
            'Authorization': 'Bearer ${UserHive.get().refreshToken}'
          }),
          queryParameters: {
            'fcmTokenId': UserHive.getBox(key: UserKey.fcmTokenId)
          },
        );

        if (response.statusCode == 200) {
          final result = ResultResponseModel.fromJson(response.data);
          String accessToken = (result.data['accessToken'] ?? '') as String;
          String refreshToken = (result.data['refreshToken']) as String;

          UserHive.set(
            user: UserHive.get().copyWith(
              accessToken: accessToken,
              refreshToken: refreshToken,
            ),
          );

          return true;
        } else {
          // 토큰 인증 기간이 만료됨
          ref.read(goRouterProvider).go(AppRoutes.login, extra: UniqueKey());
        }
      } on DioException catch (e) {
        return Future.error(e);
      } on Exception catch (e) {
        return Future.error(e);
      }
    }

    return false;
  }

  Future<Response<dynamic>> get<T>({
    required String path,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await DioServices().dio.get(path,
          data: data,
          queryParameters: queryParameters,
          options: (options == null)
              ? Options().copyWith(headers: getHeader())
              : options.copyWith(headers: getHeader()),
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress);

      return response;
    } on DioException catch (e) {
      Response? response = e.response;
      if (response == null) {
        return Future.error(e);
      } else {
        if (await dioException(response)) {
          return await get(
            path: path,
            data: data,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
          );
        }
      }

      return response;
    }
  }

  // 2023.06.21[holywater]: 공통 Post 처리
  Future<Response<dynamic>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String? contentType,
  }) async {
    try {
      final response = await DioServices().dio.post(path,
          data: data,
          queryParameters: queryParameters,
          options: (options == null)
              ? Options().copyWith(headers: getHeader(contentType: contentType))
              : options.copyWith(headers: getHeader(contentType: contentType)),
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (e) {
      Response? response = e.response;
      if (response == null) {
        return Future.error(e);
      } else {
        if (await dioException(response)) {
          return await post(
            path,
            data: data,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
            options: options,
            contentType: contentType,
            onSendProgress: onSendProgress,
          );
        }
      }

      return response;
    }
  }
}

final requestApiProvider = Provider<RequestApi>((ref) {
  return RequestApi(ref);
});
