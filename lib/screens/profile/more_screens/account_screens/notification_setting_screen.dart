import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  bool isNotificationEnabled = false;
  bool isPromotionsEnabled = false;

  void setNotificationValue(bool value) {
    setState(() {
      isNotificationEnabled = value;
    });
  }

  void setPromotionValue(bool value) {
    setState(() {
      isPromotionsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notification Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button functionality here
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          // Login Settings Section
          const SectionHeader(title: "Mobile Notification"),
          const Divider(
            height: 0,
          ),
          ListTile(
            title: const Text(
              "Enable text message notification",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: Transform.scale(
              scale: 0.8, // Adjust the scale factor to reduce/increase the size
              child: Switch(
                value: isNotificationEnabled,
                onChanged: (value) {
                  setNotificationValue(value);
                },
              ),
            ),
          ),
          const Divider(
            height: 0,
          ),

          // Payment Settings Section
          const SectionHeader(title: "Email Notification"),
          const Divider(
            height: 0,
          ),
          ListTile(
            title: const Text(
              "Promotions & Announcement",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: isPromotionsEnabled,
                onChanged: (value) {
                  setPromotionValue(value);
                },
              ),
            ),
          ),
          const Divider(
            height: 0,
          ),
        ],
      ),
    );
  }
}

// Custom Widget for Section Headers
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppTheme.fMainColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
