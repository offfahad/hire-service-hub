// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/screens/authentication/starting_screen/get_started.dart';
import 'package:e_commerce/screens/bottom_navigation_bar.dart';
import 'package:e_commerce/services/authentication/auth_servcies.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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

      await Future.delayed(const Duration(milliseconds: 500)); // Adjusted delay

      if (statusCode == 200) {
        // User is logged inno, navigate to home screen
        showCustomSnackBar(context, "Welcome Back!", Colors.green);
        Navigator.of(context).pushReplacement(
          SlidePageRoute(
            page: const BottomNavigationBarScreen(),
          ),
        );
      } else {
        // User is not logged in or token refresh failed, navigate to onboarding screen
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
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "E-Services",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.fMainColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
