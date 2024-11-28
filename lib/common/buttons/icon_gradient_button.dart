import 'package:flutter/material.dart';

class IconGradientButton extends StatelessWidget {
  final IconData icon; // Accepting custom icon
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const IconGradientButton({
    super.key,
    required this.icon, // Icon is required
    required this.onPressed, // onPressed callback
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Default width
      height: height, // Default height
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 45, 181, 98), // Green
            Color.fromARGB(255, 35, 123, 69), // Darker green
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed, // Call the provided onPress callback
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(0), // No extra padding
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ), // Display the custom icon
        ),
      ),
    );
  }
}
