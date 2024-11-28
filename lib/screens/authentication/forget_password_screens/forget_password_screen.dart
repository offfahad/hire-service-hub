// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/forget_password_provider.dart';
import 'package:e_commerce/screens/authentication/forget_password_screens/forget_password_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer2<AuthenticationProvider, ForgetPasswordProvider>(
      builder: (context, authProvider, forgetPasswordProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: size.height * 0.07),
                    const Text(
                      "Forget Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter your email to get an OTP which can lead to change the password.",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: forgetPasswordProvider.formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            label: 'Email',
                            controller: forgetPasswordProvider.emailController,
                            keyboardType: TextInputType.emailAddress,
                            focusNode: forgetPasswordProvider.emailFocusNode,
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
                          const SizedBox(height: 20),
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
                                  Navigator.pushReplacement(
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
                            width: size.width * 0.9,
                          ),
                        
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
