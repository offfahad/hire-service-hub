import 'package:e_commerce/common/buttons/custom_gradient_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/profile/more_screens/account_screens/close_account_screens/close_account_explanation_screen.dart';
import 'package:e_commerce/screens/profile/more_screens/account_screens/notification_setting_screen.dart';
import 'package:e_commerce/screens/profile/more_screens/account_screens/update_password_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int? selectedTransmission;
  String transmissionStatus = "No";
  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int tempSelectedValue = selectedTransmission ?? 2;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Manual Transmission',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Some cars have manual transmission. Are you able to drive a stick shift?',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                        height: 10), // Add spacing between radio options
                    RadioListTile<int>(
                      contentPadding: EdgeInsets.zero, // Remove default padding
                      value: 1,
                      groupValue: tempSelectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          tempSelectedValue = value!;
                        });
                      },
                      title: const Text(
                        'Yes, I’m able to drive a stick shift',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    RadioListTile<int>(
                      contentPadding: EdgeInsets.zero,
                      value: 2,
                      groupValue: tempSelectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          tempSelectedValue = value!;
                        });
                      },
                      title: const Text(
                        'No, I’m not able to drive a stick shift',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                CustomGradientButton(
                  onPressed: () {
                    // Pass the selected value back to the parent
                    Navigator.pop(context, tempSelectedValue);
                  },
                  text: 'Ok',
                  width: 80,
                  height: 40,
                  textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            );
          },
        );
      },
    ).then((selectedValue) {
      // This is called after the dialog is closed
      if (selectedValue != null) {
        setState(() {
          selectedTransmission = selectedValue;
          transmissionStatus = selectedTransmission == 1 ? 'Yes' : 'No';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // Add your back button functionality here
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SafeArea(
            child: ListView(
              children: [
                // Login Settings Section
                const SectionHeader(title: "Login Settings"),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  title: const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  subtitle: Text(
                    authProvider.user!.email!,
                    //"chwasilullah@gmail.com",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  trailing: Text(
                    "Verified",
                    style: TextStyle(
                        color: AppTheme.fMainColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  title: const Text(
                    "Phone",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  subtitle: Text(
                    authProvider.user!.phone!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  trailing: Text(
                    "Verified",
                    style: TextStyle(
                        color: AppTheme.fMainColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  title: const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  subtitle: const Text(
                    "Set New Password",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      SlidePageRoute(
                        page: const UpdatePasswordScreen(),
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 0,
                ),
                // Payment Settings Section
                const SectionHeader(title: "Payment Settings"),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  title: const Text("Add credit card",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  subtitle: const Text(
                    "Credit Money: \$0",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  onTap: () {
                    // Add functionality to add travel credit
                  },
                ),
                const Divider(
                  height: 0,
                ),

                // Notification Settings Section
                const SectionHeader(title: "Notification Settings"),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  title: const Text("Notification Manager",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  subtitle: const Text("Set notification here",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                  onTap: () {
                    Navigator.of(context).push(
                      SlidePageRoute(
                        page: const NotificationSettingScreen(),
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 0,
                ),
                // Additional Settings

                // Close Account Option
                ListTile(
                  title: const Text(
                    "Close Account",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      SlidePageRoute(
                        page: const CloseAccountExplanationScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Custom Widget for Section Headers
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppTheme.fMainColor,
          fontSize: 16,
        ),
      ),
    );
  }
}
