import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/networks/request_api.dart';
import 'package:singleeat/core/networks/rest_api.dart';
import 'package:singleeat/main.dart';

class ProfileDeleteSessionService {
  final Ref ref;

  ProfileDeleteSessionService(this.ref);

  Future<Response<dynamic>> load() async {
    try {
      final response = ref.read(requestApiProvider).get(
            path: RestApiUri.loadNotification.replaceAll('{page}', '0'),
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

final profileDeleteSessionServiceProvider =
    Provider<ProfileDeleteSessionService>(
        (ref) => ProfileDeleteSessionService(ref));
