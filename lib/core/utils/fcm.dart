import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:singleeat/core/hives/user_hive.dart';
import 'package:singleeat/main.dart';

void initializeFCM() async {
  await requestPermission();
  await getToken();
  setupMessageListener();
}

Future<void> requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<String> getToken() async {
  try {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    logger.i('FCM Token: $token');
    UserHive.setBox(key: UserKey.fcm, value: token);
    return token;
  } catch (e) {
    logger.e('Failed to get FCM token: $e');
    return '';
  }
}

void setupMessageListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            message.data['type'] == 'DELIVERY' ?
            deliveryChannel.id : takeoutChannel.id,
            message.data['type'] == "DELIVERY" ?
            deliveryChannel.name : takeoutChannel.name,
            channelDescription: deliveryChannel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    logger.i('A new onMessageOpenedApp event was published!');
  });
}