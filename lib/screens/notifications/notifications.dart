import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            name: "Listing Published Successfully!",
            message: "Your gig is now live on Hire Service. Get ready!",
            time: "Just Now",
            avatarColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            name: "New Order Booked!",
            message:
                "You have a order a service. Review and confirm now!",
            time: "10 Minutes Ago",
            avatarColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            name: "Order Cancelled!",
            message:
                "The order has cancelled. See the order for details!",
            time: "1 Hour Ago",
            avatarColor: Theme.of(context).primaryColor,
          ),
        ],
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
      leading: CircleAvatar(
        backgroundColor: avatarColor,
        child: const Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(name),
      subtitle: Text(message),
      trailing: Text(time, style: const TextStyle(fontSize: 12)),
    );
  }
}
