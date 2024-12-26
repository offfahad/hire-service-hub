import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/dialog_box/logout_dialogbox.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/screens/profile/more_screens/account_screens/account_screen.dart';
import 'package:e_commerce/screens/profile/profile_updation_screens/profile_details_screen.dart';
import 'package:e_commerce/screens/service/create_services_screen.dart';
import 'package:e_commerce/screens/service/my_services_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: size.height * 0.04,
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34.0),
                      child: CachedNetworkImage(
                        imageUrl: authProvider.user!.profilePicture!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 40.0,
                            height: 40.0,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          // Print the error to debug
                          debugPrint('Image load error: $error');
                          return Image.asset(
                              'assets/images/default-user.jpg');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${authProvider.user!.firstName} ${authProvider.user!.lastName}',
                    //'Frank Martin',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const ProfileDetailsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "View and Edit Profile",
                      style:
                          TextStyle(color: AppTheme.fMainColor, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),

                  const SizedBox(height: 8),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile Completion",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                                authProvider.user!.isComplete == true
                                    ? IconlyLight.tick_square
                                    : Icons.error,
                                size: 25,
                                color: authProvider.user!.isComplete == true
                                    ? AppTheme.fMainColor
                                    : Colors.red),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Complete your profile to appear more trustworthy.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  ListTile(
                    title: Text(
                      "Seller Mode",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.fMainColor),
                    ),
                    trailing: Switch(
                      value:
                          authProvider.user!.role!.title == "service_provider"
                              ? true
                              : false,
                      onChanged: (value) async {
                        await authProvider.switchRole();
                      },
                    ),
                  ),
                  const Divider(),
                  if (authProvider.user!.role!.title == "service_provider") ...[
                    ListTile(
                      leading: const Icon(
                        IconlyLight.plus,
                        size: 20,
                      ),
                      title: const Text(
                        'Create a New Service',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          SlidePageRoute(page: const CreateServiceScreen()),
                        );
                      },
                    ),
                    const Divider(),
                  ],
                  if (authProvider.user!.role!.title == "service_provider") ...[
                    ListTile(
                      leading: const Icon(
                        IconlyLight.paper,
                        size: 20,
                      ),
                      title: const Text(
                        'My Services',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          SlidePageRoute(
                            page: const MyServicesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                  ],

                  // Account Options
                  ListTile(
                    leading: const Icon(
                      IconlyLight.profile,
                      size: 20,
                    ),
                    title: const Text(
                      'Account',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(
                          page: const AccountScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(
                      IconlyLight.call,
                      size: 20,
                    ),
                    title: const Text(
                      'Contact Support',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    onTap: () {
                      // Navigator.of(context).push(
                      //   SlidePageRoute(
                      //     page: const WeHaveGotYourBack(),
                      //   ),
                      // );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.powerOff,
                      color: Colors.red,
                      size: 20,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    onTap: () {
                      showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
