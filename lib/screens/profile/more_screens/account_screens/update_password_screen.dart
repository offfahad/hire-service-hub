import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/common/text_form_fields/custom_text_form_field.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/profile_updation/update_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<UpdatePasswordProvider, AuthenticationProvider>(
      builder: (context, updatePasswordProvider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.07),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    "Update Your Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Enter your old password and new password to confirm.",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: updatePasswordProvider.updatePasswordFormKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: 'Old Password',
                          controller:
                              updatePasswordProvider.oldPasswordController,
                          obscureText:
                              updatePasswordProvider.oldObscurePassword,
                          isPasswordField: true,
                          toggleVisibility: updatePasswordProvider
                              .oldTogglePasswordVisibility,
                          validator: (value) => passwordValidator(value),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'New Password',
                          controller:
                              updatePasswordProvider.newPasswordController,
                          obscureText:
                              updatePasswordProvider.newObscurePassword,
                          isPasswordField: true,
                          toggleVisibility: updatePasswordProvider
                              .newTogglePasswordVisibility,
                          validator: (value) => passwordValidator(value),
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'Re-enter New Password',
                          controller: updatePasswordProvider
                              .reEnterNewPasswordController,
                          obscureText:
                              updatePasswordProvider.reEnterNewPassword,
                          isPasswordField: true,
                          toggleVisibility: updatePasswordProvider
                              .reEnterTogglePasswordVisibility,
                          validator: (value) => passwordValidator(value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomGradientButton(
                    text: "Update Password",
                    isLoading: authProvider.isLoading,
                    onPressed: () {
                      if (updatePasswordProvider.validateForm()) {
                        authProvider
                            .updatePassword(
                          updatePasswordProvider.oldPasswordController.text,
                          updatePasswordProvider.newPasswordController.text,
                        )
                            .then((statusCode) {
                          handleResponse(statusCode, context);
                        });
                      } else {
                        showCustomSnackBar(
                            context,
                            "New password and re-entered password do not match!",
                            Colors.red);
                      }
                    },
                    width: size.width * 0.9,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Validator function for password fields
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  // Function to handle the response and show appropriate SnackBar messages
  void handleResponse(int statusCode, BuildContext context) {
    if (statusCode == 200) {
      showCustomSnackBar(
          context, "Password updated successfully!", Colors.green);
    } else if (statusCode == 401) {
      showCustomSnackBar(
          context, "Authentication token is required.", Colors.red);
    } else if (statusCode == 400) {
      showCustomSnackBar(context, "Old Password is incorrect!", Colors.red);
    } else if (statusCode == 500) {
      showCustomSnackBar(context,
          "New password must be different from the old password!", Colors.red);
    } else {
      showCustomSnackBar(context, "An unexpected error occurred.", Colors.red);
    }
  }
}
