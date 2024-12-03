import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  // Track selected filters
  Map<String, String?> selectedFilters = {
    'Category': null,
    'CategoryID': null,
    'City': null,
    'Price': null,
  };

  Map<String, bool> isFilterSelected = {
    'Category': false,
    'CategoryID': false,
    'City': false,
    'Price': false,
  };

  // Set a filter and notify listeners
  void setFilter(String filterType, String? filter) {
    selectedFilters[filterType] = filter;
    isFilterSelected[filterType] = filter != null;
    notifyListeners();
  }

  // Reset a specific filter
  void resetFilter(String filterType) {
    selectedFilters[filterType] = null;
    isFilterSelected[filterType] = false;
    notifyListeners();
  }

  // Get the selected filter for a specific category
  String? getFilter(String filterType) {
    return selectedFilters[filterType];
  }

  bool isFilterApplied(String filterType) {
    return isFilterSelected[filterType] ?? false;
  }

  // Get all selected filters for API request
  Map<String, String?> getSelectedFilters() {
    return selectedFilters;
  }

  // Set the selected category ID when a category is chosen
  void setCategory(String categoryName, String categoryId) {
    // Get the category ID from the categoryProvider using category name
      setFilter('CategoryID', categoryId); // Store category ID in selectedFilters
    }
  }

