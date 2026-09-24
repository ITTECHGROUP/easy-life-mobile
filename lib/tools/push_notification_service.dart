import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:easy_life_club/firebase_options.dart';

enum AppStates { background, foreground, terminated }

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();
  static Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    _messageStreamController.add({
      'app_state': AppStates.background,
      'title': message.notification?.title,
      'body': message.notification?.body,
      ...message.data,
    });
    log('onBackgroundHandler: ${message.data}');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStreamController.add({
      'app_state': AppStates.foreground,
      'title': message.notification?.title,
      'body': message.notification?.body,
      ...message.data,
    });
    log('onMessageHandler: ${message.data}');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    _messageStreamController.add({
      'app_state': AppStates.terminated,
      'title': message.notification?.title,
      'body': message.notification?.body,
      ...message.data,
    });
    log('onMessageOpenApp: ${message.data}');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    //handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static void closeStream() => _messageStreamController.close();

  static Future<String?> deviceToken() async {
    await requestPermission();
    try {
      return await FirebaseMessaging.instance.getToken();
    } on FirebaseException catch (e) {
      log('Error getting device token: ${e.message}');
      return null;
    }
  }

  static Future<AuthorizationStatus> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        await messaging.subscribeToTopic('all_devices');
      } else {
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          await messaging.subscribeToTopic('all_devices');
        }
      }
    } else {
      messaging.subscribeToTopic('all_devices');
    }
    
    print('Subscribed to topic: all_devices');
    return settings.authorizationStatus;
  }

  static Future<bool> hasPermission() async {
    AuthorizationStatus status =
        (await messaging.getNotificationSettings()).authorizationStatus;
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }
}
