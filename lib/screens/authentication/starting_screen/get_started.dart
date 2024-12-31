import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/common/buttons/iconbox_with_title.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpg'),
                opacity: 0.4,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Overlay
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const IconBoxWithAppTitle(),
                    SizedBox(height: height * 0.03),
                    const Text(
                      'All services on your fingertips.',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        height: 36 / 30,
                      ),
                    ),
                    SizedBox(height: height * 0.07),
                    Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                              borderRadius: 12,
                              height: 58,
                              text: "Login",
                              onPressed: () {},
                              backgroundColor: AppTheme.fMainColor,
                              foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomElevatedButton(
                            borderRadius: 12,
                            height: 58,
                            text: "Sign Up",
                            onPressed: () {},
                            backgroundColor:
                                const Color.fromARGB(255, 51, 49, 51),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
            ],
          ),
        ],
      ),
    );
  }
}
