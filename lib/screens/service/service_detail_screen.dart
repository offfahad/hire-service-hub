import 'package:carded/carded.dart';
import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/chat/conversation.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/chatting/chatting_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/chatting/chat_screen.dart';
import 'package:e_commerce/screens/orders/book_order_screen.dart';
import 'package:e_commerce/screens/service/update_service_screen.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../common/snakbar/custom_snakbar.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false)
          .fetchSingleServiceDetail(widget.service.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, ServiceProvider>(
        builder: (context, authProvider, serviceProvider, child) {
      Future<void> handleConversation(
          BuildContext context,
          ChattingProvider chatProvider,
          String hostId,
          String currentUserId) async {
        // First, check if a conversation already exists with the host
        Conversation? existingConversation;

        try {
          existingConversation = chatProvider.conversations.firstWhere(
            (conversation) =>
                conversation.members.contains(currentUserId) &&
                conversation.members.contains(hostId),
          );
          print("This is existing user result ${existingConversation}");
        } catch (e) {
          if (e is StateError) {
            existingConversation = null;
          } else {
            rethrow; // Unexpected error, rethrow it
          }
        }

        if (existingConversation != null) {
          // Navigate to the existing conversation
          Navigator.of(context).push(
            SlidePageRoute(
              page: ChatScreen(conversation: existingConversation),
            ),
          );
        } else {
          // No existing conversation, so create a new one
          int statusCode = await chatProvider.startConversation(
              hostId, authProvider.user!.id!);

          if (statusCode == 200) {
            // Fetch updated conversations
            await chatProvider.fetchConversations();

            try {
              // Check again for the newly created conversation
              existingConversation = chatProvider.conversations.firstWhere(
                (conversation) =>
                    conversation.members.contains(currentUserId) &&
                    conversation.members.contains(hostId),
              );

              // Navigate to the newly created conversation
              Navigator.of(context).push(
                SlidePageRoute(
                  page: ChatScreen(conversation: existingConversation),
                ),
              );
            } catch (e) {
              if (e is StateError) {
                showCustomSnackBar(
                    context,
                    "Conversation created, but couldn't be found in the list.",
                    Colors.red);
              } else {
                rethrow; // Unexpected error, rethrow it
              }
            }
          } else {
            // Handle error if conversation creation failed
            showCustomSnackBar(context,
                chatProvider.errorMessage ?? "Error occurred", Colors.red);
          }
        }
      }

      final isServiceProvider =
          authProvider.user?.role?.title == "service_provider" &&
              authProvider.user?.id ==
                  serviceProvider.service?.data?.specificService?.userId;

      return Scaffold(
        appBar: AppBar(
            forceMaterialTransparency: true,
            title: const Text(
              "Service Details",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: isServiceProvider
                ? [
                    IconButton(
                      icon: const Icon(IconlyLight.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateServiceScreen(
                            serviceDetail: serviceProvider.service!,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(IconlyLight.delete),
                      onPressed: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Service"),
                              content: const Text(
                                  "Are you sure you want to delete this service?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(false), // Cancel
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(true), // Confirm
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldDelete == true) {
                          // Call the provider method to delete the service
                          await Provider.of<ServiceProvider>(context,
                                  listen: false)
                              .deleteService(widget.service.id);

                          final provider = Provider.of<ServiceProvider>(context,
                              listen: false);
                          if (provider.errorMessage == null) {
                            // Show success message
                            showCustomSnackBar(context,
                                "Service deleted successfully!", Colors.green);
                            Navigator.pop(context); // Navigate back
                          } else {
                            // Show error message
                            showCustomSnackBar(
                                context, provider.errorMessage!, Colors.red);
                          }
                        }
                      },
                    ),
                  ]
                : null),
        body: Consumer<ServiceProvider>(
          builder: (context, serviceProvider, child) {
            if (serviceProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (serviceProvider.errorMessage?.isNotEmpty ?? false) {
              return Center(child: Text(serviceProvider.errorMessage!));
            }

            final service = serviceProvider.service?.data?.specificService;
            if (service == null) {
              return const Center(child: Text("No service details available."));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  service.coverPhoto != null
                      ? Image.network(
                          '${service.coverPhoto}',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/content-writer.webp',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.serviceName ?? "No Name",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            const Icon(
                              IconlyBold.star,
                              color: Colors.amber,
                            ),
                            Text(
                              serviceProvider.service?.data?.averageRating
                                      ?.toString() ??
                                  "0.0",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      service.description ?? "",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Availability",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(IconlyLight.location),
                        const SizedBox(width: 12),
                        Text(service.city ?? ""),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(IconlyLight.time_circle),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "${getFormattedTime12Hour(service.startTime.toString())} - ${getFormattedTime12Hour(service.endTime.toString())}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // Reviews Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Reviews",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: serviceProvider
                                    .service!.data!.specificService!.reviews ==
                                null ||
                            serviceProvider.service!.data!.specificService!
                                .reviews!.isEmpty
                        ? const Center(
                            child: Text(
                              "No reviews yet!",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        : Column(
                            children: serviceProvider
                                .service!.data!.specificService!.reviews!
                                .map(
                                  (review) => ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        review.userImage ??
                                            "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg", // Placeholder image
                                      ),
                                    ),
                                    title: Text(review.userName ?? "Anonymous"),
                                    subtitle: Text(review.comment ??
                                        "No comment provided."),
                                  ),
                                )
                                .toList(), // Convert iterable to a list of widgets
                          ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Service Provider",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(service.user?.profilePicture),
                          radius: 20,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${service.user?.firstName ?? "Unknown"} ${service.user?.lastName ?? ""}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              service.user?.address?.city ?? "",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Consumer<ServiceProvider>(
          builder: (context, serviceProvider, child) {
            Brightness brightness = Theme.of(context).brightness;
            bool isDarkMode = brightness == Brightness.dark;
            final price = serviceProvider.service?.data?.specificService?.price;
            return CardyContainer(
              color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
              spreadRadius: 0,
              blurRadius: 1,
              shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
              height: 100,
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Total Price",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Text(
                        "Rs${price ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.fMainColor,
                        radius: 26,
                        child: Consumer<ChattingProvider>(
                            builder: (context, chatProvider, child) {
                          return IconButton(
                            onPressed: () async {
                              await handleConversation(
                                context,
                                chatProvider,
                                serviceProvider
                                    .service!.data!.specificService!.userId!,
                                authProvider.user!.id!,
                              );
                            },
                            icon: const Icon(
                              IconlyLight.chat,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomElevatedButton(
                        width: 150,
                        height: 50,
                        backgroundColor: AppTheme.fMainColor,
                        foregroundColor: Colors.white,
                        text: "Book Now!",
                        onPressed: () {
                          Navigator.push(
                            context,
                            SlidePageRoute(
                              page: BookOrderScreen(
                                service: serviceProvider
                                    .service?.data?.specificService,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
