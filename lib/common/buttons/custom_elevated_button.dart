import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading; // New parameter for loading state

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderRadius = 25.0, // Default border radius
    this.textStyle,
    this.isLoading = false, // Default value is false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ??
          double.infinity, // Use provided width or default to full width
      height: height ?? 60.0, // Use provided height or default to 50
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: textStyle ??
                    const TextStyle(
                      fontSize: 16,
                    ),
              ),
      ),
    );
  }
}
