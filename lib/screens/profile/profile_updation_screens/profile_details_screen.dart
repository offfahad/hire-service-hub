import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/profile_updation/profile_updation_provider.dart';
import 'package:e_commerce/screens/profile/profile_updation_screens/profile_updation_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/snakbar/custom_snakbar.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, ProfileUpdationProvider>(
      builder: (context, authProvider, profileUpdationProvider, child) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
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
                                    imageUrl:
                                        authProvider.user!.profilePicture!,
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
                                      return Image.asset(
                                          'assets/images/default_avatar.png');
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 15,
                                  child: InkWell(
                                      onTap: () async {
                                        // Show dialog to choose from gallery or camera
                                        await showModalBottomSheet(
                                          backgroundColor: isDarkMode
                                              ? AppTheme.fMainColor
                                              : Colors.white,
                                          context: context,
                                          builder: (context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: const Icon(
                                                      IconlyLight.camera),
                                                  title: const Text(
                                                      'Take a photo'),
                                                  onTap: () async {
                                                    final statusCode =
                                                        await profileUpdationProvider
                                                            .pickProfileImage(
                                                                context,
                                                                ImageSource
                                                                    .camera);
                                                    Navigator.pop(context);
                                                    if (statusCode == 200) {
                                                      showCustomSnackBar(
                                                        context,
                                                        'Profile photo updated successfully!',
                                                        Colors.green,
                                                      );
                                                    } else {
                                                      showCustomSnackBar(
                                                        context,
                                                        'Failed to update profile photo!',
                                                        Colors.red,
                                                      );
                                                    }
                                                  },
                                                ),
                                                ListTile(
                                                  leading: const Icon(
                                                      IconlyLight.image),
                                                  title: const Text(
                                                      'Choose from gallery'),
                                                  onTap: () async {
                                                    final statusCode =
                                                        await profileUpdationProvider
                                                            .pickProfileImage(
                                                                context,
                                                                ImageSource
                                                                    .gallery);
                                                    Navigator.pop(context);
                                                    if (statusCode == 200) {
                                                      showCustomSnackBar(
                                                        context,
                                                        'Profile photo updated successfully!',
                                                        Colors.green,
                                                      );
                                                    } else {
                                                      showCustomSnackBar(
                                                        context,
                                                        'Failed to update profile photo!',
                                                        Colors.red,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.add)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${authProvider.user!.firstName} ${authProvider.user!.lastName}",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Profile Completion",
                              style: TextStyle(
                                fontSize: 14,
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
                          'Profile with personal info and connected with email appear more trustworthy.',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  headingWidget("Verified Info"),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  customVerifiedListTile("Email", authProvider.user!.email!),
                  const Divider(),
                  customVerifiedListTile("Phone", authProvider.user!.phone!),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              color: AppTheme.fMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              SlidePageRoute(
                                page: const ProfileCompleteScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              color: AppTheme.fMainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      "Bio",
                      style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.fMainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(authProvider.user!.bio!),
                  ),
                  const Divider(),
                  customListTileMethod(
                      "National ID Card", "${authProvider.user!.cnic}"),
                  const Divider(),
                  customListTileMethod(
                      'Country', authProvider.user!.address!.country),
                  const Divider(),
                  customListTileMethod(
                      'State', authProvider.user!.address!.state),
                  const Divider(),
                  customListTileMethod(
                      'City', authProvider.user!.address!.city),
                  const Divider(),
                  customListTileMethod(
                      'Street No.', '${authProvider.user!.address!.streetNo}'),
                  const Divider(),
                  customListTileMethod(
                      'Postal Code', authProvider.user!.address!.postalCode),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget customVerifiedListTile(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(
          Icons.check_circle,
          color: AppTheme.fMainColor,
          size: 24,
        ),
      ),
    );
  }

  Widget headingWidget(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: TextStyle(
            color: AppTheme.fMainColor,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Widget customListTileMethod(String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        trailing: Text(trailing,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
      ),
    );
  }
}
