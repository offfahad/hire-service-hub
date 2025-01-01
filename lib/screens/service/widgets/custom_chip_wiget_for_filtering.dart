import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/providers/category/category_provider.dart';
import 'package:e_commerce/providers/service/service_filter_provider.dart';
import 'package:e_commerce/utils/app_theme.dart';
import 'package:e_commerce/utils/bottom_sheet_helpers.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: BorderSide(
        color: isDarkMode ? AppTheme.fdarkBlue : Colors.grey,
       
      ),
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
