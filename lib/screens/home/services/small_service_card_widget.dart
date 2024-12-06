import 'package:carded/carded.dart';
import 'package:e_commerce/common/slide_page_routes/slide_page_route.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/screens/service/service_detail_screen.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class SmallServiceCard extends StatelessWidget {
  final ServiceModel service;

  const SmallServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Navigate to service details page
        Navigator.push(
          context,
          SlidePageRoute(
            page: ServiceDetailsScreen(service: service),
          ),
        );
      },
      child: CardyContainer(
        margin: const EdgeInsets.all(8),
        color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
        spreadRadius: 0,
        blurRadius: 1,
        shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image (Smaller height)
            service.coverPhoto != null && service.coverPhoto!.isNotEmpty
                ? Image.network(
                    '${Constants.baseUrl}${service.coverPhoto}',
                    width: double.infinity,
                    height: 100, // Reduced height
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/content-writer.webp', // Placeholder cover image from assets
                    width: double.infinity,
                    height: 100, // Reduced height
                    fit: BoxFit.cover,
                  ),
            // Service Details (Smaller fonts)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName,
                    style: const TextStyle(
                      fontSize: 14, // Smaller font
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    style: const TextStyle(fontSize: 12), // Smaller font
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        service.city,
                        style: const TextStyle(
                          fontSize: 12, // Smaller font
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Rs${service.price}",
                        style: const TextStyle(
                          fontSize: 12, // Smaller font
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
