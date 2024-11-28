import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/repository/category/category_repository.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  List<Category> _categories = [];
  String? _errorMessage;
  bool _isLoading = false;

  List<Category> get categories => _categories;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _repository.getCategories();

    if (response['success']) {
      _categories = response['data'] as List<Category>;
      filteredCategories = _categories; // Initially, all categories are visible
    } else {
      _errorMessage = response['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Category> filteredCategories = [];

  void searchCategories(String query) {
    if (query.isEmpty) {
      filteredCategories = categories; // Reset to full list when query is empty
    } else {
      filteredCategories = categories
          .where((category) => (category.title ?? "")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
