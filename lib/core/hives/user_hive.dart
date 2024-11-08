import 'package:hive/hive.dart';
import 'package:singleeat/office/models/user_model.dart';

class UserHive {
  static void set({
    required UserModel user,
  }) {
    final box = Hive.box('user');
    final map = user.toJson();
    box.put('info', map);
  }

  static void setLoginId({
    required String loginId,
  }) {
    final box = Hive.box('user');
    box.put('loginId', loginId);
  }

  static UserModel get() {
    final box = Hive.box('user');
    final map = box.toMap();
    final Map<dynamic, dynamic>? userInfo = map['info'];

    if (userInfo == null) {
      return const UserModel();
    } else {
      final convertedMap = Map<String, dynamic>.fromEntries(
        userInfo.entries.map<MapEntry<String, dynamic>>(
          (entry) => MapEntry(entry.key.toString(), entry.value),
        ),
      );
      return UserModel.fromJson(convertedMap);
    }
  }

  static String getLoginId() {
    final box = Hive.box('user');
    final map = box.toMap();
    final String loginId = map['loginId'] ?? '';

    if (loginId.isEmpty) {
      return '';
    } else {
      return loginId;
    }
  }

  // 로그아웃
  static void clear() {
    final box = Hive.box('user');
    box.delete('info');
  }
}
