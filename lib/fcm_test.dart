import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'main.dart';

class FcmTest extends StatefulWidget {
  const FcmTest({super.key});

  @override
  State<FcmTest> createState() => _FcmTestState();
}

class _FcmTestState extends State<FcmTest> {
  String? _token;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  void _initializeFCM() async {
    await _requestPermission();
    await _getToken();
    _setupMessageListener();
  }

  Future<void> _requestPermission() async {
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

  Future<void> _getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _token = token;
      });
      print('FCM Token: $_token');
    } catch (e) {
      print('Failed to get FCM token: $e');
    }
  }

  void _setupMessageListener() {
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
              deliveryChannel.id,
              deliveryChannel.name,
              channelDescription: deliveryChannel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TEST"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FCM Token:',
            ),
            Text(
              _token ?? 'Token not available',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
