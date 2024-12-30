import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool get obscurePassword => _obscurePassword;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  // Add FocusNodes for both fields
  // Flags to track user interaction

  bool _emailTouched = false;
  bool _passwordTouched = false;

  bool get emailTouched => _emailTouched;
  bool get passwordTouched => _passwordTouched;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool validateForm() {
    return _loginFormKey.currentState?.validate() ?? false;
  }

  // Mark email as touched and notify listeners
  void markEmailTouched() {
    if (!_emailTouched) {
      _emailTouched = true;
      notifyListeners();
    }
  }
  
  // Mark password as touched and notify listeners
  void markPasswordTouched() {
    if (!_passwordTouched) {
      _passwordTouched = true;
      notifyListeners();
    }
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
