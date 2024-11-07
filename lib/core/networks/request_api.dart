import 'package:dio/dio.dart';
import 'package:singleeat/core/hive/user_hive.dart';
import 'package:singleeat/core/networks/dio_service.dart';
import 'package:singleeat/core/networks/rest_api.dart';

class RequestApi {
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

  static Future<bool> dioException(Response response) async {
    /*
    if (response.statusCode == 401) {
      ErrorModel error = ErrorModel.fromJson(response.data);
      if (error.code == "1201") {
        try {
          final response = await Dio().post(
            '${RestApiUri.host}/auth/v2/refresh',
            data: {
              'authorization': UserHive.get().authorization,
              'uid': UserHive.get().uid,
            },
            options: Options().copyWith(headers: getHeader()),
          );

          if (response.statusCode == 200) {
            UserHive.set(
                user: UserHive.get()
                    .copyWith(authorization: response.data['authorization']));

            return true;
          } else {
            // 토큰 인증 기간이 만료됨
            GoRouter.of(rootNavKey.currentContext!)
                .go(AppRoutes.loginRoute, extra: LoginStatus.expire);
          }
        } on DioException catch (e) {
          return Future.error(e);
        } on Exception catch (e) {
          return Future.error(e);
        }
      }
    }
     */
    return false;
  }

  static Future<Response<dynamic>> get<T>({
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
  static Future<Response<dynamic>> post<T>(
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
