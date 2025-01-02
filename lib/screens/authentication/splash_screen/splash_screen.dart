import 'dart:async';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/screens/authentication/starting_screen/get_started.dart';
import 'package:e_commerce/screens/bottom_navigation_bar.dart';
import 'package:e_commerce/services/authentication/auth_servcies.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/network_observer_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    // Get the access token from SharedPreferences
    String? accessToken = await AuthService.getAccessToken();

    if (accessToken != null) {
      // If access token exists, get user data
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final statusCode = await authProvider.getUserData();

      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Adjusted delay

      if (statusCode == 200) {
        // User is logged in, navigate to home screen
        showCustomSnackBar(context, "Welcome Back!", Colors.green);
        Navigator.of(context).pushReplacement(
          SlidePageRoute(
            page: const BottomNavigationBarScreen(),
          ),
        );
      } else {
        // User is not logged in or token refresh failed, navigate to login screen
        Navigator.of(context).pushReplacement(
          SlidePageRoute(
            page: const LoginScreen(),
          ),
        );
      }
    } else {
      // No access token found, navigate to onboarding screen
      Navigator.of(context).pushReplacement(
        SlidePageRoute(
          page: const GetStarted(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProviderNetworkObserver(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            // Center widget to ensure child is in the center
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      height: 26 / 20,
                    ),
                  ),
                ),
              ],
            ), // The widgt that should be centered
          ),
        ),
      ),
    );
  }
}
