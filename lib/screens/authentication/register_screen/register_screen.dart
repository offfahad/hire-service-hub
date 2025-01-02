import 'package:country_picker/country_picker.dart';
import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/buttons/iconbox_with_title.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/authentication/registration_provider.dart';
import 'package:e_commerce/screens/authentication/login_screen/login_screen.dart';
import 'package:e_commerce/screens/authentication/opt_verification_screen/opt_verification_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/network_observer_provider.dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../common/snakbar/custom_snakbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                child: Consumer2<AuthenticationProvider, RegistrationProvider>(
                    builder:
                        (context, authProvider, registrationProvider, child) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        SizedBox(height: height * 0.01),
                        Text(
                          'Sign Up',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 26 / 24,
                          ),
                        ),
                        SizedBox(height: height * 0.02),
      
                        Form(
                          key: registrationProvider.registerFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextFormField(
                                label: 'First Name',
                                controller:
                                    registrationProvider.firstNameController,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  registrationProvider.markFirstNameTouched();
                                },
                                autovalidateMode:
                                    registrationProvider.firstNameTouched
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 3) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextFormField(
                                label: 'Last Name',
                                controller:
                                    registrationProvider.lastNameController,
                                keyboardType: TextInputType.name,
                                onChanged: (value) {
                                  registrationProvider.markLastNameTouched();
                                },
                                autovalidateMode:
                                    registrationProvider.lastNameTouched
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 3) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              CustomTextFormField(
                                label: 'Email',
                                controller: registrationProvider.emailController,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) {
                                  registrationProvider.markEmailTouched();
                                },
                                autovalidateMode:
                                    registrationProvider.emailTouched
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
                              ),
                              SizedBox(height: height * 0.02),
                              customPhoneNumberTextFormField(
                                  context, registrationProvider),
                              SizedBox(height: height * 0.02),
                              CustomTextFormField(
                                label: 'Password',
                                controller:
                                    registrationProvider.passwordController,
                                obscureText: registrationProvider.obscurePassword,
                                isPasswordField: true,
                                onChanged: (value) {
                                  registrationProvider.markPasswordTouched();
                                },
                                autovalidateMode:
                                    registrationProvider.passwordTouched
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
                              SizedBox(height: height * 0.01),
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
                              SizedBox(height: height * 0.02),
                              CustomGradientButton(
                                text: "Sign Up",
                                onPressed: () async {
                                  if (registrationProvider.validateForm()) {
                                    final statusCode =
                                        await authProvider.registerUser(
                                      email: registrationProvider
                                          .emailController.text
                                          .toLowerCase()
                                          .trim(),
                                      phone: registrationProvider
                                          .getFullPhoneNumber(),
                                      password: registrationProvider
                                          .passwordController.text
                                          .trim(),
                                      firstName: registrationProvider
                                          .firstNameController.text,
                                      lastName: registrationProvider
                                          .lastNameController.text,
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
                                      showCustomSnackBar(context,
                                          "Validation error!", Colors.red);
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
                            ],
                          ),
                        ),
      
                        // Sign Up
                        SizedBox(height: height * 0.02),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                SlidePageRoute(
                                  page: const LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login',
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
      errorStyle: const TextStyle(height: 0),
      label: const Text('Phone Number'),
      labelStyle: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white : Colors.grey.shade500),
      fillColor:
          isDarkMode ? ThemeData.dark().scaffoldBackgroundColor : Colors.white,
      filled: true,
      counterText: '',
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDarkMode ? Colors.white : Colors.black,
            width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDarkMode ? Colors.white : Colors.black,
            width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade900, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDarkMode ? Colors.white : Colors.grey.shade500,
            width: 0.5),
      ),
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
