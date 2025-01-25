// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:e_commerce/main.dart';
import 'package:e_commerce/providers/notifications_count/notification_badge_provider.dart';
import 'package:e_commerce/screens/authentication/splash_screen/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission
    await _requestPermission();

    // Setup message handlers
    await _setupMessageHandlers();

    //setup flutter notifications
    await setupFlutterNotifications();

    // Get FCM token
    final token = await _messaging.getToken();
    print('FCM Token: $token');
    await saveFcmToken(token);

    subscribeToTopic('all_devices');
  }

  Future<void> saveFcmToken(String? token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios setup
    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // Handle iOS foreground notification
      },
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // flutter notification setup
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // if (details.payload == "chat") {
        //   navigatorKey.currentState!.push(
        //     MaterialPageRoute(
        //       builder: (context) => const LoginScreen(),
        //     ),
        //   );
        // }
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
        );
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> _setupMessageHandlers() async {
    //foreground message
    FirebaseMessaging.onMessage.listen((message) async {
      final type = message.data['type'] ?? 'default'; // Get type from data
      final title = message.data['title'] ?? 'default';
      final body = message.data['body'] ?? 'default'; // Get body from data
      final time = DateTime.now().toString();

      // Use navigatorKey to get the provider and increment count
      final context = navigatorKey.currentState?.context;
      if (context != null) {
        context.read<NotificationBadgeProvider>().incrementCount(type);

        if (type != 'chat') {
          await context
              .read<NotificationBadgeProvider>()
              .saveNotifications(title, body, time);
        }
      }
      showNotification(message);
    });

    // background message
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final type = message.data['type'] ?? 'default'; // Get type from data
      final title = message.data['title'] ?? 'default';
      final body = message.data['body'] ?? 'default'; // Get body from data
      final time = DateTime.now().toString();
      // Reset notification count when the app is opened
      final context = navigatorKey.currentState?.context;
      if (context != null) {
        context.read<NotificationBadgeProvider>().resetCount(type);
        if (type != 'chat') {
          await context
              .read<NotificationBadgeProvider>()
              .saveNotifications(title, body, time);
        }
      }

      _handleBackgroundMessage(message);
    });

    // opened app
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print('Subscribe to $topic');
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    //if (message.data['type'] == 'chat') {
    // Fetch the current context

    //pass this data from the server
    // {
    //   "type": "chat",
    //   "data": {
    //     "conversationId": "12345",
    //     "senderId": "67890",
    //     "senderName": "John Doe",
    //     "message": "Hey, how are you?",
    //     "timestamp": "2024-11-15T12:34:56Z"
    //   }
    // }

    // final conversationId = message.data['conversationId'];
    // final senderName = message.data['senderName'];
    //}
    navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      ),
    );
  }
}
