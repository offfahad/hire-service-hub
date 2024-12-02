import 'package:carded/carded.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return CardyContainer(
      margin: const EdgeInsets.all(12),
      color: isDarkMode ? AppTheme.fdarkBlue : Colors.white,
      spreadRadius: 0,
      blurRadius: 1,
      shadowColor: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover Image
          service.coverPhoto != null && service.coverPhoto!.isNotEmpty
              ? Image.network(
                  '${Constants.baseUrl}${service.coverPhoto}',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/content-writer.webp', // Placeholder cover image from assets
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),

          // Service Details
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              service.serviceName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
                // Price in Rs format
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location
                    Text(
                      service.city,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rs${service.price}",
                      style: const TextStyle(
                        fontSize: 16,
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
    );
  }
}
