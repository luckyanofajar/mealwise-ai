import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // Coba request permission (bisa fail di emulator)
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('FCM Permission: ${settings.authorizationStatus}');

      // Ambil token
      String? token = await _fcm.getToken();
      debugPrint('🔥 FCM TOKEN: $token');

      // Listen foreground
      FirebaseMessaging.onMessage.listen((message) {
        debugPrint('📩 Foreground: ${message.notification?.title}');
      });

      // Background handler
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    } catch (e) {
      debugPrint('⚠️ FCM init failed (normal on emulator): $e');
    }
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    debugPrint('📩 Background: ${message.notification?.title}');
  }

  Future<String?> getToken() async {
    try {
      return await _fcm.getToken();
    } catch (e) {
      return null;
    }
  }
}