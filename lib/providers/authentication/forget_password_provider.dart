import 'package:flutter/material.dart';

class ForgetPasswordProvider with ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController2 = TextEditingController();
  final FocusNode passwordFocusNode2 = FocusNode();

  bool obscurePassword = true;
  bool obscurePassword2 = true;

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    obscurePassword2 = !obscurePassword2;
    notifyListeners();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  bool validateForm2() {
    if (formKey2.currentState?.validate() ?? false) {
      if (passwordController.text.trim() != passwordController2.text.trim()) {
        // Return false if passwords don't match
        return false;
      }
      return true;
    }
    return false;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    passwordController2.clear();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    passwordFocusNode2.unfocus();
  }
}
