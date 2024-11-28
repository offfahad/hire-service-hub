// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class OptVerificationScreen extends StatefulWidget {
  final String email;
  const OptVerificationScreen({super.key, required this.email});

  @override
  State<OptVerificationScreen> createState() => _OptVerificationScreenState();
}

class _OptVerificationScreenState extends State<OptVerificationScreen> {
  String otp = ''; // Variable to store OTP input
  bool isOtpValid = false; // Track if OTP length is valid (6 digits)
  final GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthenticationProvider>(context);
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize:
                MainAxisSize.min, // Important for shrinking the Column
            children: [
              SizedBox(height: size.height * 0.07),
              const Text(
                "OTP",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                "Enter the OTP you received on your given email address ${widget.email}",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white : Colors.grey.shade600,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                key: _otpFormKey,
                appContext: context,
                length: 6,
                cursorHeight: 19,
                onChanged: (value) {
                  setState(() {
                    otp = value;
                    isOtpValid = otp.length == 6; // Check if OTP is 6 digits
                  });
                },
                cursorColor: AppTheme.fMainColor,
                enableActiveFill: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                pinTheme: PinTheme(
                  borderWidth: 0,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  shape: PinCodeFieldShape.box,
                  inactiveFillColor: Colors.grey.shade200,
                  selectedColor: Colors.grey.shade200,
                  selectedFillColor: Colors.grey.shade200,
                  activeColor: Colors.grey.shade200,
                  inactiveColor: Colors.grey.shade200,
                  activeFillColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(height: 20),
              CustomGradientButton(
                text: "Submit",
                isLoading: authProvider.isLoading, // Show loading state
                onPressed: isOtpValid
                    ? () async {
                        // Call verifyAccount and handle navigation based on the status code
                        final statusCode = await authProvider.verifyAccount(
                          email: widget.email,
                          otp: otp,
                        );
                        if (statusCode == 200) {
                          // OTP verified successfully, navigate to the Login screen
                          Navigator.of(context).pushReplacement(
                            SlidePageRoute(
                              page: const LoginScreen(),
                            ),
                          );
                          showCustomSnackBar(
                            context,
                            "Account is created successfully. You can login now.",
                            Colors.green,
                          );
                        } else if (statusCode == 400) {
                          // User already verified or bad request
                          showCustomSnackBar(
                            context,
                            "User is already verified.",
                            Colors.orange,
                          );
                        } else {
                          // Handle other error cases
                          showCustomSnackBar(
                            context,
                            "OTP verification failed. Please try again.",
                            Colors.red,
                          );
                        }
                      }
                    : null, // Disable button if OTP is not valid
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: "Didn't receive the OTP? ",
                  style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black87),
                  children: [
                    TextSpan(
                      text: "Request New",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppTheme.fMainColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final statusCode =
                              await authProvider.requestNewOTP(widget.email);
                          if (statusCode == 200) {
                            showCustomSnackBar(
                              context,
                              "A new OTP has been sent to ${widget.email}.",
                              Colors.green,
                            );
                          } else if (statusCode == 400) {
                            showCustomSnackBar(
                                context,
                                "Failed to send OTP. Please try again.",
                                Colors.red);
                          } else {
                            showCustomSnackBar(
                                context,
                                "An error occurred. Please try again later.",
                                Colors.red);
                          }
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
