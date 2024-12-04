import 'package:carded/carded.dart';
import 'package:e_commerce/common/snakbar/custom_snakbar.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false)
          .fetchSingleServiceDetail(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Details"), forceMaterialTransparency: true,),
      body: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          if (serviceProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (serviceProvider.errorMessage != null &&
              serviceProvider.errorMessage!.isNotEmpty) {
            return Center(child: Text(serviceProvider.errorMessage!));
          } else if (serviceProvider.service == null) {
            return const Center(child: Text("No service details available."));
          }

          final service = serviceProvider.service!.data!.specificService!;
          return Column(
            children: [
              // Top Image Section
              // Stack(
              //   children: [],
              // ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Details
                      service.coverPhoto != null
                          ? Image.network(
                              '${Constants.baseUrl}${service.coverPhoto}',
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/content-writer.webp',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                      const SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.serviceName ?? "No Name",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  IconlyBold.star,
                                  color: Colors.amber,
                                ),
                                Text(
                                  serviceProvider.service!.data!.averageRating
                                              .toString() ==
                                          "0"
                                      ? "3.5"
                                      : serviceProvider
                                          .service!.data!.averageRating
                                          .toString(),
                                )
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
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Divider(),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Availablity ",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        leading: const Icon(IconlyLight.time_square),
                        title: Text(
                          "${formatTime(service.startTime.toString())}\n${formatTime(service.endTime.toString())}",
                        ),
                      ),
                      const Divider(),
                      //const SizedBox(height: 12),
                      // Reviews Section
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Reviews",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: serviceProvider.service!.data!.specificService!.reviews ==
                                    null ||
                                serviceProvider.service!.data!.specificService!
                                    .reviews!.isEmpty
                            ? const Center(
                                child: Text(
                                  "No reviews yet!",
                                  style: TextStyle(
                                    fontSize: 16,
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
                                        title:
                                            Text(review.userName ?? "Anonymous"),
                                        subtitle: Text(review.comment ??
                                            "No comment provided."),
                                      ),
                                    )
                                    .toList(), // Convert iterable to a list of widgets
                              ),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8,),
                      // User Information
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Service Provider",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                service.user?.profilePicture ??
                                    "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg",
                              ),
                              radius: 30,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${service.user?.firstName ?? "Unknown"} ${service.user?.lastName ?? "User"}",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  service.city ?? "",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16,),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Static Bottom Navigation Bar
      bottomNavigationBar: Consumer<ServiceProvider>(
        builder: (context, serviceProvider, child) {
          final price = serviceProvider.service?.data?.specificService?.price;
          Brightness brightness = Theme.of(context).brightness;
          bool isDarkMode = brightness == Brightness.dark;
          return CardyContainer(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
            spreadRadius: 0,
            blurRadius: 1,
            shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total Price",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      "\$${price ?? 'N/A'}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // Add to Cart Button
                ElevatedButton(
                  onPressed: () {
                    bool result = serviceProvider.addToCart(widget.serviceId);
                    if (result) {
                      showCustomSnackBar(
                          context, "Service added to cart!", Colors.green);
                    } else {
                      showCustomSnackBar(context,
                          "Service already added in cart!", Colors.red);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text("Add to Cart"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
