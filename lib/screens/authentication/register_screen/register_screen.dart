// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/authentication/authentication_provider.dart';
import '../../../providers/authentication/registration_provider.dart';
import 'package:country_picker/country_picker.dart';

import '../opt_verification_screen/opt_verification_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Consumer2<RegistrationProvider, AuthenticationProvider>(
      builder: (context, registrationProvider, authProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
                child: Form(
                  key: registrationProvider.registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 21,
                          color: AppTheme.fMainColor,
                        ),
                      ),
                      const Text(
                        "Welcome to our hire-service application.",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        label: 'First Name',
                        controller: registrationProvider.firstNameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          registrationProvider.markFirstNameTouched();
                        },
                        autovalidateMode: registrationProvider.firstNameTouched
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(width: 10),
                      CustomTextFormField(
                        label: 'Last Name',
                        controller: registrationProvider.lastNameController,
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          registrationProvider.markLastNameTouched();
                        },
                        autovalidateMode: registrationProvider.lastNameTouched
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        label: 'Email',
                        controller: registrationProvider.emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          registrationProvider.markEmailTouched();
                        },
                        autovalidateMode: registrationProvider.emailTouched
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      customPhoneNumberTextFormField(
                          context, registrationProvider),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        label: 'Password',
                        controller: registrationProvider.passwordController,
                        obscureText: registrationProvider.obscurePassword,
                        isPasswordField: true,
                        onChanged: (value) {
                          registrationProvider.markPasswordTouched();
                        },
                        autovalidateMode: registrationProvider.passwordTouched
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        toggleVisibility:
                            registrationProvider.togglePasswordVisibility,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase \nletter';
                          } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase \nletter';
                          } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one \nnumber';
                          } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                              .hasMatch(value)) {
                            return 'Password must contain at least one special \ncharacter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "We’ll text you a OTP code to your email address to confirm your account.",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomGradientButton(
                        text: "Sign Up",
                        onPressed: () async {
                          if (registrationProvider.validateForm()) {
                            final statusCode = await authProvider.registerUser(
                              email: registrationProvider.emailController.text
                                  .toLowerCase()
                                  .trim(),
                              phone: registrationProvider.getFullPhoneNumber(),
                              password: registrationProvider
                                  .passwordController.text
                                  .trim(),
                              firstName:
                                  registrationProvider.firstNameController.text,
                              lastName:
                                  registrationProvider.lastNameController.text,
                            );

                            // Handle navigation based on status code
                            if (statusCode == 200) {
                              // Navigate to OTP verification screen
                              Navigator.of(context).pushReplacement(
                                SlidePageRoute(
                                  page: OptVerificationScreen(
                                    email: registrationProvider
                                        .emailController.text
                                        .toLowerCase()
                                        .trim(),
                                  ),
                                ),
                              );
                              registrationProvider.clearFields();
                            } else if (statusCode == 409) {
                              // Show user already exists error
                              showCustomSnackBar(context,
                                  "User already exists!", Colors.orange);
                            } else if (statusCode == 400) {
                              // Handle other errors
                              showCustomSnackBar(
                                  context, "Validation error!", Colors.red);
                            } else {
                              // Handle other errors
                              showCustomSnackBar(
                                  context,
                                  "Registration failed. Please try again.",
                                  Colors.red);
                            }
                          }
                        },
                        isLoading: authProvider.isLoading,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.fMainColor,
                                      fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushReplacement(
                                        SlidePageRoute(
                                          page: const LoginScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

TextFormField customPhoneNumberTextFormField(
    BuildContext context, RegistrationProvider registrationProvider) {
  // Determine the current brightness
  Brightness brightness = Theme.of(context).brightness;
  bool isDarkMode = brightness == Brightness.dark;

  return TextFormField(
    cursorColor: AppTheme.fMainColor,
    controller: registrationProvider.phoneController,
    maxLength: 15,
    textInputAction: TextInputAction.done,
    keyboardType: TextInputType.number,
    style: TextStyle(
      fontSize: 16,
      color: isDarkMode ? Colors.white : Colors.grey.shade900,
    ),
    onChanged: (value) {
      registrationProvider.markPhoneTouched();
      registrationProvider.phoneController.text = value;
    },
    autovalidateMode: registrationProvider.phoneTouched
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled,
    validator: (value) {
      // Phone number validation
      if (value == null || value.isEmpty) {
        return 'Please enter your phone number';
      }
      return null; // Return null if the input is valid
    },
    decoration: InputDecoration(
      fillColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey[200],
      filled: true,
      counterText: '',
      hintText: 'Phone Number',
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.grey.shade500,
        fontSize: 14,
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      prefixIcon: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 14.0, 8.0, 12.0),
        child: InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(
                backgroundColor:
                    isDarkMode ? AppTheme.fdarkBlue : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
                bottomSheetHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              onSelect: (Country country) {
                registrationProvider.selectCountry(country);
              },
            );
          },
          child: Text(
            //textAlign: TextAlign.center,
            ' +${registrationProvider.selectedCountry.phoneCode}',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? Colors.white
                  : registrationProvider.phoneController.text.isNotEmpty
                      ? Colors.grey.shade900
                      : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    ),
  );
}
