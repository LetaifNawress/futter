// meal_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/meals_model.dart';

class MealService {
  static const String baseUrl = 'http://localhost:3000/meals';
  static Future<List<Recipe>> fetchMeals() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['meals'];
      return data.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
