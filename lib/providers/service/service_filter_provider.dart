import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  // Use a map to store selected filters for multiple categories
  Map<String, String?> selectedFilters = {
    'Category': null,
    'City': null,
    'Price': null,
  };

  Map<String, bool> isFilterSelected = {
    'Category': false,
    'City': false,
    'Price': false,
  };

  // Set the filter for a specific category (Category, City, etc.)
  void setFilter(String filterType, String? filter) {
    selectedFilters[filterType] = filter;
    isFilterSelected[filterType] = filter != null;
    notifyListeners();
  }

  // Reset the filter for a specific category
  void resetFilter(String filterType) {
    selectedFilters[filterType] = null;
    isFilterSelected[filterType] = false;
    notifyListeners();
  }

  // Get the selected filter value for a specific category
  String? getFilter(String filterType) {
    return selectedFilters[filterType];
  }

  bool isFilterApplied(String filterType) {
    return isFilterSelected[filterType] ?? false;
  }
}
