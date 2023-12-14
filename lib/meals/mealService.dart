import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant/models/meals_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/meals';

  static Future<List<Meal>> fetchMeals() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  static Future<void> addMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add meal');
    }
  }

  static Future<void> updateMeal(Meal meal) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${meal.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update meal');
    }
  }

  static Future<void> deleteMeal(String mealId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$mealId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete meal');
    }
  }
}
