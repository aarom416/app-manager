import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:logger/logger.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/utils/fcm.dart';
import 'package:singleeat/screens/bottom/order/operation/screen.dart';

import 'core/routers/app_routes.dart';
import 'firebase_options.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showBackgroundNotification(message);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel deliveryChannel = AndroidNotificationChannel(
  'delivery_channel',
  '싱그릿 배달 주문 알림음',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('delivery_alarm'),
);

const AndroidNotificationChannel takeoutChannel = AndroidNotificationChannel(
  'takeout_channel',
  '싱그릿 포장 주문 알림음',
  importance: Importance.high,
    playSound: true,
  sound: RawResourceAndroidNotificationSound('takeout_alarm'),
);

Future<void> _showForegroundNotification(RemoteMessage message) async {
  String notificationType;
  if (message.data['type'] == 'DELIVERY') {
    notificationType = message.data['type'];
  } else if (message.data['type'] == 'TAKEOUT') {
    notificationType = message.data['type'];
  } else {
    notificationType = "DEFAULT";
  }

  AndroidNotificationDetails androidPlatformChannelSpecifics;
  if (notificationType == 'DELIVERY') {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'delivery_channel',
      '싱그릿 배달 주문 알림음',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "push_icon",
      color: Color(0xFF2CB682),
      sound: RawResourceAndroidNotificationSound('delivery_alarm'),
    );
  } else if (notificationType == 'TAKEOUT') {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'takeout_channel',
      '싱그릿 포장 주문 알림음',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "push_icon",
      color: Color(0xFF2CB682),
      sound: RawResourceAndroidNotificationSound('takeout_alarm'),
    );
  } else {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default_channel',
      '기본 알림음',
      importance: Importance.high,
      priority: Priority.high,
      icon: "push_icon",
      color: Color(0xFF2CB682),
    );
  }

  final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
    sound: notificationType == 'DELIVERY'
        ? 'delivery_alarm.wav'
        : notificationType == 'TAKEOUT'
        ? 'takeout_alarm.wav'
        : 'default',
  );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  flutterLocalNotificationsPlugin.show(
    Random().nextInt(100000),
    message.data['title'],
    message.data['body'],
    platformChannelSpecifics,
  );
}



Future<void> _showBackgroundNotification(RemoteMessage message) async {
  String notificationType;
  if (message.data['type'] == 'DELIVERY') {
    notificationType = message.data['type'];
  } else if (message.data['type'] == 'TAKEOUT') {
    notificationType = message.data['type'];
  } else {
    notificationType = "DEFAULT";
  }
  AndroidNotificationDetails androidPlatformChannelSpecifics;
  if (notificationType == 'DELIVERY') {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'delivery_channel',
      '싱그릿 배달 주문 알림음',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "push_icon",
      color: Color(0xFF2CB682),
      sound: RawResourceAndroidNotificationSound('delivery_alarm'),
    );
  } else if (notificationType == 'TAKEOUT'){
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'takeout_channel',
      '싱그릿 포장 주문 알림음',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      icon: "push_icon",
      color: Color(0xFF2CB682),
      sound: RawResourceAndroidNotificationSound('takeout_alarm'),
    );
  } else {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default_channel',
      '기본 알림음',
      importance: Importance.high,
      priority: Priority.high,
      icon: "push_icon",
      color: Color(0xFF2CB682),
    );
  }


  final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
    sound: notificationType == 'DELIVERY'
        ? 'delivery_alarm.wav'
        : notificationType == 'TAKEOUT'
        ? 'takeout_alarm.wav'
        : 'default',
    presentSound: true,
    presentAlert: true,
  );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    Random().nextInt(100000),
    message.data['title'],
    message.data['body'],
    platformChannelSpecifics,
  );
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('user');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isAndroid) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  } else if (Platform.isIOS) {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@drawable/push_icon'),
      iOS: DarwinInitializationSettings(),
    ),
  );

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(deliveryChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(takeoutChannel);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _showForegroundNotification(message);
  });

  initializeFCM();

  runApp(const ProviderScope(observers: [], child: RunApp()));
}

class RunApp extends ConsumerWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'singleat',
      routerConfig: goRouter,
      theme: ThemeData(fontFamily: 'PRETENDARD'),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider<ManagerBloc>(
//             create: (BuildContext context) => ManagerBloc(),
//           ),
//           BlocProvider<StoreListBloc>(
//               create: (BuildContext context) => StoreListBloc()),
//           BlocProvider<StoreBloc>(
//               create: (BuildContext context) => StoreBloc()),
//           BlocProvider<CouponListBloc>(
//               create: (BuildContext context) => CouponListBloc()),
//         ],
//         child: MaterialApp(
//             title: 'Flutter Demo',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData(
//               colorSchemeSeed: Colors.black,
//               appBarTheme: const AppBarTheme(
//                 backgroundColor: Colors.white,
//               ),
//               useMaterial3: true,
//             ),
//             home: HomeScreen(title: 'Flutter Demo Home Page')));
//   }
// }
