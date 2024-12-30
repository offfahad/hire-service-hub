import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String message, Color backgroundColor) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      maxLines: null,
    ),

    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating, // Change to floating if preferred
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(12),
    //     topRight: Radius.circular(12),
    //   ),
    // ),
    duration: const Duration(seconds: 3),
  );

  // Ensure the widget is mounted before showing the snackbar
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
