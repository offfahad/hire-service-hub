import 'package:carded/carded.dart';
import 'package:e_commerce/common/buttons/custom_elevated_button.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/providers/authentication/authentication_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/orders/book_order_screen.dart';
import 'package:e_commerce/screens/service/update_service_screen.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/date_and_time_formatting.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

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
      final isServiceProvider =
          authProvider.user?.role?.title == "service_provider" &&
              authProvider.user?.id ==
                  serviceProvider.service?.data?.specificService?.userId;

      return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("Service Details"),
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
                    onPressed: () {
                      // Handle delete logic
                    },
                  ),
                ]
              : null,
        ),
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
                        const Icon(IconlyLight.calendar),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "FROM ${formatTime(service.startTime.toString())} VALID TILL ${formatTime(service.endTime.toString())}",
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
                              "${service.user?.firstName ?? "Unknown"} ${service.user?.lastName ?? ""}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              service.user?.address?.location ?? "",
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
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        "\$${price ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CustomElevatedButton(
                    width: 200,
                    height: 50,
                    backgroundColor: AppTheme.fMainColor,
                    foregroundColor: Colors.white,
                    text: "Book Order Now!",
                    onPressed: () {
                      Navigator.push(
                        context,
                        SlidePageRoute(
                          page: BookOrderScreen(
                            service:
                                serviceProvider.service?.data?.specificService,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
