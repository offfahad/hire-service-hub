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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   "assets/logo.png",
            //   width: MediaQuery.of(context).size.width * 0.50,
            //   height: MediaQuery.of(context).size.height * 0.30,
            // ),
            Text(
              "E-Services",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppTheme.fMainColor,
              ),
            ),
            Text(
              "Hub",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppTheme.fMainColor,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                const Text(
                  "Find, Order & Enjoy!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF33bf2e),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.04,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: const Text(
                    "Find services you want to buy at your mobile and pay by your phone & enjoy happy, friendly Shopping!",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
