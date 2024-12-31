import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackIconButtonWithTitle extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final IconData icon;
  const BackIconButtonWithTitle(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green Box with Icon
        CircleAvatar(
          backgroundColor: ThemeData().scaffoldBackgroundColor,
          radius: 25,
          child: Center(
              child: IconButton(onPressed: onPressed, icon: (Icon(icon)))),
        ),
        const SizedBox(width: 15), // Space between the icon and text
        Text(
          title,
          style: GoogleFonts.archivoBlack(
            textStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              height: 26 / 20,
            ),
          ),
        ),
      ],
    );
  }
}
