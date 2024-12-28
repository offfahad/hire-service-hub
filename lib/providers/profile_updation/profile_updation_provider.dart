// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication_provider.dart';

class ProfileUpdationProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  final _profileCompleteFormKey = GlobalKey<FormState>();
  XFile? _profilePhoto;

  final TextEditingController idnumberController = TextEditingController();
  final TextEditingController addressCountryController =
      TextEditingController();
  final TextEditingController addressStateController = TextEditingController();
  final TextEditingController addresCityController = TextEditingController();
  final TextEditingController addressPostalCodeController =
      TextEditingController();
  final TextEditingController addressStreetNumberController =
      TextEditingController();

  String? selectedGender;
  // Replace TextEditingController with a String variable
  final TextEditingController bioController = TextEditingController();
  // Getter and setter for gender
  String? get gender => selectedGender;

  void updateGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  GlobalKey<FormState> get formKey => _formKey;
  GlobalKey<FormState> get profileCompleteFormKey => _profileCompleteFormKey;
  XFile? get profilePhoto => _profilePhoto;

  bool validateProfileUpdationForm() {
    // Ensure the form state is valid
    return _profileCompleteFormKey.currentState?.validate() ?? false;
  }

  Future<int> pickProfileImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      _profilePhoto = image;
      notifyListeners();

      // Get the AuthenticationProvider instance from the context
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      // Call the updateProfilePicture method here if the image is not null
      int responseCode = await authProvider.updateProfilePicture(image);

      if (responseCode == 200) {
        // Profile picture updated successfully
        print("Profile picture updated successfully.");
        return responseCode;
      }
      return responseCode;
    } else {
      // Handle case where no image is selected
      print("No image selected.");
      return -1;
    }
  }
}
