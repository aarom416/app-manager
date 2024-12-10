import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:logger/logger.dart';
import 'package:singleeat/core/routers/app_router.dart';
import 'package:singleeat/core/utils/fcm.dart';
import 'package:singleeat/office/bloc/coupon_list_bloc.dart';
import 'package:singleeat/office/bloc/manager_bloc.dart';
import 'package:singleeat/office/bloc/store_bloc.dart';
import 'package:singleeat/office/bloc/store_list_bloc.dart';
import 'package:singleeat/screens/home_screen.dart';

import 'firebase_options.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showNotification(message);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel deliveryChannel = AndroidNotificationChannel(
  'delivery_channel',
  'Delivery Notifications',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('delivery-alarm'),
);

const AndroidNotificationChannel takeoutChannel = AndroidNotificationChannel(
  'takeout_channel',
  'Takeout Notifications',
  importance: Importance.high,
  sound: RawResourceAndroidNotificationSound('takeout-alarm'),
);

Future<void> _showNotification(RemoteMessage message) async {
  String notificationType = message.data['type'] ?? 'DELIVERY';

  AndroidNotificationDetails androidPlatformChannelSpecifics;
  if (notificationType == 'DELIVERY') {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'delivery_channel',
      'Delivery Notifications',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('delivery-alarm'),
    );
  } else {
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'takeout_channel',
      'Takeout Notifications',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('takeout-alarm'),
    );
  }

  final DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
    sound: notificationType == 'DELIVERY'
        ? 'delivery-alarm.wav'
        : 'takeout-alarm.wav',
  );

  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? '알림',
    message.notification?.body ?? '내용 없음',
    platformChannelSpecifics,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('user');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
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
    _showNotification(message);
  });

  initializeFCM();

  runApp(const ProviderScope(observers: [], child: RunApp()));
}

class RunApp extends ConsumerWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'singleat',
      routerConfig: ref.watch(goRouterProvider),
      theme: ThemeData(fontFamily: 'PRETENDARD'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ManagerBloc>(
            create: (BuildContext context) => ManagerBloc(),
          ),
          BlocProvider<StoreListBloc>(
              create: (BuildContext context) => StoreListBloc()),
          BlocProvider<StoreBloc>(
              create: (BuildContext context) => StoreBloc()),
          BlocProvider<CouponListBloc>(
              create: (BuildContext context) => CouponListBloc()),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorSchemeSeed: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
              useMaterial3: true,
            ),
            home: HomeScreen(title: 'Flutter Demo Home Page')));
  }
}
