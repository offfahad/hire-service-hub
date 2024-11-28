import 'package:e_commerce/utils/api_constnsts.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  Future<http.Response> fetchCategories() async {
    final url = Uri.parse("${Constants.baseUrl}${Constants.userCategory}");
    try {
      final response = await http.get(url);
      return response;
    } catch (error) {
      throw Exception("Failed to fetch categories: $error");
    }
  }
}
