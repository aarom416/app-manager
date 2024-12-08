import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class DioServices {
  // 2024.08.29[holywater]: dio singleton
  static Dio _dio = Dio();

  // 2024.08.29[holywater]: 싱글톤 인스턴스 생성
  static final DioServices _dioServices = DioServices._internal();

  // 2024.08.29[holywater]: 외부에서 생성 불가하게 내부 생성자 정의
  DioServices._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: RestApiUri.host,
      connectTimeout: const Duration(milliseconds: 10000),
      receiveTimeout: const Duration(milliseconds: 10000),
      sendTimeout: const Duration(milliseconds: 10000),
    );
    _dio = Dio(options);

    _dio.interceptors.add(DioInterceptor());

    logger.i("baseUrl: ${_dio.options.baseUrl}");
  }

  // 2024.08.29[holywater]: 팩토리 생성자 사용해 싱글톤 반환
  factory DioServices() => _dioServices;

  // 2024.08.29[holywater]: 외부에서 dio 인스턴스 접근을 위해 getter 정의
  Dio get dio => _dio;
}

// 2024.08.29[holywater]: dio interceptor
class DioInterceptor extends Interceptor {
  // @override
  // void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //   logger.i('********************Request********************'
  //       'BaseUrl\t${options.baseUrl}\n'
  //       'Path\t${options.path}\n'
  //       'Header\t${options.headers}\n'
  //       'Parameters\t${options.queryParameters}\n'
  //       'Data\t${options.data}\n'
  //       '********************Request********************');
  //
  //   super.onRequest(options, handler);
  // }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String formattedData;
    try {
      formattedData = const JsonEncoder.withIndent('  ').convert(options.data);
    } catch (e) {
      formattedData = options.data.toString();
    }
    logger.i(
        '******************** Request ${options.path} ********************\n'
            'BaseUrl\t${options.baseUrl}\n'
            'Path\t${options.path}\n'
            'Header\t${options.headers}\n'
            'Parameters\t${options.queryParameters}\n'
            'Data\t$formattedData\n'
            '******************** End Request ********************');
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    String formattedData;
    try {
      formattedData = const JsonEncoder.withIndent('  ').convert(response.data);
    } catch (e) {
      formattedData = response.data.toString();
    }
    logger.i(
        '******************** Response ${response.requestOptions.path} ********************\n'
            'BaseUrl\t${response.requestOptions.baseUrl}\n'
            'Path\t${response.requestOptions.path}\n'
            'Header\t${response.requestOptions.headers}\n'
            'Parameters\t${response.requestOptions.queryParameters}\n'
            'StatusCode\t${response.statusCode}\n'
            'Data\t$formattedData\n'
            '******************** End Response ********************');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    //logger.e("Error $err");
    //logger.e("Error Message ${err.message}");
    super.onError(err, handler);
  }
}
