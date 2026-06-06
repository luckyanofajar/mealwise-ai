import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotifService {
  static final FlutterLocalNotificationsPlugin _notifPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // FIX: Hanya 1 parameter (settings)
    await _notifPlugin.initialize(settings: settings);

    // Buat channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'mealwise_channel',
      'MealWise AI',
      description: 'Notifikasi dari MealWise AI',
      importance: Importance.max,
    );

    await _notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    debugPrint('✅ Local Notification initialized');
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'mealwise_channel',
      'MealWise AI',
      channelDescription: 'Notifikasi dari MealWise AI',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // FIX: Parameter pakai nama (named arguments)
    await _notifPlugin.show(
      id: DateTime.now().millisecond, // ID unik
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'mealwise_payload',
    );

    debugPrint('📲 Notifikasi muncul: $title - $body');
  }
}