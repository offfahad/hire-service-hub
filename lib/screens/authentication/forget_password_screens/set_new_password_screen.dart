// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/forget_password_provider.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  const SetNewPasswordScreen({super.key, required this.email});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
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
                    "Set New Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your new password and re-type it to confirm.",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: forgetPasswordProvider.formKey2,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: 'New Password',
                          controller: forgetPasswordProvider.passwordController,
                          obscureText: forgetPasswordProvider.obscurePassword,
                          focusNode: forgetPasswordProvider.passwordFocusNode,
                          isPasswordField: true,
                          toggleVisibility:
                              forgetPasswordProvider.togglePasswordVisibility,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least\n8 characters long';
                            } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'Password must contain at least\none lowercase letter';
                            } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'Password must contain at least\none uppercase letter';
                            } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Password must contain at\nleastone number';
                            } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return 'Password must contain at least\none special character';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'Re-type Password',
                          controller:
                              forgetPasswordProvider.passwordController2,
                          obscureText: forgetPasswordProvider.obscurePassword2,
                          focusNode: forgetPasswordProvider.passwordFocusNode2,
                          isPasswordField: true,
                          toggleVisibility:
                              forgetPasswordProvider.togglePasswordVisibility2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password';
                            } else if (value.length < 8) {
                              return 'Password must be at least\n8 characters long';
                            } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'Password must contain at least\none lowercase letter';
                            } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'Password must contain at least\none uppercase letter';
                            } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Password must contain at\nleastone number';
                            } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return 'Password must contain at least\none special character';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: "Set Password",
                    isLoading: authProvider.isLoading, // Show loading state
                    onPressed: () {
                      if (forgetPasswordProvider.validateForm2()) {
                        // Send only the new password to the authentication provider
                        authProvider
                            .resetForgetPassword(
                          widget.email,
                          forgetPasswordProvider.passwordController.text,
                        )
                            .then((statusCode) {
                          if (statusCode == 200) {
                            // Navigate to Login screen
                            Navigator.of(context).pushReplacement(
                              SlidePageRoute(
                                page: const LoginScreen(),
                              ),
                            );
                            // Inform the user about the successful password reset
                            showCustomSnackBar(context,
                                "Password reset successful!", Colors.green);
                            forgetPasswordProvider.clearFields();
                          } else if (statusCode == 400) {
                            // Here you can customize the message handling based on specific errors
                            // For the sake of this example, show a general error message
                            showCustomSnackBar(
                                context,
                                "Your previous password and new password should not be the same.",
                                Colors.red);
                          } else if (statusCode == 500) {
                            // Handle other error codes
                            showCustomSnackBar(
                                context,
                                "String must contain at least 8 character(s). New password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.",
                                Colors.red);
                          } else {
                            // Handle other error codes
                            showCustomSnackBar(context,
                                "An unexpected error occurred.", Colors.red);
                          }
                        });
                      } else {
                        // Show error message if passwords do not match
                        showCustomSnackBar(
                            context, "Passwords do not match!", Colors.red);
                      }
                    },
                    width: size.width * 0.9,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
