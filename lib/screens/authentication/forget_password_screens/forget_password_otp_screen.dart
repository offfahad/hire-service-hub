// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/authentication/forget_password_screens/set_new_password_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  final String email;
  const ForgetPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgetPasswordOtpScreen> createState() =>
      _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {
  String otp = ''; // Variable to store OTP input
  bool isOtpValid = false; // Track if OTP length is valid (6 digits)
  final GlobalKey<FormState> _forgetOtpFormKey = GlobalKey<FormState>();

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
                key: _forgetOtpFormKey,
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
                onPressed: isOtpValid
                    ? () async {
                        int statusCode = await authProvider.verifyOTP(
                          widget.email,
                          otp,
                        );

                        if (statusCode == 200) {
                          // Navigate to Set New Password screen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SetNewPasswordScreen(email: widget.email),
                            ),
                          );
                        } else if (statusCode == 400) {
                          // Inform the user about the bad request
                          showCustomSnackBar(
                              context,
                              "Invalid OTP or Enter All 6 Digits!.",
                              Colors.red);
                        } else {
                          // Handle other error codes
                          showCustomSnackBar(
                              context,
                              "An error occurred. Please try again later.",
                              Colors.red);
                        }
                      }
                    : null, // Disable button if OTP is not valid
                isLoading: authProvider.isLoading, // Show loading state
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: "Didn't receive the OTP? ",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
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
