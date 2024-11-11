import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
  initializeFCM();

  runApp(const ProviderScope(observers: [], child: RunApp()));
}

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'singleat',
      routerConfig: AppRouter().router,
      theme: ThemeData(fontFamily: 'PRETENDARD'),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
              // This is the theme of your application.
              //
              // TRY THIS: Try running your application with "flutter run". You'll see
              // the application has a purple toolbar. Then, without quitting the app,
              // try changing the seedColor in the colorScheme below to Colors.green
              // and then invoke "hot reload" (save your changes or press the "hot
              // reload" button in a Flutter-supported IDE, or press "r" if you used
              // the command line to start the app).
              //
              // Notice that the counter didn't reset back to zero; the application
              // state is not lost during the reload. To reset the state, use hot
              // restart instead.
              //
              // This works for code too, not just values: Most code changes can be
              // tested with just a hot reload.
              colorSchemeSeed: Colors.black,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
              ),
              useMaterial3: true,
            ),
            home: HomeScreen(title: 'Flutter Demo Home Page')));
  }
}
