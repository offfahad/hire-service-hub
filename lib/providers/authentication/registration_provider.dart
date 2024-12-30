import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class RegistrationProvider extends ChangeNotifier {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: 'Pakistan',
    displayName: 'Pakistan',
    displayNameNoCountryCode: 'PK',
    e164Key: '',
  );

  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _phoneTouched = false;
  bool _emailTouched = false;
  bool _passwordTouched = false;

  bool get emailTouched => _emailTouched;
  bool get passwordTouched => _passwordTouched;

  bool get firstNameTouched => _firstNameTouched;
  bool get lastNameTouched => _lastNameTouched;
  bool get phoneTouched => _phoneTouched;

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

  void markFirstNameTouched() {
    if (!_firstNameTouched) {
      _firstNameTouched = true;
      notifyListeners();
    }
  }

  void markLastNameTouched() {
    if (!_lastNameTouched) {
      _lastNameTouched = true;
      notifyListeners();
    }
  }

  void markPhoneTouched() {
    if (!_phoneTouched) {
      _phoneTouched = true;
      notifyListeners();
    }
  }

  bool get obscurePassword => _obscurePassword;
  GlobalKey<FormState> get registerFormKey => _registerFormKey;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void selectCountry(Country country) {
    selectedCountry = country;
    notifyListeners();
  }

  String getFullPhoneNumber() {
    return '+${selectedCountry.phoneCode}${phoneController.text}';
  }

  // Dispose the controllers
  void disposeControllers() {
    phoneController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    notifyListeners();
  }

  bool validateForm() {
    return _registerFormKey.currentState!.validate();
  }

  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    notifyListeners();
  }
}
