import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemNavigator
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetCheck {
  static final _internetConnectionStream = InternetConnection().onStatusChange;
  static StreamSubscription? _subscription;

  static Future<bool> isConnected() async {
    return await InternetConnection().hasInternetAccess;
  }

  static void listenToConnectionChanges(BuildContext context) {
    _subscription = _internetConnectionStream.listen((status) {
      if (status == InternetStatus.disconnected) {
        _showNoConnectionDialog(context);
      }
    });
  }

  static void dispose() {
    _subscription?.cancel();
  }

  static void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dialog from being dismissed
      builder: (_) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your network settings."),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Closes the app
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
