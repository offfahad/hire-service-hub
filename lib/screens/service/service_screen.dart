// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/service/widgets/custom_chip_wiget_for_filtering.dart';
import 'package:e_commerce/screens/service/widgets/service_card_widget.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  final Category? categoryModel;
  const ServiceScreen({super.key, this.categoryModel});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filterProvider =
          Provider.of<FilterProvider>(context, listen: false);

      if (widget.categoryModel != null && widget.categoryModel!.id != null) {
        // Set the category ID filter on initialization
        filterProvider.setCategory(
          widget.categoryModel!.title!,
          widget.categoryModel!.id!,
        );

        filterProvider.setFilter("Category", widget.categoryModel!.title);

        // Fetch services with applied filters
        Provider.of<ServiceProvider>(context, listen: false)
            .fetchFilterServices(
          categoryId: filterProvider.selectedFilters['CategoryID'],
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(
          "Services",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Consumer<FilterProvider>(
                  builder: (context, filterProvider, child) {
                // Get selected filters
                Map<String, String?> filters = filterProvider.selectedFilters;

                // Trigger API call after the build phase
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Only call the API if there are filter changes
                  Provider.of<ServiceProvider>(context, listen: false)
                      .fetchFilterServices(
                    categoryId: filters['CategoryID'],
                    city: filters['City'],
                    priceRangetype: filters['Price'],
                  );
                });
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(IconlyLight.filter),
                    const SizedBox(width: 10),
                    customChipWidget(
                      context,
                      filterProvider,
                      isDarkMode,
                      "Category",
                      Provider.of<CategoryProvider>(context, listen: false)
                          .categoryNames,
                    ),
                    const SizedBox(width: 10),
                    customChipWidget(
                      context,
                      filterProvider,
                      isDarkMode,
                      "City",
                      Provider.of<ServiceProvider>(context, listen: false)
                          .cityNames,
                    ),
                    const SizedBox(width: 10),
                    customChipWidget(
                      context,
                      filterProvider,
                      isDarkMode,
                      "Price",
                      ["Low To High", "High To Low"],
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Consumer<ServiceProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppTheme.fMainColor,
                  ));
                } else if ((provider.errorMessage ?? "").isNotEmpty) {
                  return Center(child: Text('Error: ${provider.errorMessage}'));
                } else if (provider.filteredServices.isEmpty) {
                  return const Center(child: Text('No services available'));
                } else {
                  return ListView.builder(
                    itemCount: provider.filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = provider.filteredServices[index];
                      return ServiceCard(service: service);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
