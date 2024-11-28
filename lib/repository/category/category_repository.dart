import 'dart:convert';

import 'package:e_commerce/models/category/category.dart';
import 'package:e_commerce/services/categories/categories_service.dart';

class CategoryRepository {
  final CategoryService _service = CategoryService();

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _service.fetchCategories();
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Parse JSON into List<Category>
        List<Category> categories = (data['data'] as List)
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();

        return {
          "success": true,
          "data": categories,
        };
      } else {
        return {
          "success": false,
          "message": data['message'] ?? "An unknown error occurred.",
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }
}
