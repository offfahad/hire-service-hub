import 'package:e_commerce/common/buttons/back_icon_button_with_title.dart';
import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/forget_password_provider.dart';
import 'package:e_commerce/screens/authentication/forget_password_screens/forget_password_otp_screen.dart';
import 'package:e_commerce/utils/network_observer_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../common/snakbar/custom_snakbar.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return ProviderNetworkObserver(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/background_image.jpg'),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), // Darken the image
                    BlendMode.darken, // Blend mode
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // App Title and Icon
            Padding(
                padding: EdgeInsets.only(
                  left: width * 0.05,
                  top: height * 0.1,
                ),
                child: BackIconButtonWithTitle(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: "Forget Password",
                    icon: IconlyLight
                        .arrow_left_2) // Replace with your custom widget
                // Replace with your custom widget
                ),
      
            // Login Form Container
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.80,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ThemeData.dark().scaffoldBackgroundColor
                      : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Consumer2<AuthenticationProvider, ForgetPasswordProvider>(
                    builder:
                        (context, authProvider, forgetPasswordProvider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        SizedBox(height: height * 0.01),
                        Text(
                          'Foreget Password',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 26 / 24,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
      
                        Form(
                          key: forgetPasswordProvider.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                label: 'Email',
                                controller:
                                    forgetPasswordProvider.emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomGradientButton(
                                text: "Submit",
                                onPressed: () async {
                                  if (forgetPasswordProvider.validateForm()) {
                                    int statusCode =
                                        await authProvider.requestNewOTP(
                                      forgetPasswordProvider.emailController.text
                                          .trim(),
                                    );
      
                                    if (statusCode == 200) {
                                      // Inform the user that the OTP has been sent
                                      showCustomSnackBar(
                                        context,
                                        "An OTP has been sent to ${forgetPasswordProvider.emailController.text.trim()}.",
                                        Colors.green,
                                      );
      
                                      // Navigate to the OTP screen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPasswordOtpScreen(
                                            email: forgetPasswordProvider
                                                .emailController.text
                                                .trim(),
                                          ),
                                        ),
                                      );
                                      forgetPasswordProvider.emailController
                                          .clear();
                                    } else if (statusCode == 400) {
                                      // Show failed OTP message
                                      showCustomSnackBar(
                                          context,
                                          "Failed to send OTP. Try again later.",
                                          Colors.red);
                                    } else {
                                      // Handle other errors
                                      showCustomSnackBar(
                                          context,
                                          "An error occurred: $statusCode",
                                          Colors.red);
                                    }
                                  }
                                },
                                isLoading: authProvider.isLoading,
                                width: width * 0.9,
                              ),
                            ],
                          ),
                        ),
      
                        // Sign Up
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
