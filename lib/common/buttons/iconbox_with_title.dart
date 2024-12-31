import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class IconBoxWithAppTitle extends StatelessWidget {
  const IconBoxWithAppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green Box with Icon
        Container(
          height: 34, // Height of the green box
          width: 34, // Width of the green box
          decoration: BoxDecoration(
            color: AppTheme.fMainColor, // Green color
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/service_icon.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        const SizedBox(width: 10), // Space between the icon and text
        // Text "E-Services"
        Text(
          'E-Services',
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
