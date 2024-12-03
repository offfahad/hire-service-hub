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
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final List<String> cities = [
    'Lahore',
    'Islamabad',
    'Multan',
    'Sialkot',
    'Karachi',
    'Peshawar',
  ];

  final List<String> categories = [];

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
                      cities,
                    ),
                    const SizedBox(width: 10),
                    Chip(
                      label: const Text("Price Range"),
                      deleteIcon: const Icon(IconlyLight.arrow_down_2),
                      onDeleted: () {
                        // Add logic for price filter here
                      },
                    ),
                  ],
                );
              }),
            ),
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

  // GestureDetector customChipWidget(
  //     BuildContext context,
  //     FilterProvider filterProvider,
  //     bool isDarkMode,
  //     String title,
  //     List<String> options) {
  //   return GestureDetector(
  //     onTap: () {
  //       openFilterBottomSheet(
  //         context: context,
  //         title: title,
  //         options: options,
  //         onSelect: (String? value) {
  //           filterProvider.setFilter(value);
  //           Navigator.pop(context);
  //         },
  //         onReset: () {
  //           filterProvider.resetFilter();
  //           Navigator.pop(context);
  //         },
  //       );
  //     },
  //     child: Chip(
  //       label: Text(
  //         filterProvider.selectedFilter ?? title,
  //         style: TextStyle(
  //           color: filterProvider.isFilterSelected
  //               ? isDarkMode
  //                   ? Colors.white
  //                   : Colors.white // Ensure text is visible on dark background
  //               : isDarkMode
  //                   ? Colors.white
  //                   : Colors
  //                       .black, // Ensure text is visible on light background
  //         ),
  //       ),
  //       backgroundColor: filterProvider.isFilterSelected
  //           ? isDarkMode
  //               ? AppTheme.fdarkBlue // Dark mode selected background
  //               : AppTheme.fMainColor // Light mode selected background
  //           : isDarkMode
  //               ? AppTheme.fdarkBlue // Dark mode default background
  //               : Colors.white, // Light mode default background
  //       labelStyle: TextStyle(
  //         color: filterProvider.isFilterSelected
  //             ? isDarkMode
  //                 ? Colors.white // Text color for selected chip in dark mode
  //                 : Colors.white // Text color for selected chip in light mode
  //             : isDarkMode
  //                 ? Colors.white // Text color for default chip in dark mode
  //                 : Colors.black, // Text color for default chip in light mode
  //       ),
  //       onDeleted: filterProvider.isFilterSelected
  //           ? () => filterProvider.resetFilter()
  //           : () {
  //               openFilterBottomSheet(
  //                 context: context,
  //                 title: title,
  //                 options: options,
  //                 onSelect: (String? value) {
  //                   filterProvider.setFilter(value);
  //                   Navigator.pop(context);
  //                 },
  //                 onReset: () {
  //                   filterProvider.resetFilter();
  //                   Navigator.pop(context);
  //                 },
  //               );
  //             },
  //       deleteIcon: Icon(
  //         filterProvider.isFilterSelected
  //             ? Icons.cancel
  //             : IconlyLight.arrow_down_2,
  //         color: filterProvider.isFilterSelected
  //             ? isDarkMode
  //                 ? Colors.white // Icon color for selected chip in dark mode
  //                 : Colors.white // Icon color for selected chip in light mode
  //             : isDarkMode
  //                 ? Colors.white // Icon color for default chip in dark mode
  //                 : Colors.black, // Icon color for default chip in light mode
  //       ),
  //     ),
  //   );
  GestureDetector customChipWidget(
      BuildContext context,
      FilterProvider filterProvider,
      bool isDarkMode,
      String title,
      List<String> options) {
    return GestureDetector(
      onTap: () {
        openFilterBottomSheet(
          context: context,
          title: title,
          options: options,
          onSelect: (String? value) {
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
            ? () => filterProvider.resetFilter(title)
            : () {
                openFilterBottomSheet(
                  context: context,
                  title: title,
                  options: options,
                  onSelect: (String? value) {
                    filterProvider.setFilter(title, value);
                    Navigator.pop(context);
                  },
                  onReset: () {
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
