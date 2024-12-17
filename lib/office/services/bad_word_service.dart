import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/main.dart';

class BadWordService {
  final Ref ref;

  BadWordService(this.ref);

  Future<Response<dynamic>> checkBadWord(String input) async {
    try {
      final response = await Dio().get(
        'https://singleatapp.com/api/v1/user/auth/bad-word',
        queryParameters: {'word': input},
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

final badWordServiceProvider =
    Provider<BadWordService>((ref) => BadWordService(ref));
