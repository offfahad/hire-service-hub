import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBadgeProvider with ChangeNotifier {
  final Map<String, int> _notificationCounts = {};
  List<Map<String, dynamic>> _notifications = [];

  int getNotificationCount(String type) => _notificationCounts[type] ?? 0;

  List<Map<String, dynamic>> get orderNotifications => _notifications;

  Future<void> loadNotificationCount(String type) async {
    final prefs = await SharedPreferences.getInstance();
    _notificationCounts[type] = prefs.getInt('${type}_notification_count') ?? 0;
    notifyListeners();
  }

  Future<void> incrementCount(String type) async {
    _notificationCounts[type] = (_notificationCounts[type] ?? 0) + 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        '${type}_notification_count', _notificationCounts[type]!);
    notifyListeners();
  }

  Future<void> resetCount(String type) async {
    _notificationCounts[type] = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${type}_notification_count', 0);
    notifyListeners();
  }

  Future<void> saveNotifications(String title, String body, String time) async {
    final prefs = await SharedPreferences.getInstance();

    final notification = {'title': title, 'body': body, 'time': time};

    _notifications.add(notification);

    final notificationsJson = jsonEncode(notification);

    await prefs.setString(notificationsJson, 'notification');

    notifyListeners();
  }

  Future<void> loadNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = prefs.getString('notification');
    if (notificationsJson != null) {
      _notifications =
          List<Map<String, dynamic>>.from(jsonDecode(notificationsJson));
      notifyListeners();
    }
  }
}
