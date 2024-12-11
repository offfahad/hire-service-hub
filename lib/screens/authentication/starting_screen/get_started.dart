import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // Center the title texts
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hire Service",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.fMainColor,
                      ),
                    ),
                    Text(
                      "Hub",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.fMainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom content
            Column(
              children: [
                Text(
                  "Find, Order & Enjoy!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.fMainColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.02,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: const Text(
                    "Find services you want to buy at your mobile and pay by your phone & enjoy happy, friendly Shopping!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                CustomGradientButton(
                  width: MediaQuery.of(context).size.width * 0.8,
                  text: "Get Started",
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      SlidePageRoute(
                        page: const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 50), // Optional padding for the bottom
          ],
        ),
      ),
    );
  }
}
