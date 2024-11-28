// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/login_provider.dart';
import 'package:e_commerce/screens/authentication/forget_password_screens/forget_password_screen.dart';
import 'package:e_commerce/screens/authentication/opt_verification_screen/opt_verification_screen.dart';
import 'package:e_commerce/screens/bottom_navigation_bar.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../register_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer2<AuthenticationProvider, LoginProvider>(
        builder: (context, authProvider, loginProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            // Wrap the content in a scrollable view
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize:
                    MainAxisSize.min, // Important for shrinking the Column
                children: [
                  SizedBox(height: size.height * 0.08),
                  // Image.asset(
                  //   "assets/logo.png",
                  //   width: MediaQuery.of(context).size.width * 0.60,
                  //   height: MediaQuery.of(context).size.height * 0.15,
                  // ),
                  Text(
                    "E-Services",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.fMainColor,
                    ),
                  ),
                  SizedBox(height: 20,),
                  const Text(
                    "Welcome to E-Services Hub",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    "Let's get started",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: loginProvider.loginFormKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          maxLines: 1,
                          label: 'Email',
                          controller: loginProvider.emailController,
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
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'Password',
                          controller: loginProvider.passwordController,
                          obscureText: loginProvider.obscurePassword,
                          isPasswordField: true,
                          toggleVisibility:
                              loginProvider.togglePasswordVisibility,
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            SlidePageRoute(
                              page: const ForgetPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.fMainColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomGradientButton(
                    text: "Login",
                    isLoading: authProvider.isLoading, // Show loading state
                    onPressed: () async {
                      if (loginProvider.validateForm()) {
                        // Call login and handle navigation based on the returned status code
                        final statusCode = await authProvider.login(
                          loginProvider.emailController.text
                              .toLowerCase()
                              .trim(),
                          loginProvider.passwordController.text.trim(),
                        );

                        if (statusCode == 200) {
                          loginProvider.clearControllers();
                          // Login successful, navigate to the BottomNavigationBarScreen
                          Navigator.of(context).pushReplacement(
                            SlidePageRoute(
                              page: const BottomNavigationBarScreen(),
                            ),
                          );
                          showCustomSnackBar(
                              context, "Login Successfully!", Colors.green);
                        } else if (statusCode == 401 || statusCode == 400) {
                          // Invalid credentials
                          showCustomSnackBar(
                              context, "Invalid Credentials", Colors.red);
                        } else if (statusCode == 409) {
                          // Unknown user
                          showCustomSnackBar(
                              context,
                              "Unknown User! No user is registered with this email.",
                              Colors.red);
                        } else if (statusCode == 403) {
                          // User already logged in
                          showCustomSnackBar(
                            context,
                            "User not verified. Please enter your OTP Code.",
                            Colors.red,
                          );
                          Navigator.of(context).pushReplacement(
                            SlidePageRoute(
                              page: const OptVerificationScreen(
                                email: "",
                              ),
                            ),
                          );
                        } else if (statusCode == -1) {
                          // Network or other error
                          showCustomSnackBar(context,
                              "Failed to login. Please try again.", Colors.red);
                        } else {
                          // Handle any other status codes
                          showCustomSnackBar(
                              context,
                              "Failed to login. Please try again. $statusCode",
                              Colors.red);
                        }
                      }
                    },
                    width: size.width * 0.9,
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          fontSize: 14,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.fMainColor,
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                SlidePageRoute(
                                  page: const RegisterScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 30),
                  // Row(
                  //   children: [
                  //     Expanded(child: Divider(color: Colors.grey.shade400)),
                  //     const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 10),
                  //       child: Text(
                  //         "Or sign in with",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(child: Divider(color: Colors.grey.shade400)),
                  //   ],
                  // ),
                  // const SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     CustomSocialButton(
                  //       onPressed: () {},
                  //       size: size,
                  //       label: "Google",
                  //       asset: "assets/icons/Google.jpg",
                  //     ),
                  //     CustomSocialButton(
                  //       onPressed: () {},
                  //       size: size,
                  //       label: "Facebook",
                  //       asset: "assets/icons/Facebook.png",
                  //     ),
                  //   ],
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 30),
                  //   child: RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //       text: "By logging in, you agree to Ajar's ",
                  //       style: TextStyle(
                  //           fontSize: size.width * 0.035, color: Colors.black87),
                  //       children: [
                  //         TextSpan(
                  //           text: "term of service and privacy policy.",
                  //           style: TextStyle(
                  //             fontSize: size.width * 0.035,
                  //             color: fMainColor,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
