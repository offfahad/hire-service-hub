// ignore_for_file: use_build_context_synchronously

import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/providers/service/service_provider.dart';
import 'package:e_commerce/screens/service/widgets/service_card_widget.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/bottom_sheet_helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ServiceScreen extends StatefulWidget {
  final String? passedCategoryID;
  const ServiceScreen({super.key, this.passedCategoryID});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceProvider>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text("Services"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Consumer<FilterProvider>(
                  builder: (context, filterProvider, child) {
                // Get the selected filters from the FilterProvider
                // Get selected filters
                Map<String, String?> filters = filterProvider.selectedFilters;

                // Trigger API call after the build phase
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // Only call the API if there are filter changes
                  Provider.of<ServiceProvider>(context, listen: false)
                      .fetchFilterServices(
                          categoryId:
                              widget.passedCategoryID ?? filters['CategoryID'],
                          city: filters['City'],
                          priceRangetype: filters['Price']);
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
                      ["PLTH", "PHTL"],
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
                  return const Center(child: CircularProgressIndicator());
                } else if ((provider.errorMessage ?? "").isNotEmpty) {
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
          ),
        ],
      ),
    );
  }

  GestureDetector customChipWidget(
    BuildContext context,
    FilterProvider filterProvider,
    bool isDarkMode,
    String title,
    List<String> options,
  ) {
    return GestureDetector(
      onTap: () {
        openFilterBottomSheet(
          context: context,
          title: title,
          options: options,
          onSelect: (String? value) async {
            if (title == "Category") {
              // Get the selected category object from the CategoryProvider based on the category title
              Category selectedCategory =
                  Provider.of<CategoryProvider>(context, listen: false)
                      .categories
                      .firstWhere((category) => category.title == value);

              // Set both the name and ID in the filter provider
              await filterProvider.setCategory(selectedCategory.title!,
                  selectedCategory.id!); // Pass the ID (UUID)
            }
            filterProvider.setFilter(
                title, value); // Set the selected filter for this type

            Navigator.pop(context);
          },
          onReset: () {
            filterProvider
                .resetFilter(title); // Reset the selected filter for this type
            Navigator.pop(context);
          },
        );
      },
      child: Chip(
        label: Text(
          filterProvider.getFilter(title) ?? title,
          style: TextStyle(
            color: filterProvider.isFilterApplied(title)
                ? isDarkMode
                    ? Colors.white
                    : Colors.white
                : isDarkMode
                    ? Colors.white
                    : Colors.black,
          ),
        ),
        backgroundColor: filterProvider.isFilterApplied(title)
            ? isDarkMode
                ? AppTheme.fdarkBlue
                : AppTheme.fMainColor
            : isDarkMode
                ? AppTheme.fdarkBlue
                : Colors.white,
        labelStyle: TextStyle(
          color: filterProvider.isFilterApplied(title)
              ? isDarkMode
                  ? Colors.white
                  : Colors.white
              : isDarkMode
                  ? Colors.white
                  : Colors.black,
        ),
        onDeleted: filterProvider.isFilterApplied(title)
            ? () {
                if (title == "Category") {
                  filterProvider.resetCategoryID();
                }
                filterProvider.resetFilter(title);
              }
            : () {
                openFilterBottomSheet(
                  context: context,
                  title: title,
                  options: options,
                  onSelect: (String? value) async {
                    if (title == "Category") {
                      // Get the selected category object from the CategoryProvider based on the category title
                      Category selectedCategory = Provider.of<CategoryProvider>(
                              context,
                              listen: false)
                          .categories
                          .firstWhere((category) => category.title == value);

                      // Set both the name and ID in the filter provider
                      await filterProvider.setCategory(selectedCategory.title!,
                          selectedCategory.id!); // Pass the ID (UUID)
                    }

                    filterProvider.setFilter(
                        title, value); // Set the selected filter for this type

                    Navigator.pop(context);
                  },
                  onReset: () {
                    if (title == "Category") {
                      filterProvider.resetCategoryID();
                    }
                    filterProvider.resetFilter(title);

                    Navigator.pop(context);
                  },
                );
              },
        deleteIcon: Icon(
          filterProvider.isFilterApplied(title)
              ? Icons.cancel
              : IconlyLight.arrow_down_2,
          color: filterProvider.isFilterApplied(title)
              ? isDarkMode
                  ? Colors.white
                  : Colors.white
              : isDarkMode
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}
