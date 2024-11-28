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
