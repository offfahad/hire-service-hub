import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final Size size;
  final String label;
  final String asset;
  final VoidCallback onPressed; // Function callback for tap events
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double paddingVertical;

  const CustomSocialButton({
    super.key,
    required this.size,
    required this.label,
    required this.asset,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.borderRadius = 10.0,
    this.paddingVertical = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width * 0.40,
        padding: EdgeInsets.symmetric(vertical: paddingVertical),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
