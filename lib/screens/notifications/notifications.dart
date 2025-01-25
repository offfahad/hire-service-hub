import 'package:e_commerce/providers/notifications_count/notification_badge_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final notifications =
        context.watch<NotificationBadgeProvider>().orderNotifications;

    // Sort the notifications by 'time' field (most recent first)
    notifications.sort((a, b) {
      DateTime timeA = DateTime.parse(a['time']);
      DateTime timeB = DateTime.parse(b['time']);
      return timeB.compareTo(timeA); // Descending order
    });

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Notifications"),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text("No notifications yet!"),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(
                  name: notification['title'],
                  message: notification['body'],
                  time: notification['time'],
                  avatarColor: AppTheme.fMainColor,
                );
              },
            ),
    );
  }

  Widget _buildNotificationItem({
    required String name,
    required String message,
    required String time,
    required Color avatarColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: const Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          Text(formatTime(time), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
