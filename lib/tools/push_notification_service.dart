import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:easy_life_club/firebase_options.dart';

enum AppStates { background, foreground, terminated }

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  // Last failure while getting tokens/subscribing; shown in the hidden diagnostics screen.
  static String lastError = '';
  static final StreamController<Map<String, dynamic>> _messageStreamController =
      StreamController.broadcast();
  static Stream<Map<String, dynamic>> get messageStream =>
      _messageStreamController.stream;

  // Must survive tree-shaking in release builds (runs in a separate isolate on Android).
  @pragma('vm:entry-point')
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
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      // Si Firebase ya fue inicializado previamente, atrapamos y silenciamos el error
      log('Firebase ya estaba inicializado: $e');
    }

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

  /// FCM token sent to the backend at login (the only time it is stored), so it must not come
  /// back empty: on iOS getToken() fails until the APNs token exists, which can take a few
  /// seconds after the permission prompt. requestPermission() already waits for APNs; retry
  /// getToken() a few times as well instead of logging in without a token.
  static Future<String?> deviceToken() async {
    await requestPermission();
    for (var attempt = 0; attempt < 4; attempt++) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null && token.isNotEmpty) return token;
      } catch (e) {
        lastError = 'getToken failed: $e';
        log('Device token not ready (attempt ${attempt + 1}): $e');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
    log('Could not get a device token; logging in without it');
    return null;
  }

  static Future<AuthorizationStatus> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    await ensureTopicSubscription();
    return settings.authorizationStatus;
  }

  /// Subscribes this device to the broadcast topic. Safe to call on every launch (idempotent):
  /// on iOS the APNs token can arrive late, so a single attempt at permission time may miss it.
  static Future<void> ensureTopicSubscription() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await messaging.getAPNSToken();
        for (var i = 0; apnsToken == null && i < 5; i++) {
          await Future.delayed(const Duration(seconds: 2));
          apnsToken = await messaging.getAPNSToken();
        }
        if (apnsToken == null) {
          lastError = 'APNs token not available after waiting (Apple did not register the device)';
          log('APNs token not available yet; will retry on next launch');
          return;
        }
      }
      await messaging.subscribeToTopic('all_devices');
      log('Subscribed to topic: all_devices');
    } catch (e) {
      lastError = 'Topic subscription failed: $e';
      log('Topic subscription failed, will retry on next launch: $e');
    }
  }

  static Future<bool> hasPermission() async {
    AuthorizationStatus status =
        (await messaging.getNotificationSettings()).authorizationStatus;
    return status == AuthorizationStatus.authorized ||
        status == AuthorizationStatus.provisional;
  }

  /// Snapshot for the hidden diagnostics screen (Settings → long-press the footer).
  static Future<Map<String, String>> diagnostics() async {
    final out = <String, String>{};
    try {
      final settings = await messaging.getNotificationSettings();
      out['Permission'] = settings.authorizationStatus.name;
    } catch (e) {
      out['Permission'] = 'error: $e';
    }
    if (Platform.isIOS) {
      try {
        final apns = await messaging.getAPNSToken();
        out['APNs token'] = apns == null ? 'MISSING' : 'OK (${apns.length} chars)';
      } catch (e) {
        out['APNs token'] = 'error: $e';
      }
    }
    try {
      final token = await messaging.getToken();
      out['FCM token'] = token ?? 'null';
    } catch (e) {
      out['FCM token'] = 'error: $e';
    }
    out['Last error'] = lastError.isEmpty ? '—' : lastError;
    return out;
  }
}
