import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBadgeProvider with ChangeNotifier {
  final Map<String, int> _notificationCounts = {};

  int getNotificationCount(String type) => _notificationCounts[type] ?? 0;

  Future<void> loadNotificationCount(String type) async {
    final prefs = await SharedPreferences.getInstance();
    _notificationCounts[type] = prefs.getInt('${type}_notification_count') ?? 0;
    notifyListeners();
  }

  Future<void> incrementCount(String type) async {
    _notificationCounts[type] = (_notificationCounts[type] ?? 0) + 1;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${type}_notification_count', _notificationCounts[type]!);
    notifyListeners();
  }

  Future<void> resetCount(String type) async {
    _notificationCounts[type] = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${type}_notification_count', 0);
    notifyListeners();
  }
}
