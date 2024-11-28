import 'package:flutter/material.dart';

class UpdatePasswordProvider with ChangeNotifier {
  final updatePasswordFormKey = GlobalKey<FormState>();
  
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController reEnterNewPasswordController = TextEditingController();
  
  bool oldObscurePassword = true;
  bool newObscurePassword = true;
  bool reEnterNewPassword = true;

  // Toggle password visibility
  void oldTogglePasswordVisibility() {
    oldObscurePassword = !oldObscurePassword;
    notifyListeners();
  }

  void newTogglePasswordVisibility() {
    newObscurePassword = !newObscurePassword;
    notifyListeners();
  }

  void reEnterTogglePasswordVisibility() {
    reEnterNewPassword = !reEnterNewPassword;
    notifyListeners();
  }

  // Method to validate the form
  bool validateForm() {
    if (updatePasswordFormKey.currentState!.validate()) {
      if (newPasswordController.text != reEnterNewPasswordController.text) {
        return false; // Passwords do not match
      }
      return true;
    }
    return false;
  }

  // Clear text fields
  void clearFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    reEnterNewPasswordController.clear();
  }
}
