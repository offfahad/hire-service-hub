import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/buttons/iconbox_with_title.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/login_provider.dart';
import 'package:e_commerce/screens/authentication/forget_password_screens/forget_password_screen.dart';
import 'package:e_commerce/screens/authentication/opt_verification_screen/opt_verification_screen.dart';
import 'package:e_commerce/screens/authentication/register_screen/register_screen.dart';
import 'package:e_commerce/screens/bottom_navigation_bar.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/network_observer_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../common/snakbar/custom_snakbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
              child:
                  const IconBoxWithAppTitle(), // Replace with your custom widget
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
                child: Consumer2<AuthenticationProvider, LoginProvider>(
                    builder: (context, authProvider, loginProvider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        SizedBox(height: height * 0.01),
                        Text(
                          'Log In',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 26 / 24,
                          ),
                        ),
                        SizedBox(height: height * 0.03),
      
                        Form(
                          key: loginProvider.loginFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                maxLines: 1,
                                label: 'E-Mail',
                                controller: loginProvider.emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  loginProvider.markEmailTouched();
                                },
                                autovalidateMode: loginProvider.emailTouched
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
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
                                showIcon: true,
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextFormField(
                                label: 'Password',
                                controller: loginProvider.passwordController,
                                obscureText: loginProvider.obscurePassword,
                                onChanged: (value) {
                                  loginProvider.markPasswordTouched();
                                },
                                autovalidateMode: loginProvider.passwordTouched
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                isPasswordField: true,
                                toggleVisibility:
                                    loginProvider.togglePasswordVisibility,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                                    return 'Password must contain at least one lowercase\nletter';
                                  } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                    return 'Password must contain at least one uppercase\nletter';
                                  } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                                    return 'Password must contain at least one number';
                                  } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                      .hasMatch(value)) {
                                    return 'Password must contain at least one special\ncharacter';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        //Login Button
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
                                Navigator.of(context).pushAndRemoveUntil(
                                  SlidePageRoute(
                                    page: const BottomNavigationBarScreen(),
                                  ),
                                  (Route<dynamic> route) =>
                                      false, // Removes all previous routes
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
                                showCustomSnackBar(
                                    context,
                                    "Failed to login. Please try again.",
                                    Colors.red);
                              } else {
                                // Handle any other status codes
                                showCustomSnackBar(
                                    context,
                                    "Failed to login. Please try again. $statusCode",
                                    Colors.red);
                              }
                            }
                          },
                          width: width * 0.9,
                        ),
                        SizedBox(height: height * 0.02),
                        // Forgot Password
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.grey),
                            onPressed: () {
                              Navigator.of(context).push(
                                SlidePageRoute(
                                  page: const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 22 / 16,
                              ),
                            ),
                          ),
                        ),
                        // Sign Up
                        SizedBox(height: height * 0.2),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                SlidePageRoute(
                                  page: const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: AppTheme.fMainColor,
                                fontWeight: FontWeight.normal,
                                height: 22 / 16,
                              ),
                            ),
                          ),
                        ),
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
