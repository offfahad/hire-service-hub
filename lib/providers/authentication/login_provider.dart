import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get obscurePassword => _obscurePassword;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  // Add FocusNodes for both fields

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool validateForm() {
    return _loginFormKey.currentState!.validate();
  }

  // Dispose the controllers
  void disposeControllers() {
    passwordController.dispose();
    emailController.dispose();
    notifyListeners();
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
