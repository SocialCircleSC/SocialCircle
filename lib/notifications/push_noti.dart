import 'dart:async';

import 'package:socialorb/screens/messaging/message_home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // print('Title: ${message.notification?.title}');
  // print('Body: ${message.notification?.body}');
  // print('Payload: ${message.data}');
}

class PushNotifications {
  final firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) {
      return;
    }

    Navigator.push(BuildContext as BuildContext,
        MaterialPageRoute(builder: (context) => const MessageHome()));
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    //final fCMToken = await firebaseMessaging.getToken();
    //When a user creates an account. Get the user token so you can send a notification to them
    //print("Token:  $fCMToken");
    initPushNotifications();
  }
}
