import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/category_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/categories';

  static Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => Category.fromJson(json))
          .whereType<Category>()
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

// ...

  static Future<void> addCategory(
      String name, String description, String imageUrl) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'strCategory': name,
        'strCategoryDescription': description,
        'strCategoryThumb': imageUrl
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add category');
    }
  }

  static Future<void> updateCategory(
    String categoryId,
    String name,
    String description,
    String imageUrl,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$categoryId'),
      body: {
        'strCategory': name,
        'strCategoryDescription': description,
        'strCategoryThumb': imageUrl, // Ajoutez le champ pour l'image
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

  static Future<void> deleteCategory(String categoryId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$categoryId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

  static Future<List<String>> getCategoryIds() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<String>((json) => json['id'].toString()).toList();
    } else {
      throw Exception('Failed to load category IDs');
    }
  }

  static Future<Category> getCategoryById(String categoryId) async {
    final response = await http.get(Uri.parse('$baseUrl/$categoryId'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to load category');
    }
  }
}
