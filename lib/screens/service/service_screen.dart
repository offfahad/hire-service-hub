import 'package:carded/carded.dart';
import 'package:e_commerce/models/service/service_model.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
        forceMaterialTransparency: true,
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          } else if (provider.services.isEmpty) {
            return const Center(child: Text('No services available'));
          } else {
            return ListView.builder(
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return ServiceCard(service: service);
              },
            );
          }
        },
      ),
    );
  }
}

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
